import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_folio/core/utils/profile_nav.dart';
import 'package:qr_folio/features/home/presentation/bloc/user_bloc.dart';
import 'package:qr_folio/core/theme/app_colors.dart';
import 'package:qr_folio/core/widgets/appbar.dart';
import 'package:qr_folio/core/widgets/qr_id_chip.dart';
import 'package:qr_folio/core/widgets/share_profile_chip.dart';
import 'package:qr_folio/core/widgets/wallpaper.dart';
import 'package:qr_folio/core/widgets/navbar.dart';
import 'package:qr_folio/core/widgets/professional_detail_card.dart';
import 'package:qr_folio/features/home/domain/entity/user_data_entity.dart';
import 'package:qr_folio/features/home/presentation/pages/public_profile_screen.dart';
import 'package:share_plus/share_plus.dart';

class ProfessionalDetailPage extends StatefulWidget {
  final UserDataEntity user;
  const ProfessionalDetailPage({super.key, required this.user});
  @override
  State<ProfessionalDetailPage> createState() => _ProfessionalDetailPageState();
}

class _ProfessionalDetailPageState extends State<ProfessionalDetailPage>
    with SingleTickerProviderStateMixin {
  final int _currentIndex = 1;
  late final AnimationController _animController;
  late final List<Animation<double>> _fadeAnims;
  late final List<Animation<Offset>> _slideAnims;

  static const _itemCount = 5;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnims = List.generate(_itemCount, (i) {
      final start = i * 0.15;
      final end = (start + 0.5).clamp(0.0, 1.0);
      return CurvedAnimation(
        parent: _animController,
        curve: Interval(start, end, curve: Curves.easeOut),
      );
    });

    _slideAnims = List.generate(_itemCount, (i) {
      final start = i * 0.15;
      final end = (start + 0.5).clamp(0.0, 1.0);
      return Tween<Offset>(
        begin: const Offset(0, 0.08),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _animController,
          curve: Interval(start, end, curve: Curves.easeOut),
        ),
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animController.forward();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Widget _animatedItem(int index, Widget child) {
    return FadeTransition(
      opacity: _fadeAnims[index],
      child: SlideTransition(position: _slideAnims[index], child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is NavItemSelectedState && state.index == 1) {
          _animController.reset();
          _animController.forward();
        }
      },
      child: Stack(
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
                        // 0 – Title row
                        _animatedItem(
                          0,
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
                                  widget.user,
                                  initialIndex: 1,
                                ),
                                icon: Icon(Icons.edit),
                                iconSize: 20,
                                color: AppColors.primaryBlueLight,
                              ),
                            ],
                          ),
                        ),

                        // 1 – Info cards
                        _animatedItem(
                          1,
                          Row(
                            children: [
                              Expanded(
                                child: ProfInfoCard(
                                  professionalIcons: Icons.apartment,
                                  label: "COMPANY",
                                  value: widget.user.professional.companyName,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ProfInfoCard(
                                  professionalIcons: Icons.person,
                                  label: "DESIGNATION",
                                  value: widget.user.professional.designation,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // 2 – Description container
                        _animatedItem(
                          2,
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
                        ),
                        const SizedBox(height: 20),

                        // 3 – Chips row
                        _animatedItem(
                          3,
                          Row(
                            children: [
                              Expanded(
                                child: QrIDChip(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder:
                                            (
                                              context,
                                              animation,
                                              secondaryAnimation,
                                            ) => PublicProfileScreen(
                                              user: widget.user,
                                            ),
                                        transitionsBuilder:
                                            (
                                              context,
                                              animation,
                                              secondaryAnimation,
                                              child,
                                            ) {
                                              var curve = Curves.fastOutSlowIn;
                                              var curvedAnimation =
                                                  CurvedAnimation(
                                                    parent: animation,
                                                    curve: curve,
                                                  );
                                              return FadeTransition(
                                                opacity: curvedAnimation,
                                                child: SlideTransition(
                                                  position: Tween<Offset>(
                                                    begin: const Offset(
                                                      0.0,
                                                      0.05,
                                                    ),
                                                    end: Offset.zero,
                                                  ).animate(curvedAnimation),
                                                  child: child,
                                                ),
                                              );
                                            },
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ShareProfileChip(
                                  onTap: () {
                                    Share.share(
                                      'https://www.qrfolio.net/profile/${widget.user.xid}',
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // 4 – Professional details container
                        _animatedItem(
                          4,
                          ProfessionalDetailsContainer(
                            companyName: widget.user.professional.companyName,
                            designation: widget.user.professional.designation,
                            experience:
                                "${widget.user.professional.companyExperience} years",
                            referralCode: widget.user.professional.referralCode,
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
      ),
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
      width: double.infinity,
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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
