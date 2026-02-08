import 'package:flutter/material.dart';
import 'package:qr_folio/core/theme/app_colors.dart';

class QrIDChip extends StatelessWidget {
  const QrIDChip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      width: 155,
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
    );
  }
}
