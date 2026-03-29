import 'package:qr_folio/core/utils/typedef.dart';
import 'package:qr_folio/features/home/domain/repo/user_data_repo.dart';

class UploadPhotoUsecase {
  final UserDataRepo repo;

  UploadPhotoUsecase({required this.repo});

  FutureVoid call(String filePath) async {
    return await repo.uploadPhoto(filePath);
  }
}
