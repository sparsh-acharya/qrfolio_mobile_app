part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitialState extends AuthState {}
final class AuthLoadingState extends AuthState {}
final class AuthLoginPageState extends AuthState {}
final class AuthRegisterPageState extends AuthState {}
final class AuthenticatedState extends AuthState {
  final AuthUserEntity user;
  AuthenticatedState({required this.user});
}
final class UnauthenticatedState extends AuthState {}
final class AuthFailureState extends AuthState {
  final String message;
  AuthFailureState({required this.message});
}
final class AuthSignupLoadingState extends AuthRegisterPageState {}
final class AuthSendingOtpErrorState extends AuthRegisterPageState {
  final String message;
  AuthSendingOtpErrorState({required this.message});
}
final class AuthEmailOtpSentState extends AuthRegisterPageState {
  final String message;
  AuthEmailOtpSentState({required this.message});
}
final class AuthEmailVerifiedState extends AuthRegisterPageState {
  final String password;
  final String userId;
  AuthEmailVerifiedState({required this.password, required this.userId});
}
final class AuthEmailVeriFailedState extends AuthRegisterPageState {
  final String message;
  AuthEmailVeriFailedState({required this.message});
}
