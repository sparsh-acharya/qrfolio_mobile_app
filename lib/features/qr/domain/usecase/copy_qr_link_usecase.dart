import 'package:qr_folio/core/utils/typedef.dart';
import 'package:qr_folio/features/qr/domain/repo/qr_repo.dart';

class CopyQrLinkUsecase {
  final QrRepo qrRepo;

  CopyQrLinkUsecase({required this.qrRepo});

  FutureVoid call({required String url}) {
    return qrRepo.copyLink(url: url);
  }
}
