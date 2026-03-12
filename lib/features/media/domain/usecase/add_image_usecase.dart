import 'package:qr_folio/core/utils/typedef.dart';
import 'package:qr_folio/features/media/domain/repo/media_repo.dart';

class AddImageUsecase {
  final MediaRepo mediaRepo;
  AddImageUsecase({required this.mediaRepo});
  FutureVoid call({
    required String title,
    required String description,
    required String imagePath,
  }) {
    return mediaRepo.addImage(
      title: title,
      description: description,
      imagePath: imagePath,
    );
  }
}
