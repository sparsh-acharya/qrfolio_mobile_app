import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_folio/core/theme/app_colors.dart';
import 'package:qr_folio/core/widgets/wallpaper.dart';
import 'package:qr_folio/features/auth/presentation/bloc/auth_bloc.dart';

class Authpage extends StatelessWidget {
  const Authpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Wallpaper(),
        Positioned(
          right: -80,
          top: -80,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withAlpha(50),
                  blurRadius: 150,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/logo.svg',
                width: 170,
                height: 170,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 50),
              Text(
                "Turn your profile into a",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center, // important
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 26,
                  color: Colors.white,
                  letterSpacing: -1,
                  wordSpacing: 3,
                  fontWeight: FontWeight.w900,
                ),
              ),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xff8BB2FF), Color(0xff2A6AE8)],
                ).createShader(bounds),
                child: Text(
                  "scannable QR identity",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center, // important
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 26,

                    color: Colors.white,
                    letterSpacing: -1,
                    wordSpacing: 3,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Share a single smart QR instead of dozens of links.\nPerfect for creators, professionals, and brands.",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center, // important
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.withAlpha(100),
                  letterSpacing: -1,
                  wordSpacing: 1,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 145,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blueAccent, width: 1),
                    ),
                    child: TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(AuthLoginPageEvent());
                      },
                      child: Text(
                        "Login",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    width: 145,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blueAccent, width: 1),
                    ),
                    child: TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(AuthRegisterPageEvent());
                      },
                      child: Text(
                        "Register",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
