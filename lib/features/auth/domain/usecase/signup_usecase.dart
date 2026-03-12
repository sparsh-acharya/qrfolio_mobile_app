import 'package:qr_folio/core/utils/typedef.dart';
import 'package:qr_folio/features/auth/domain/repo/auth_repo.dart';

class SignupUsecase {
  final AuthRepo repo;
  SignupUsecase({required this.repo});
  FutureEither<String> call({
    required String name,
    required String password,
    required String confirmPassword,
    required String email,
    required String phone,
    String? couponCode,
  }) {
    return repo.signUp(
      name: name,
      password: password,
      confirmPassword: confirmPassword,
      email: email,
      phone: phone,
      couponCode: couponCode,
    );
  }
}
