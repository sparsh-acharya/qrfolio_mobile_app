import 'package:flutter/material.dart';
import 'package:qr_folio/core/theme/app_colors.dart';

class Wallpaper extends StatelessWidget {
  const Wallpaper({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(gradient: AppColors.backgroundLinGrad),
      ),
    );
  }
}
