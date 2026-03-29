import 'package:qr_folio/core/utils/typedef.dart';
import 'package:qr_folio/features/auth/domain/repo/auth_repo.dart';

class ResetPasswordUsecase {
  final AuthRepo repo;

  ResetPasswordUsecase({required this.repo});

  FutureEither<String> call({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    return await repo.resetPassword(
      email: email,
      otp: otp,
      newPassword: newPassword,
    );
  }
}
