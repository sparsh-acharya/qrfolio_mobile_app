import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:qr_folio/core/errors/failure.dart';
import 'package:qr_folio/core/utils/app_storage.dart';
import 'package:qr_folio/core/utils/constants.dart';
import 'package:qr_folio/core/utils/typedef.dart';
import 'package:qr_folio/features/auth/data/datasource/datasource.dart';
import 'package:qr_folio/features/auth/data/model/auth_user_model.dart';

class AuthDatasourceImpl implements AuthDatasource {
  final Dio dio;

  AuthDatasourceImpl({required this.dio});

  @override
  FutureEither<AuthUserModel> login(
    String email,
    String password,
    bool rememberMe,
  ) async {
    final res = await dio.post(
      '$baseUrl/auth/login',
      data: {"email": email, "password": password, "rememberMe": rememberMe},
    );

    if (res.data['success'] != true) {
      return left(ApiError(message: res.data['message'] ?? 'Login failed'));
    }

    final String token = res.data['token'];
    final String userName = res.data['user']['name'];
    final String userEmail = res.data['user']['email'];
    final bool isVerified = res.data['user']['isVerified'] == true;
    final bool isPaid = res.data['user']['isPaid'] == true;
    if (rememberMe) {
      await AppStorage().saveId(res.data['user']['id']);
      await AppStorage().savePassword(password);
    } else {
      await AppStorage().clearId();
      await AppStorage().clearPassword();
    }
    await AppStorage().saveToken(token);
    await AppStorage().saveName(userName);
    await AppStorage().saveEmail(userEmail);
    await AppStorage().saveIsVerified(isVerified);
    await AppStorage().saveIsPaid(isPaid);

    return right(AuthUserModel.fromJson(res.data));
  }

  @override
  FutureVoid logout() async {
    try {
      await AppStorage().clearToken();
      await AppStorage().clearName();
      await AppStorage().clearEmail();
      await AppStorage().clearIsVerified();
      await AppStorage().clearIsPaid();
      await AppStorage().clearId();
      await AppStorage().clearPassword();

      return right(null);
    } catch (e) {
      return left(ApiError(message: 'Logout failed: $e'));
    }
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
    final res = await dio.post(
      '$baseUrl/auth/signup',
      data: {
        "name": name,
        "password": password,
        "confirmPassword": confirmPassword,
        "email": email,
        "phone": phone,
        if (couponCode != null) "couponCode": couponCode,
      },
    );

    if (res.data['success'] != true) {
      return left(ApiError(message: res.data['message'] ?? 'failed to send otp'));
    }
    return right(res.data['message'] ?? 'Otp sent successfully');
  }

  @override
  FutureEither<String> verifyEmail({
    required String email,
    required String otp,
    required String password,
  }) async {
    final res = await dio.post(
      '$baseUrl/auth/verify-otp',
      data: {
        "email": email,
        "otp": otp,
      },
    );

    if (res.data['success'] != true) {
      return left(ApiError(message: res.data['message'] ?? 'Verification Failed'));
    }
    return right(password);
  }
}
