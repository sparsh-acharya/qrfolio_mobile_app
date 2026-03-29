import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_folio/core/utils/scaffold_messenger_key.dart';
import 'package:qr_folio/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:qr_folio/features/auth/presentation/pages/authpage.dart';
import 'package:qr_folio/features/auth/presentation/pages/login.dart';
import 'package:qr_folio/features/auth/presentation/pages/signup.dart';
import 'package:qr_folio/features/home/presentation/pages/home_bloc_helper.dart';

class AuthBlocHelper extends StatefulWidget {
  const AuthBlocHelper({super.key});

  @override
  State<AuthBlocHelper> createState() => _AuthBlocHelperState();
}

class _AuthBlocHelperState extends State<AuthBlocHelper> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthenticatedState) {
          scaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(
              content: Text(
                "Login Successful",
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.black),
              ),
            ),
          );
        } else if (state is AuthFailureState ||
            state is AuthSendingOtpErrorState ||
            state is AuthEmailVeriFailedState ||
            state is AuthForgotPasswordFailureState ||
            state is AuthResetPasswordFailureState) {
          String message = "";
          if (state is AuthFailureState) message = state.message;
          if (state is AuthSendingOtpErrorState) message = state.message;
          if (state is AuthEmailVeriFailedState) message = state.message;
          if (state is AuthForgotPasswordFailureState) message = state.message;
          if (state is AuthResetPasswordFailureState) message = state.message;
          context.read<AuthBloc>().add(AuthReturnHomeEvent());

          scaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(
              content: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
          // Return to home page on any major auth failure that leaves the user "stuck"
        }
      },
      builder: (context, state) {
        if (state is UnauthenticatedState) {
          return const Authpage();
        } else if (state is AuthLoadingState ||
            state is AuthInitialState ||
            state is AuthFailureState ||
            state is AuthForgotPasswordLoadingState ||
            state is AuthResetPasswordLoadingState) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is AuthenticatedState) {
          // context.read<UserBloc>().add(GetUserDataEvent());
          return const HomeBlocHelper();
        } else if (state is AuthLoginPageState ||
            state is AuthForgotPasswordSuccessState) {
          return LoginPage();
        } else if (state is AuthRegisterPageState ||
            state is AuthEmailOtpSentState ||
            state is AuthSignupLoadingState) {
          return SignupPage();
        } else {
          return const Authpage();
        }
      },
    );
  }
}
