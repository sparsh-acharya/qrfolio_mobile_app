import 'package:dartz/dartz.dart';
import 'package:qr_folio/core/utils/typedef.dart';
import 'package:qr_folio/features/auth/data/datasource/datasource.dart';
import 'package:qr_folio/features/auth/domain/entity/auth_user_entity.dart';
import 'package:qr_folio/features/auth/domain/repo/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthDatasource datasource;
  AuthRepoImpl({required this.datasource});
  @override
  FutureEither<AuthUserEntity> login({
    required String email,
    required String password,
    required bool rememberMe,
    
  }) async {
    final result = await datasource.login(
      email: email,
      password: password,
      rememberMe: rememberMe,
    );
    return result.fold((failure) => left(failure), (userModel) {
      print('-----------model-------------');
      print(userModel.toString());
      return right(userModel);
    });
  }

  @override
  FutureVoid logout() async {
    final result = await datasource.logout();
    return result.fold((failure) => left(failure), (_) => right(null));
  }

  @override
  FutureEither<String> signUp({
    required String name,
    required String password,
    required String confirmPassword,
    required String email,
    required String phone,
    String? couponCode,
  }) async {
    final result = await datasource.signUp(
      name: name,
      password: password,
      confirmPassword: confirmPassword,
      email: email,
      phone: phone,
      couponCode: couponCode,
    );
    return result.fold((failure) => left(failure), (msg) => right(msg));
  }

  @override
  FutureEither<List<String>> verifyEmail({
    required String email,
    required String otp,
    required String password,
  }) async {
    final result = await datasource.verifyEmail(
      email: email,
      otp: otp,
      password: password,
    );
    return result.fold((failure) => left(failure), (pass) => right(pass));
  }

  @override
  FutureEither<String> forgotPassword({required String email}) async {
    final result = await datasource.forgotPassword(email: email);
    return result.fold((failure) => left(failure), (msg) => right(msg));
  }

  @override
  FutureEither<String> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    final result = await datasource.resetPassword(
      email: email,
      otp: otp,
      newPassword: newPassword,
    );
    return result.fold((failure) => left(failure), (msg) => right(msg));
  }
}
