import 'package:qr_folio/core/utils/typedef.dart';
import 'package:qr_folio/features/media/domain/repo/media_repo.dart';

class AddDocumentUsecase {
  final MediaRepo mediaRepo;
  AddDocumentUsecase({required this.mediaRepo});
  FutureVoid call({
    required String title,
    required String description,
    required String documentPath,
  }) {
    return mediaRepo.addDocument(
      title: title,
      description: description,
      documentPath: documentPath,
    );
  }
}
