import 'package:flutter/material.dart';
import 'package:qr_folio/core/theme/app_colors.dart';

class QrIDChip extends StatelessWidget {
  final VoidCallback? onTap;
  const QrIDChip({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.chipSecondaryBg,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: AppColors.chipSecondaryBorder,
            width: 1,
          ),
        ),
        child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(0xFF182753),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.remove_red_eye,
              color: Color(0xFFA7C8FF),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            "Qr ID card",
            style: TextStyle(
              color: AppColors.textOnPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ));
  }
}
