import 'package:qr_folio/core/utils/typedef.dart';
import 'package:qr_folio/features/auth/domain/entity/auth_user_entity.dart';

abstract class AuthRepo {
  FutureEither<AuthUserEntity> login(String email, String password,bool rememberMe);
  FutureVoid logout();
  FutureEither<String> signUp({
    required String name,
    required String password,
    required String confirmPassword,
    required String email,
    required String phone,
    String? couponCode,
  });

  FutureEither<String> verifyEmail({required String email, required String otp, required String password});

}
