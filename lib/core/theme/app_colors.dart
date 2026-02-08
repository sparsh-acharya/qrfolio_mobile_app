import 'package:flutter/material.dart';

/// Centralized color palette for the app
/// Premium light theme with white and light blue colors
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Primary Colors - Light Blue Palette
  static const Color primaryBlue = Color(0xFF4A90E2);
  static const Color primaryBlueLight = Color(0xFF6BA3E8);
  static const Color primaryBlueDark = Color(0xFF357ABD);
  static const Color primaryBlueAccent = Color(0xFF5BA0F0);
  static const Color primaryBlueXDark = Color(0xFF0066CC);

  // Secondary Colors - Soft Blue Tones
  static const Color secondaryBlue = Color(0xFF7BB3F0);
  static const Color secondaryBlueLight = Color(0xFFA8D0F5);
  static const Color secondaryBlueDark = Color(0xFF5A8FC8);

  // Background Colors - White & Light Grays
  static const Color backgroundPrimary = Color(0xFF0D1427);
  static const LinearGradient backgroundLinGrad = LinearGradient(
    colors: [Color(0xFF0D1427), Color(0xFF000511)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const Color backgroundSecondary = Color(0xFFF8FAFC);
  static const Color backgroundTertiary = Color(0xFFF1F5F9);
  static const Color backgroundElevated = Color(0xFFFFFFFF);

  // Surface Colors
  static const Color surfacePrimary = Color(0xFFFFFFFF);
  static const Color surfaceSecondary = Color(0xFFF8FAFC);
  static const Color surfaceElevated = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF15D1C7);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textInverse = Color(0xFFFFFFFF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Border & Divider Colors
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color borderMedium = Color(0xFFCBD5E1);
  static const Color divider = Color(0xFFE2E8F0);

  // Accent Colors
  static const Color accentTeal = Color(0xFF14B8A6);
  static const Color accentTealLight = Color(0xFF5EEAD4);
  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color accentPurpleLight = Color(0xFFA78BFA);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, primaryBlueLight, accentTeal],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [primaryBlueLight, secondaryBlueLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFE8F4FD), Color(0xFFF0F9FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient qrCardGradient = LinearGradient(
    colors: [Color(0xFF4A90E2), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shadow Colors
  static Color shadowLight = Colors.black.withOpacity(0.05);
  static Color shadowMedium = Colors.black.withOpacity(0.1);
  static Color shadowDark = Colors.black.withOpacity(0.15);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Interactive Colors
  static const Color interactiveBlue = Color(0xFF4A90E2);
  static const Color interactiveBlueHover = Color(0xFF357ABD);
  static const Color interactiveBluePressed = Color(0xFF2E6BA8);

  // Navigation Bar Colors
  static const Color navBarBackground = Color(0xFF0D1427);
  static const Color navBarSelected = Color(0xFF3B82F6);
  static const Color navBarUnselected = Color(0xFFFFFFFF);
  static Color navBarBorder = Color(0xFF3B82F6).withAlpha(20);
  static Color navBarShadow = Color(0xFF3B82F6);

  // Card Colors
  static const Color cardPrimaryBg = Color(0xFFFFFFFF);
  static const Color cardSecondaryBg = Color(0xFF0F162A);
  static const Color cardSecondaryBorder = Color(0xFF181F32);
  static const LinearGradient cardLinGrad = LinearGradient(
    colors: [Color(0xFF152D5B), Color(0xFF0F4744)],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
  );
  static const LinearGradient cardLinGradBorder = LinearGradient(
    colors: [Color(0xFF09A59D), Color(0xFF295AB7)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const Color cardPrimaryBorder = Color(0xFFE2E8F0);
  static const Color cardShadow = Color(0x1A000000);
  static const Color cardGradShadow = Color(0x1A3B82F6);

  //chip colors
  static const Color chipPrimaryBg = Color(0xFF0E2A32);
  static const Color chipPrimaryBorder = Color(0xFF09A59D);
  static const Color chipSecondaryBg = Color(0xFF0F162A);
  static const Color chipSecondaryBorder = Color(0xFF181F32);

  //icons
  static const Color iconPrimary = Color(0xFFFFFFFF);
  static const Color iconSecondary = Color(0xFF4A90E2);
  static const Color iconTertiary = Color(0xFF344166);


}
