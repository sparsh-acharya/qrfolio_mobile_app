import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:qr_folio/features/qr/domain/entity/qr_style_entity.dart';
import 'package:qr_folio/features/qr/domain/usecase/copy_qr_link_usecase.dart';
import 'package:qr_folio/features/qr/domain/usecase/export_qr_png_usecase.dart';
import 'package:qr_folio/features/qr/domain/usecase/export_qr_svg_usecase.dart';
import 'package:qr_folio/features/qr/domain/usecase/share_qr_usecase.dart';

part 'qr_event.dart';
part 'qr_state.dart';

class QrBloc extends Bloc<QrEvent, QrState> {
  final ExportQrPngUsecase exportQrPngUsecase;
  final ExportQrSvgUsecase exportQrSvgUsecase;
  final CopyQrLinkUsecase copyQrLinkUsecase;
  final ShareQrUsecase shareQrUsecase;

  QrBloc({
    required this.exportQrPngUsecase,
    required this.exportQrSvgUsecase,
    required this.copyQrLinkUsecase,
    required this.shareQrUsecase,
  }) : super(QrInitial()) {
    on<QrDownloadPngEvent>(_onDownloadPng);
    on<QrDownloadSvgEvent>(_onDownloadSvg);
    on<QrCopyLinkEvent>(_onCopyLink);
    on<QrShareEvent>(_onShareQr);
  }

  FutureOr<void> _onDownloadPng(
    QrDownloadPngEvent event,
    Emitter<QrState> emit,
  ) async {
    emit(QrActionInProgress('Exporting PNG...'));
    final result = await exportQrPngUsecase(
      data: event.data,
      style: event.style,
    );

    result.fold(
      (failure) => emit(QrActionFailure(failure.message)),
      (path) => emit(QrActionSuccess('PNG saved at: $path')),
    );
  }

  FutureOr<void> _onDownloadSvg(
    QrDownloadSvgEvent event,
    Emitter<QrState> emit,
  ) async {
    emit(QrActionInProgress('Exporting SVG...'));
    final result = await exportQrSvgUsecase(
      data: event.data,
      style: event.style,
    );

    result.fold(
      (failure) => emit(QrActionFailure(failure.message)),
      (path) => emit(QrActionSuccess('SVG saved at: $path')),
    );
  }

  FutureOr<void> _onCopyLink(
    QrCopyLinkEvent event,
    Emitter<QrState> emit,
  ) async {
    emit(QrActionInProgress('Copying link...'));
    final result = await copyQrLinkUsecase(url: event.url);

    result.fold(
      (failure) => emit(QrActionFailure(failure.message)),
      (_) => emit(QrActionSuccess('Link copied to clipboard')),
    );
  }

  FutureOr<void> _onShareQr(QrShareEvent event, Emitter<QrState> emit) async {
    emit(QrActionInProgress('Preparing share...'));
    final result = await shareQrUsecase(data: event.data, style: event.style);

    result.fold(
      (failure) => emit(QrActionFailure(failure.message)),
      (_) => emit(QrActionSuccess('Share sheet opened')),
    );
  }
}
