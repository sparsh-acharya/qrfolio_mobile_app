import 'package:flutter/material.dart';
import 'package:qr_folio/core/theme/app_colors.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 345,
      height: 185,
      decoration: BoxDecoration(
        gradient: AppColors.cardLinGradBorder,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardGradShadow,
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            gradient: AppColors.cardLinGrad,
            borderRadius: BorderRadius.circular(19),
          ),
          child: Stack(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.cardPrimaryBg,
                ),
              ),
              Positioned(
                top: 10,
                left: 80,
                child: Text(
                  "Sparsh Acharya",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Positioned(
                top: 35,
                left: 80,
                child: Text(
                  "Software Developer",
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                child: GestureDetector(
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: AppColors.chipPrimaryBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.edit,
                      color: AppColors.textSecondary,
                      size: 16,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Row(
                  children: [
                    Icon(
                      size: 15,
                      Icons.location_on_outlined,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: 3),
                    Text(
                      "Jaipur, Rajasthan, India",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 25,
                child: Row(
                  children: [
                    Icon(size: 15, Icons.phone, color: AppColors.textSecondary),
                    SizedBox(width: 3),
                    Text(
                      "+91 12345 67890",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 50,
                child: Row(
                  children: [
                    Icon(Icons.mail, size: 15, color: AppColors.textSecondary),
                    SizedBox(width: 3),
                    Text(
                      "mail@gmail.com",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.cardPrimaryBg,
                  ),
                  child: Icon(
                    Icons.qr_code,
                    size: 80,
                    color: AppColors.chipPrimaryBg,
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
