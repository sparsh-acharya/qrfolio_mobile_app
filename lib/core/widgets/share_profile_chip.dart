
import 'package:flutter/material.dart';
import 'package:qr_folio/core/theme/app_colors.dart';

class ShareProfileChip extends StatelessWidget {
  const ShareProfileChip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      width: 155,
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.chipPrimaryBg,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: AppColors.chipPrimaryBorder,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(0xFF0F4744),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.share,
              color: AppColors.chipPrimaryBorder,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            "Share Profile",
            style: TextStyle(
              color: AppColors.textOnPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
