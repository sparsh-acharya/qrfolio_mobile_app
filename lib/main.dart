import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_folio/core/theme/app_colors.dart';
import 'package:qr_folio/features/auth/presentation/pages/authpage.dart';
import 'package:qr_folio/features/auth/presentation/pages/login.dart';
import 'package:qr_folio/features/home/presentation/pages/home.dart';
import 'package:qr_folio/features/professional/presentation/pages/professional_detail_page.dart';
import 'package:qr_folio/features/profile/presentation/pages/profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR Folio',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
        textTheme: GoogleFonts.plusJakartaSansTextTheme(),
        colorScheme: ColorScheme.light(
          primary: AppColors.primaryBlue,
          secondary: AppColors.secondaryBlue,
          surface: AppColors.surfacePrimary,
          error: AppColors.error,
          onPrimary: AppColors.textOnPrimary,
          onSecondary: AppColors.textOnPrimary,
          onSurface: AppColors.textPrimary,
          onError: AppColors.textOnPrimary,
        ),
        scaffoldBackgroundColor: AppColors.backgroundPrimary,
        cardColor: AppColors.cardPrimaryBg,
        cardTheme: CardThemeData(
          color: AppColors.cardPrimaryBg,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: AppColors.cardPrimaryBorder, width: 1),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.backgroundPrimary,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
          titleTextStyle: GoogleFonts.plusJakartaSans(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Authpage(),
        '/login': (context) =>  LoginPage(),
        '/home': (context) => const Home(),
        '/profile': (context) => const ProfilePage(),
        '/professional': (context) => const ProfessionalDetailPage(),
      },
    );
  }
}
