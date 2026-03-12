import 'package:qr_folio/core/utils/typedef.dart';
import 'package:qr_folio/features/auth/domain/repo/auth_repo.dart';

class LogoutUsecase {
  final AuthRepo authRepo;
  LogoutUsecase({required this.authRepo});
  FutureVoid call() {
    return authRepo.logout();
  }
}
