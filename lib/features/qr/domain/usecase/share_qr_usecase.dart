import 'package:qr_folio/core/utils/typedef.dart';
import 'package:qr_folio/features/qr/domain/entity/qr_style_entity.dart';
import 'package:qr_folio/features/qr/domain/repo/qr_repo.dart';

class ShareQrUsecase {
  final QrRepo qrRepo;

  ShareQrUsecase({required this.qrRepo});

  FutureVoid call({required String data, required QrStyleEntity style}) {
    return qrRepo.shareQr(data: data, style: style);
  }
}
