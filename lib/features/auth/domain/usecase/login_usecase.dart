import 'package:qr_folio/core/utils/typedef.dart';
import 'package:qr_folio/features/auth/domain/entity/auth_user_entity.dart';
import 'package:qr_folio/features/auth/domain/repo/auth_repo.dart';

class LoginUsecase {
  final AuthRepo repo;

  LoginUsecase({required this.repo});

  FutureEither<AuthUserEntity> call({
    required String email,
    required String password,
    required bool rememberMe,
    
  }) {
    return repo.login(email: email, password: password, rememberMe: rememberMe);
  }
}
