import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_folio/core/theme/app_colors.dart';
import 'package:qr_folio/core/widgets/wallpaper.dart';
import 'package:qr_folio/features/home/domain/entity/user_data_entity.dart';
import 'package:qr_folio/features/home/presentation/bloc/user_bloc.dart';
import 'package:qr_folio/features/home/presentation/widgets/info_tab.dart';
import 'package:qr_folio/features/home/presentation/widgets/social_tab.dart';
import 'package:qr_folio/features/home/presentation/widgets/business_tab.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  final UserDataEntity user;
  final int initialIndex;
  const ProfilePage({super.key, required this.user, this.initialIndex = 0});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late Map<String, dynamic> _updatedData;
  late bool updated;
  late final AnimationController _animController;
  late final List<Animation<double>> _fadeAnims;
  late final List<Animation<Offset>> _slideAnims;
  final ImagePicker _picker = ImagePicker();

  static const _itemCount = 4;

  void _updateField(String key, dynamic value) {
    setState(() {
      _updatedData[key] = value;
    });
    print(jsonEncode(_updatedData));
    print(value.runtimeType);
    print("----------update object----------");
    print(_updatedData);
  }

  Future<void> _pickAndUploadImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (image != null) {
      if (mounted) {
        context.read<UserBloc>().add(UploadPhotoEvent(filePath: image.path));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _updatedData = {};
    updated = false;

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
        if (state is UpdatedUserDataState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: TextStyle(color: AppColors.textTertiary),
              ),
            ),
          );
        } else if (state is PhotoUploadedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.green,
            ),
          );
          // Refresh user data after upload
          context.read<UserBloc>().add(GetUserDataEvent());
        } else if (state is PhotoUploadErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is UploadingPhotoState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Uploading photo...",
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textTertiary),
              ),
              duration: Duration(seconds: 1),
            ),
          );
        } else if (state is UserErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: TextStyle(color: AppColors.textTertiary),
              ),
            ),
          );
        }
      },
      child: PopScope(
        onPopInvokedWithResult: (didpop, result) {
          if (didpop && updated) {
            context.read<UserBloc>().add(GetUserDataEvent());
          }
        },
        child: DefaultTabController(
          initialIndex: widget.initialIndex,
          length: 3,
          child: Stack(
            children: [
              const Wallpaper(),
              Scaffold(
                backgroundColor: Colors.transparent,
                body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Column(
                          children: [
                            // 0 – Header bar
                            _animatedItem(
                              0,
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
                                        if (updated) {
                                          context.read<UserBloc>().add(
                                            GetUserDataEvent(),
                                          );
                                        }
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
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      width: 60,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: AppColors.primaryBlue,
                                          width: 1,
                                        ),
                                      ),
                                      child: Center(
                                        child: TextButton(
                                          onPressed: () {
                                            if (_updatedData.isEmpty) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    "No changes to save",
                                                    style: TextStyle(
                                                      color: AppColors
                                                          .textTertiary,
                                                    ),
                                                  ),
                                                ),
                                              );
                                              return;
                                            }
                                            context.read<UserBloc>().add(
                                              UpdateUserDataEvent(
                                                updatedData: _updatedData,
                                              ),
                                            );
                                            updated = true;
                                          },
                                          child: Text('Save'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            // 1 – Profile picture card
                            _animatedItem(
                              1,
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
                                            border: Border.all(
                                              color: AppColors.primaryBlue,
                                              width: 2,
                                            ),
                                          ),
                                          child:
                                              widget.user.profilePhotoUrl !=
                                                  null
                                              ? ClipOval(
                                                  child: Image.network(
                                                    widget
                                                        .user
                                                        .profilePhotoUrl!,
                                                    fit: BoxFit.cover,
                                                    errorBuilder:
                                                        (
                                                          context,
                                                          error,
                                                          stackTrace,
                                                        ) {
                                                          return Center(
                                                            child: Text(
                                                              widget.user.core.name !=
                                                                          null &&
                                                                      widget
                                                                          .user
                                                                          .core
                                                                          .name!
                                                                          .isNotEmpty
                                                                  ? widget
                                                                        .user
                                                                        .core
                                                                        .name![0]
                                                                        .toUpperCase()
                                                                  : 'U',
                                                              style: TextStyle(
                                                                fontSize: 35,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: AppColors
                                                                    .primaryBlue,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                  ),
                                                )
                                              : Center(
                                                  child: Text(
                                                    widget.user.core.name !=
                                                                null &&
                                                            widget
                                                                .user
                                                                .core
                                                                .name!
                                                                .isNotEmpty
                                                        ? widget
                                                              .user
                                                              .core
                                                              .name![0]
                                                              .toUpperCase()
                                                        : 'U',
                                                    style: TextStyle(
                                                      fontSize: 35,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          AppColors.primaryBlue,
                                                    ),
                                                  ),
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
                                            child: IconButton(
                                              onPressed: _pickAndUploadImage,
                                              icon: const Icon(
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
                            ),
                            const SizedBox(height: 10),
                            // 2 – Tab bar
                            _animatedItem(
                              2,
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
                            ),
                            // 3 – Tab content
                            Expanded(
                              child: _animatedItem(
                                3,
                                TabBarView(
                                  children: [
                                    InfoTab(
                                      name: widget.user.core.name!,
                                      phone: widget.user.core.phone,
                                      email: widget.user.core.email!,
                                      location: widget.user.personal.address,
                                      onUpdate: _updateField,
                                    ),
                                    BusinessTab(
                                      onUpdate: _updateField,
                                      company:
                                          widget.user.professional.companyName,
                                      position:
                                          widget.user.professional.designation,
                                      referalCode:
                                          widget.user.professional.referralCode,
                                      companyEmail:
                                          widget.user.professional.companyEmail,
                                      location: widget
                                          .user
                                          .professional
                                          .companyAddress,
                                      experience: widget
                                          .user
                                          .professional
                                          .companyExperience,
                                      description: widget
                                          .user
                                          .professional
                                          .companyDescription,
                                      summary: widget.user.personal.description,
                                    ),
                                    SocialTab(
                                      twitter: widget.user.social.twitter,
                                      linkedin: widget.user.social.linkedin,
                                      instagram: widget.user.social.instagram,
                                      facebook: widget.user.social.facebook,
                                      github: widget.user.social.github,
                                      whatsapp: widget.user.social.whatsapp,
                                      website: widget.user.social.website,
                                      onUpdate: _updateField,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
