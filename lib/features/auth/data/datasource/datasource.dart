import 'package:qr_folio/core/utils/typedef.dart';
import 'package:qr_folio/features/auth/data/model/auth_user_model.dart';

abstract class AuthDatasource {
  FutureEither<AuthUserModel> login({
    required String email,
    required String password,
    required bool rememberMe,
    
  });
  FutureVoid logout();

  FutureEither<String> signUp({
    required String name,
    required String password,
    required String confirmPassword,
    required String email,
    required String phone,
    String? couponCode,
  });

  FutureEither<List<String>> verifyEmail({
    required String email,
    required String otp,
    required String password,
  });
  FutureEither<String> forgotPassword({required String email});
  FutureEither<String> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });
}
