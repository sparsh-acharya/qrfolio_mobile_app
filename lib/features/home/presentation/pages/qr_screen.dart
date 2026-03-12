import 'package:flutter/material.dart';
import 'package:qr_folio/core/theme/app_colors.dart';
import 'package:qr_folio/core/widgets/appbar.dart';
import 'package:qr_folio/core/widgets/navbar.dart';
import 'package:qr_folio/core/widgets/wallpaper.dart';
import 'package:qr_folio/features/home/data/model/user_data_model.dart';
import 'package:qr_folio/features/home/domain/entity/user_data_entity.dart';

class QrScreen extends StatefulWidget {
  final UserDataEntity userData;
  const QrScreen({super.key, required this.userData});

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  int _currentIndex = 3;
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
                    child: Text(
                      "coming soon",
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(color: AppColors.textPrimary),
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
