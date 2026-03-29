import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_folio/core/theme/app_colors.dart';
import 'package:qr_folio/features/home/domain/entity/user_data_entity.dart';

/// A fixed-size (1280×720) card widget designed to be rendered offscreen
/// and captured as a shareable image. Matches the premium dark card design.
class ExportCard extends StatelessWidget {
  final UserDataEntity user;

  const ExportCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1280,
      height: 720,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardSecondaryBg,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          children: [
            // Background watermark – faded logo.svg
            Positioned(
              top: 0,
              right: 0,
              child: Opacity(
                opacity: 0.1,
                child: SvgPicture.asset(
                  'assets/icon.svg',
                  colorFilter: ColorFilter.mode(
                    AppColors.chipPrimaryBorder,
                    BlendMode.dst,
                  ),
                  width: 700,
                  height: 700,
                ),
              ),
            ),
            // Decorative rounded-rect shapes (subtle, like reference)
            Positioned(
              top: -500,
              right: 200,
              child: _decorativeShape(1000, 0.8, Colors.indigoAccent),
            ),
            Positioned(
              bottom: -500,
              left: -500,
              child: _decorativeShape(1000, 0.6, Colors.green.withAlpha(150)),
            ),
            Positioned(
              bottom: -500,
              right: -500,
              child: _decorativeShape(1000, 0.4, Colors.green.withAlpha(150)),
            ),

            // Main content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Left section – avatar + info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Profile avatar
                      _buildAvatar(context),
                      const SizedBox(width: 30),
                      // Name
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            user.core.name ?? 'Unknown User',
                            style: Theme.of(context).textTheme.displaySmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.5,
                                  decoration: TextDecoration.none,
                                ),
                          ),
                          const SizedBox(height: 4),
                          // Designation (uppercase)
                          Text(
                            user.professional.designation.toUpperCase(),
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: const Color(0xFF15D1C7),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 2,
                                  decoration: TextDecoration.none,
                                ),
                          ),
                          const SizedBox(height: 30),
                          // Contact rows
                          _contactRow(
                            context,
                            Icons.email_outlined,
                            user.core.email ?? '',
                          ),
                          const SizedBox(height: 18),
                          _contactRow(
                            context,
                            Icons.phone_outlined,
                            user.core.phone,
                          ),
                          const SizedBox(height: 18),
                          _contactRow(
                            context,
                            Icons.location_on_outlined,
                            user.personal.address,
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(width: 40),

                  // Right section – QR code + branding
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // QR code with gradient border
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF09A59D),
                              Color(0xFF295AB7),
                              Color(0xFF8B5CF6),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF295AB7).withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Container(
                          width: 300,
                          height: 300,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.memory(
                              user.qr.imageBytes,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      // "Powered by QR Folio" branding
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Powered by',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: const Color(0xFF94A3B8),
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.none,
                                ),
                          ),
                          const SizedBox(width: 8),
                          SvgPicture.asset(
                            'assets/logo.svg',
                            width: 22,
                            height: 22,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final hasName = user.core.name?.isNotEmpty == true;
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF1A2744),
        border: Border.all(
          color: const Color(0xFF94A3B8).withOpacity(0.4),
          width: 3,
        ),
      ),
      child: user.profilePhotoUrl != null
          ? ClipOval(
              child: Image.network(
                user.profilePhotoUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Text(
                      user.core.name != null && user.core.name!.isNotEmpty
                          ? user.core.name![0].toUpperCase()
                          : 'U',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  );
                },
              ),
            )
          : Center(
              child: Text(
                user.core.name != null && user.core.name!.isNotEmpty
                    ? user.core.name![0].toUpperCase()
                    : 'U',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
    );
  }

  Widget _contactRow(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF94A3B8), size: 22),
        const SizedBox(width: 14),
        Text(
          text.isNotEmpty ? text : '—',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            decoration: TextDecoration.none,
          ),
        ),
      ],
    );
  }

  Widget _decorativeShape(double s, double opacity, Color color) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: s,
        height: s,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, Colors.transparent],
            center: Alignment.center,
            radius: 0.5,
          ),
        ),
      ),
    );
  }
}
