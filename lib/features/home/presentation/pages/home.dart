import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_folio/features/home/presentation/bloc/user_bloc.dart';
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

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final int _currentIndex = 0;
  late final AnimationController _animController;
  late final List<Animation<double>> _fadeAnims;
  late final List<Animation<Offset>> _slideAnims;

  /// Number of staggered content sections.
  static const _itemCount = 5;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Build staggered fade & slide animations for each section.
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

  /// Wraps [child] with a fade + slide entry animation for the given [index].
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
        if (state is NavItemSelectedState && state.index == 0) {
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
                        // 0 – Welcome text
                        _animatedItem(
                          0,
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
                        ),
                        const SizedBox(height: 20),

                        // 1 – Profile card
                        _animatedItem(1, ProfileCard(user: widget.userData)),

                        const SizedBox(height: 20),

                        // 2 – QR & Share chips
                        _animatedItem(
                          2,
                          Row(
                            children: [
                              QrIDChip(),
                              const SizedBox(width: 10),
                              ShareProfileChip(),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // 3 – Professional Details
                        _animatedItem(
                          3,
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
                        ),
                        const SizedBox(height: 20),

                        // 4 – Professional Summary
                        _animatedItem(
                          4,
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
