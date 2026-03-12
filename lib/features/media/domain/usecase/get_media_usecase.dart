import 'package:qr_folio/core/utils/typedef.dart';
import 'package:qr_folio/features/media/domain/entity/media_entity.dart';
import 'package:qr_folio/features/media/domain/repo/media_repo.dart';

class GetMediaUsecase {
  final MediaRepo mediaRepo;
  GetMediaUsecase({required this.mediaRepo});
  FutureEither<List<MediaEntity>> call() {
    return mediaRepo.getMediaList();
  }
}
