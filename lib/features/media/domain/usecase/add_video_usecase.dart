import 'package:qr_folio/core/utils/typedef.dart';
import 'package:qr_folio/features/media/domain/repo/media_repo.dart';

class AddVideoUsecase {
  final MediaRepo mediaRepo;
  AddVideoUsecase({required this.mediaRepo});
  FutureVoid call({
    required String title,
    required String description,
    required String videoUrl,
  }) {
    return mediaRepo.addVideo(
      title: title,
      description: description,
      videoUrl: videoUrl,
    );
  }
}
