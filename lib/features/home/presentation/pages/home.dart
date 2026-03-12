import 'package:flutter/material.dart';
import 'package:qr_folio/core/theme/app_colors.dart';
import 'package:qr_folio/core/utils/profile_nav.dart';
import 'package:qr_folio/core/widgets/appbar.dart';
import 'package:qr_folio/core/widgets/navbar.dart';
import 'package:qr_folio/core/widgets/professional_detail_card.dart';
import 'package:qr_folio/core/widgets/qr_id_chip.dart';
import 'package:qr_folio/core/widgets/share_profile_chip.dart';
import 'package:qr_folio/core/widgets/wallpaper.dart';
import 'package:qr_folio/features/home/domain/entity/user_data_entity.dart';
import 'package:qr_folio/features/home/presentation/widgets/profile_card.dart';

class Home extends StatefulWidget {
  final UserDataEntity userData;
  const Home({super.key, required this.userData});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final int _currentIndex = 0;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
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
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Welcome Back, ${widget.userData.core.name}!",

                          style: Theme.of(context).textTheme.displaySmall
                              ?.copyWith(
                                fontSize: 24,
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1,
                              ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      ProfileCard(user: widget.userData),

                      const SizedBox(height: 20),
                      Row(
                        children: [
                          QrIDChip(),
                          const SizedBox(width: 10),
                          ShareProfileChip(),
                        ],
                      ),

                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                  onPressed: () => goTpProfile(
                                    context,
                                    widget.userData,
                                    initialIndex: 1,
                                  ),
                                  icon: Icon(Icons.edit),
                                  iconSize: 20,
                                  color: AppColors.primaryBlueLight,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ProfessionalDetailsContainer(
                              companyName:
                                  widget.userData.professional.companyName,
                              designation:
                                  widget.userData.professional.designation,
                              experience: widget
                                  .userData
                                  .professional
                                  .companyExperience,
                              referralCode:
                                  widget.userData.professional.referralCode,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Professional Summary",
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
                            const SizedBox(height: 10),
                            Text(
                              widget.userData.personal.description,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 12,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
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
