import 'package:qr_folio/features/home/domain/repo/user_data_repo.dart';

class GetUserUsecase {
  final UserDataRepo repo;
  GetUserUsecase({required this.repo});
  Future call() async {
    return await repo.getUserData();
  }
}
