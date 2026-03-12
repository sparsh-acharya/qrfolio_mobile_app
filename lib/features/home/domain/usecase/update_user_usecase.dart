import 'package:qr_folio/core/utils/typedef.dart';
import 'package:qr_folio/features/home/domain/repo/user_data_repo.dart';

class UpdateUserUsecase {
  final UserDataRepo repo;

  UpdateUserUsecase({required this.repo});

  FutureVoid call(Map<String, dynamic> updatedData) async {
    return await repo.updateUserData(updatedData);
  }
}
