import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr/qr.dart';
import 'package:qr_folio/core/errors/failure.dart';
import 'package:qr_folio/core/utils/typedef.dart';
import 'package:qr_folio/features/qr/data/datasource/qr_datasource.dart';
import 'package:qr_folio/features/qr/domain/entity/qr_style_entity.dart';
import 'package:share_plus/share_plus.dart';

class QrDatasourceImpl implements QrDatasource {
  static const MethodChannel _nativeShareChannel = MethodChannel(
    'com.example.qr_folio/share',
  );

  Future<Directory> _exportDirectory() async {
    late final Directory dir;

    if (Platform.isAndroid) {
      dir = Directory('/storage/emulated/0/Download/QRFolio');
    } else {
      final downloads = await getDownloadsDirectory();
      if (downloads == null) {
        throw const FileSystemException('Downloads directory is unavailable');
      }
      dir = downloads;
    }

    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  PrettyQrDecoration _buildDecoration(QrStyleEntity style) {
    return PrettyQrDecoration(
      image: style.showCenterLogo
          ? const PrettyQrDecorationImage(
              image: Svg('assets/logo.svg'),
              scale: 0.2,
            )
          : null,
      background: Color(style.backgroundColorValue),
      quietZone: PrettyQrQuietZone.modules(style.marginModules),
      shape: PrettyQrShape.custom(
        PrettyQrSquaresSymbol(color: Color(style.qrColorValue)),
      ),
    );
  }

  String _hexColor(int colorValue) {
    final color = Color(colorValue);
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  Future<String> _buildSvgMarkup({
    required String data,
    required QrStyleEntity style,
  }) async {
    final qrCode = QrCode.fromData(
      data: data,
      errorCorrectLevel: style.errorCorrectLevel,
    );
    final qrImage = QrImage(qrCode);

    final int quietZone = style.marginModules.round().clamp(0, 20);
    final int moduleCount = qrCode.moduleCount;
    const int modulePx = 10;
    final int totalModules = moduleCount + (quietZone * 2);
    final int size = totalModules * modulePx;

    final StringBuffer buffer = StringBuffer()
      ..writeln('<?xml version="1.0" encoding="UTF-8"?>')
      ..writeln(
        '<svg xmlns="http://www.w3.org/2000/svg" width="$size" height="$size" viewBox="0 0 $size $size">',
      )
      ..writeln(
        '<rect x="0" y="0" width="$size" height="$size" fill="${_hexColor(style.backgroundColorValue)}"/>',
      );

    for (int y = 0; y < moduleCount; y++) {
      for (int x = 0; x < moduleCount; x++) {
        if (qrImage.isDark(y, x)) {
          final int svgX = (x + quietZone) * modulePx;
          final int svgY = (y + quietZone) * modulePx;
          buffer.writeln(
            '<rect x="$svgX" y="$svgY" width="$modulePx" height="$modulePx" fill="${_hexColor(style.qrColorValue)}"/>',
          );
        }
      }
    }

    if (style.showCenterLogo) {
      try {
        final logoRaw = await rootBundle.loadString('assets/logo.svg');
        final logoBase64 = base64Encode(utf8.encode(logoRaw));
        final logoSize = (size * 0.2).round();
        final logoOffset = ((size - logoSize) / 2).round();

        buffer
          ..writeln(
            '<rect x="$logoOffset" y="$logoOffset" width="$logoSize" height="$logoSize" rx="12" ry="12" fill="${_hexColor(style.backgroundColorValue)}"/>',
          )
          ..writeln(
            '<image href="data:image/svg+xml;base64,$logoBase64" x="$logoOffset" y="$logoOffset" width="$logoSize" height="$logoSize"/>',
          );
      } catch (_) {
        // SVG generation still succeeds if logo embedding fails.
      }
    }

    buffer.writeln('</svg>');
    return buffer.toString();
  }

  @override
  FutureEither<String> exportPng({
    required String data,
    required QrStyleEntity style,
  }) async {
    try {
      final qrCode = QrCode.fromData(
        data: data,
        errorCorrectLevel: style.errorCorrectLevel,
      );

      final qrImage = QrImage(qrCode);

      // Export at a high raster size so downloads remain sharp when zoomed.
      final int exportSize = math.max(1024, style.pxSize.round() * 6);
      final bytes = await qrImage.toImageAsBytes(
        size: exportSize,
        format: ui.ImageByteFormat.png,
        decoration: _buildDecoration(style),
      );

      if (bytes == null) {
        return left(ApiError(message: 'Failed to generate PNG bytes'));
      }

      final dir = await _exportDirectory();
      final path =
          '${dir.path}/qr_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(path);
      await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);

      return right(path);
    } catch (e) {
      return left(ApiError(message: 'PNG export failed: $e'));
    }
  }

  @override
  FutureEither<String> exportSvg({
    required String data,
    required QrStyleEntity style,
  }) async {
    try {
      final svg = await _buildSvgMarkup(data: data, style: style);
      final dir = await _exportDirectory();
      final path =
          '${dir.path}/qr_${DateTime.now().millisecondsSinceEpoch}.svg';
      final file = File(path);
      await file.writeAsString(svg, flush: true);

      return right(path);
    } catch (e) {
      return left(ApiError(message: 'SVG export failed: $e'));
    }
  }

  @override
  FutureVoid copyLink({required String url}) async {
    try {
      await Clipboard.setData(ClipboardData(text: url));
      return right(null);
    } catch (e) {
      return left(ApiError(message: 'Failed to copy link: $e'));
    }
  }

  @override
  FutureVoid shareQr({
    required String data,
    required QrStyleEntity style,
  }) async {
    try {
      final pngResult = await exportPng(data: data, style: style);
      Failure? failure;
      String? savedPath;
      pngResult.fold((f) => failure = f, (path) => savedPath = path);

      if (failure != null || savedPath == null) {
        return left(
          failure ?? ApiError(message: 'Share failed while exporting PNG'),
        );
      }

      if (Platform.isAndroid) {
        await _nativeShareChannel.invokeMethod('shareFileAndText', {
          'filePath': savedPath,
          'text': data,
        });
      } else {
        await Share.shareXFiles([XFile(savedPath!)], text: data);
      }

      return right(null);
    } on MissingPluginException {
      return left(
        ApiError(
          message:
              'Share plugin/channel is unavailable in the current run. Please fully restart/reinstall the app build.',
        ),
      );
    } catch (e) {
      return left(ApiError(message: 'Share failed: $e'));
    }
  }
}
