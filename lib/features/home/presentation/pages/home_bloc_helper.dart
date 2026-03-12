import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_folio/features/home/domain/entity/user_data_entity.dart';
import 'package:qr_folio/features/home/presentation/bloc/user_bloc.dart';
import 'package:qr_folio/features/home/presentation/pages/home.dart';
import 'package:qr_folio/features/home/presentation/pages/media_helper_page.dart';
import 'package:qr_folio/features/home/presentation/pages/qr_screen.dart';
import 'package:qr_folio/features/auth/presentation/pages/settings.dart';
import 'package:qr_folio/features/media/presentation/pages/media_page.dart';
import 'package:qr_folio/features/home/presentation/pages/professional_detail_page.dart';
import 'package:qr_folio/features/home/presentation/pages/profile.dart';

class HomeBlocHelper extends StatefulWidget {
  const HomeBlocHelper({super.key});

  @override
  State<HomeBlocHelper> createState() => _HomeBlocHelperState();
}

class _HomeBlocHelperState extends State<HomeBlocHelper> {
  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(GetUserDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.black),
              ),
            ),
          );
        } else if (state is UserLoadedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "User Data Loaded Successfully",
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.black),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is UserLoadingState || state is UserInitialState) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is UserErrorState) {
          print(state.message);
          return Scaffold(
            body: Center(
              child: Text(
                state.message,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.white),
              ),
            ),
          );
        } else if (state is NavItemSelectedState) {
          return Scaffold(
            body: IndexedStack(
              index: state.index,
              children: [
                Home(userData: state.user),
                ProfessionalDetailPage(user: state.user),
                MediaHelperPage(user: state.user),
                QrScreen(userData: state.user),
                SettingsPage(userData: state.user),
              ],
            ),
          );
        } else {
          return Center(
            child: Text(
              "Unexpected State: ${state.runtimeType}",
              style: TextStyle(color: Colors.white),
            ),
          );
        }
      },
    );
  }
}
