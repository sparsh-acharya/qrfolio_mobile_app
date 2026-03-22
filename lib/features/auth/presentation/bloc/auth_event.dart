part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthLoginPageEvent extends AuthEvent {}

final class AuthRegisterPageEvent extends AuthEvent {}

final class AuthLoginEvent extends AuthEvent {
  final String email;
  final String password;
  final bool rememberMe;
  

  AuthLoginEvent({
    required this.email,
    required this.password,
    required this.rememberMe,

  });
}

final class AuthLogoutEvent extends AuthEvent {}

final class AuthCheckEvent extends AuthEvent {}

final class AuthReturnHomeEvent extends AuthEvent {}

final class AuthSignUpEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final String phone;
  final String? couponCode;

  AuthSignUpEvent({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.phone,
    this.couponCode,
  });
}

final class AuthVerifyEmailEvent extends AuthEvent {
  final String email;
  final String otp;
  final String password;

  AuthVerifyEmailEvent({
    required this.email,
    required this.otp,
    required this.password,
  });
}
