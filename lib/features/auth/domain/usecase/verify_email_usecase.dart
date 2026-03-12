import 'package:qr_folio/core/utils/typedef.dart';
import 'package:qr_folio/features/auth/domain/repo/auth_repo.dart';

class VerifyEmailUsecase {
  final AuthRepo repo;

  VerifyEmailUsecase({required this.repo});

  FutureEither<String> call({
    required String email,
    required String otp,
    required String password,
  }) async {
    return await repo.verifyEmail(
      email: email,
      otp: otp,
      password: password,
    );
  }
}
