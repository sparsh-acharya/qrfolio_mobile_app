import 'package:flutter/material.dart';
import 'package:qr_folio/core/theme/app_colors.dart';

class ProfessionalDetailsContainer extends StatelessWidget {
  final String companyName;
  final String designation;
  final String experience;
  final String referralCode;

  const ProfessionalDetailsContainer({
    super.key,
    required this.companyName,
    required this.designation,
    required this.experience,
    required this.referralCode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardSecondaryBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardSecondaryBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow("Company Name", companyName),
          const SizedBox(height: 5),
          Divider(color: AppColors.cardSecondaryBorder, height: 2),
          const SizedBox(height: 5),
          _buildDetailRow("Designation", designation),
          const SizedBox(height: 5),
          Divider(color: AppColors.cardSecondaryBorder, height: 2),
          const SizedBox(height: 5),
          _buildDetailRow("Experience", experience),
          const SizedBox(height: 5),
          Divider(color: AppColors.cardSecondaryBorder, height: 2),
          const SizedBox(height: 5),
          _buildDetailRow("Company Referral Code", referralCode),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.primaryBlueLight,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
