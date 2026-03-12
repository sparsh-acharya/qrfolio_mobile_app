import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:qr_folio/features/auth/domain/entity/auth_user_entity.dart';
import 'package:qr_folio/features/auth/domain/usecase/login_usecase.dart';
import 'package:qr_folio/features/auth/domain/usecase/logout_usecase.dart';
import 'package:qr_folio/core/utils/app_storage.dart';
import 'package:qr_folio/features/auth/domain/usecase/signup_usecase.dart';
import 'package:qr_folio/features/auth/domain/usecase/verify_email_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase loginUsecase;
  final LogoutUsecase logoutUsecase;
  final SignupUsecase signupUsecase;
  final VerifyEmailUsecase verifyEmailUsecase;
  final AppStorage appStorage = AppStorage();
  AuthBloc({
    required this.loginUsecase,
    required this.logoutUsecase,
    required this.signupUsecase,
    required this.verifyEmailUsecase,
  }) : super(AuthInitialState()) {

    on<AuthLoginEvent>(_onlogin);
    on<AuthLogoutEvent>(_onlogout);
    on<AuthCheckEvent>(_oncheck);
    on<AuthSignUpEvent>(_onsignup);
    on<AuthVerifyEmailEvent>(_onverifyemail);
    on<AuthLoginPageEvent>((event, emit) {
      emit(AuthLoginPageState());
    });
    on<AuthRegisterPageEvent>((event, emit) {
      emit(AuthRegisterPageState());
    });
  }

  FutureOr<void> _onlogin(AuthLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    final result = await loginUsecase(
      event.email,
      event.password,
      event.rememberMe,
    );

    result.fold(
      (failure) => emit(AuthFailureState(message: failure.message)),
      (user) => emit(AuthenticatedState(user: user)),
    );
  }

  FutureOr<void> _onlogout(
    AuthLogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    final result = await logoutUsecase();

    result.fold(
      (failure) => emit(AuthFailureState(message: failure.message)),
      (_) => emit(UnauthenticatedState()),
    );
  }

  FutureOr<void> _oncheck(AuthCheckEvent event, Emitter<AuthState> emit) async {
    final String? id = await appStorage.getId();
    if (id != null) {
      final String? password = await appStorage.getPassword();
      final String? email = await appStorage.getEmail();
      if (password != null && email != null) {
        add(AuthLoginEvent(email: email, password: password, rememberMe: true));
        return;
      } else {
        emit(UnauthenticatedState());
        return;
      }
    } else {
      emit(UnauthenticatedState());
      return;
    }
  }

  FutureOr<void> _onsignup(AuthSignUpEvent event, Emitter<AuthState> emit) async{
    emit(AuthSignupLoadingState());
    final result = await signupUsecase(
      name: event.name,
      email: event.email,
      password: event.password,
      confirmPassword: event.confirmPassword,
      phone: event.phone,
      couponCode: event.couponCode,
    );
    result.fold(
      (failure) => emit(AuthSendingOtpErrorState(message: failure.message)),
      (msg) => emit(AuthEmailOtpSentState(message: msg)),
    );

  }

  FutureOr<void> _onverifyemail(AuthVerifyEmailEvent event, Emitter<AuthState> emit) async  {
    emit(AuthSignupLoadingState());
    final result = await verifyEmailUsecase(
      email: event.email,
      otp: event.otp,
      password: event.password,
    );
    result.fold(
      (failure) => emit(AuthEmailVeriFailedState(message: failure.message)),
      (password) => emit(AuthEmailVerifiedState(password: password)),
    );
  }
}
