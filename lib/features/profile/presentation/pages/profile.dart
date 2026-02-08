import 'package:flutter/material.dart';
import 'package:qr_folio/core/theme/app_colors.dart';
import 'package:qr_folio/core/widgets/wallpaper.dart';
import 'package:qr_folio/features/profile/presentation/widgets/info_tab.dart';
import 'package:qr_folio/features/profile/presentation/widgets/social_tab.dart';
import 'package:qr_folio/features/profile/presentation/widgets/business_tab.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.backgroundPrimary,
        body: Stack(
          children: [
            const Wallpaper(),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: AppColors.textPrimary,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            Center(
                              child: Text(
                                "Edit Your Profile",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: 340,
                          height: 260,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.cardSecondaryBg,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.cardSecondaryBorder,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: 130,
                                    height: 130,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.cardPrimaryBg,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.primaryBlue,
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: AppColors.textOnPrimary,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Profile Picture",
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Upload a professional photo (max 2MB) to personalize your profile.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.textTertiary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const TabBar(
                          dividerColor: AppColors.cardSecondaryBorder,
                          unselectedLabelColor: AppColors.iconPrimary,
                          labelColor: AppColors.iconSecondary,
                          indicatorColor: AppColors.primaryBlue,

                          tabs: [
                            Tab(icon: Icon(Icons.info)),
                            Tab(icon: Icon(Icons.business)),
                            Tab(icon: Icon(Icons.alternate_email)),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [InfoTab(), BusinessTab(), SocialTab()],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
