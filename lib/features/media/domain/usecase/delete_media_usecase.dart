import 'package:qr_folio/core/utils/typedef.dart';
import 'package:qr_folio/features/media/domain/repo/media_repo.dart';

class DeleteMediaUsecase {
  final MediaRepo mediaRepo;
  DeleteMediaUsecase({required this.mediaRepo});

  FutureVoid call({required String mediaId}) {
    return mediaRepo.deleteMedia(mediaId: mediaId);
  }
}
