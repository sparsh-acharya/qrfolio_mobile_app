import 'package:qr_folio/core/utils/typedef.dart';
import 'package:qr_folio/features/qr/domain/entity/qr_style_entity.dart';

abstract class QrDatasource {
  FutureEither<String> exportPng({
    required String data,
    required QrStyleEntity style,
  });

  FutureEither<String> exportSvg({
    required String data,
    required QrStyleEntity style,
  });

  FutureVoid copyLink({required String url});

  FutureVoid shareQr({required String data, required QrStyleEntity style});
}
