import 'package:qr_folio/core/utils/typedef.dart';
import 'package:qr_folio/features/auth/domain/repo/auth_repo.dart';

class ForgotPasswordUsecase {
  final AuthRepo repo;

  ForgotPasswordUsecase({required this.repo});

  FutureEither<String> call({required String email}) async {
    return await repo.forgotPassword(email: email);
  }
}
