import 'package:flutter/material.dart';
import 'package:qr_folio/core/theme/app_colors.dart';

class Appbar extends StatelessWidget {
  const Appbar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: 90,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'QR Folio',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    width: 80,
                    height: 27,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: AppColors.chipPrimaryBorder,
                        width: 1,
                      ),
                      color: AppColors.chipPrimaryBg,
                    ),
                    child: const Center(
                      child: Text(
                        "Premium",
                        style: TextStyle(
                          color: AppColors.chipPrimaryBorder,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Avatar circle
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/profile');
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.cardPrimaryBg,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.person,
                      color: AppColors.chipSecondaryBg,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
