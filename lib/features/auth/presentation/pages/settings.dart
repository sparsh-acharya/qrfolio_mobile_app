import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_folio/core/theme/app_colors.dart';
import 'package:qr_folio/core/widgets/appbar.dart';
import 'package:qr_folio/core/widgets/navbar.dart';
import 'package:qr_folio/core/widgets/wallpaper.dart';
import 'package:qr_folio/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:qr_folio/features/home/domain/entity/user_data_entity.dart';

class SettingsPage extends StatefulWidget {
  final UserDataEntity userData;
  const SettingsPage({super.key, required this.userData});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final int _currentIndex = 4;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Wallpaper(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(90),
            child: Appbar(user: widget.userData),
          ),
          body: SafeArea(
            top: false,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Scrollable main content
                SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    bottom: 120,
                    left: 20,
                    right: 20,
                    top: 10,
                  ),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(AuthLogoutEvent());
                      },
                      child: Text("logout"),
                    ),
                  ),
                ),
                Navbar(currentIndex: _currentIndex),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
