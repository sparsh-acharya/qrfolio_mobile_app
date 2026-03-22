import 'package:dartz/dartz.dart';
import 'package:qr_folio/core/utils/typedef.dart';
import 'package:qr_folio/features/qr/data/datasource/qr_datasource.dart';
import 'package:qr_folio/features/qr/domain/entity/qr_style_entity.dart';
import 'package:qr_folio/features/qr/domain/repo/qr_repo.dart';

class QrRepoImpl implements QrRepo {
  final QrDatasource qrDatasource;

  QrRepoImpl({required this.qrDatasource});

  @override
  FutureEither<String> exportPng({
    required String data,
    required QrStyleEntity style,
  }) async {
    final result = await qrDatasource.exportPng(data: data, style: style);
    return result.fold((failure) => left(failure), (path) => right(path));
  }

  @override
  FutureEither<String> exportSvg({
    required String data,
    required QrStyleEntity style,
  }) async {
    final result = await qrDatasource.exportSvg(data: data, style: style);
    return result.fold((failure) => left(failure), (path) => right(path));
  }

  @override
  FutureVoid copyLink({required String url}) async {
    final result = await qrDatasource.copyLink(url: url);
    return result.fold((failure) => left(failure), (_) => right(null));
  }

  @override
  FutureVoid shareQr({
    required String data,
    required QrStyleEntity style,
  }) async {
    final result = await qrDatasource.shareQr(data: data, style: style);
    return result.fold((failure) => left(failure), (_) => right(null));
  }
}
