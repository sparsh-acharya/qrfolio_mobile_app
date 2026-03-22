import 'package:qr_folio/core/utils/typedef.dart';
import 'package:qr_folio/features/qr/domain/entity/qr_style_entity.dart';
import 'package:qr_folio/features/qr/domain/repo/qr_repo.dart';

class ExportQrSvgUsecase {
  final QrRepo qrRepo;

  ExportQrSvgUsecase({required this.qrRepo});

  FutureEither<String> call({
    required String data,
    required QrStyleEntity style,
  }) {
    return qrRepo.exportSvg(data: data, style: style);
  }
}
