import 'package:flutter/material.dart';
import 'package:qr_folio/core/theme/app_colors.dart';
import 'package:qr_folio/core/widgets/appbar.dart';
import 'package:qr_folio/core/widgets/qr_id_chip.dart';
import 'package:qr_folio/core/widgets/share_profile_chip.dart';
import 'package:qr_folio/core/widgets/wallpaper.dart';
import 'package:qr_folio/core/widgets/navbar.dart';
import 'package:qr_folio/core/widgets/professional_detail_card.dart';
import 'package:qr_folio/features/home/domain/entity/user_data_entity.dart';

class ProfessionalDetailPage extends StatefulWidget {
  final UserDataEntity user;
  const ProfessionalDetailPage({super.key, required this.user});
  @override
  State<ProfessionalDetailPage> createState() => _ProfessionalDetailPageState();
}

class _ProfessionalDetailPageState extends State<ProfessionalDetailPage> {
  final int _currentIndex = 1;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Wallpaper(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(90),
            child: Appbar(user: widget.user),
          ),
          body: SafeArea(
            top: false,
            child: Stack(
              fit: StackFit.expand,
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    bottom: 120,
                    left: 20,
                    right: 20,
                    top: 10,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Professional Details",
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.edit),
                            iconSize: 20,
                            color: AppColors.primaryBlueLight,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          ProfInfoCard(
                            professionalIcons: Icons.apartment,
                            label: "COMPANY",
                            value: widget.user.professional.companyName,
                          ),
                          const SizedBox(width: 10),
                          ProfInfoCard(
                            professionalIcons: Icons.person,
                            label: "DESIGNATION",
                            value: widget.user.professional.designation,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.cardSecondaryBg,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.cardSecondaryBorder,
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadowLight,
                              blurRadius: 10,
                              spreadRadius: 0,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          widget.user.personal.description,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 12,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          QrIDChip(),
                          const SizedBox(width: 10),
                          ShareProfileChip(),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ProfessionalDetailsContainer(
                        companyName: widget.user.professional.companyName,
                        designation: widget.user.professional.designation,
                        experience: "${widget.user.professional.companyExperience} years",
                        referralCode: widget.user.professional.referralCode,
                      ),
                    ],
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

class ProfInfoCard extends StatelessWidget {
  const ProfInfoCard({
    super.key,
    required IconData professionalIcons,
    required this.label,
    required this.value,
  }) : _professionalIcons = professionalIcons;

  final IconData _professionalIcons;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: 155,
      height: 145,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(_professionalIcons, size: 50, color: AppColors.iconPrimary),
              const SizedBox(height: 5),
              Text(
                label,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
