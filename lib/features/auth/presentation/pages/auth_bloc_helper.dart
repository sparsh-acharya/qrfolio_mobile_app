import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_folio/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:qr_folio/features/auth/presentation/pages/authpage.dart';
import 'package:qr_folio/features/auth/presentation/pages/login.dart';
import 'package:qr_folio/features/auth/presentation/pages/signup.dart';
import 'package:qr_folio/features/home/presentation/bloc/user_bloc.dart';
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
        if(state is AuthenticatedState){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Login Successful",style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black),)),
          );
        }
      },
      builder: (context, state) {
        if(state is UnauthenticatedState){
          return const Authpage();
        } else if(state is AuthLoadingState || state is AuthInitialState ){
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if(state is AuthFailureState){
          return Scaffold(
            body: Center(child: Text(state.message,style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),)),
          );
        } else if(state is AuthenticatedState){
          // context.read<UserBloc>().add(GetUserDataEvent());
          return const HomeBlocHelper();
        } else if (state is AuthLoginPageState){
          return LoginPage();
        } else if (state is AuthRegisterPageState){
          return SignupPage();
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
