import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_folio/core/theme/app_colors.dart';
import 'package:qr_folio/features/home/presentation/bloc/user_bloc.dart';

class Navbar extends StatefulWidget {
  int currentIndex;
  Navbar({super.key, required this.currentIndex});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.only(bottom: 20),
        child: Center(
          child: Container(
            height: 70,
            constraints: const BoxConstraints(maxWidth: 400),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: AppColors.navBarBackground,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowMedium,
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: const Offset(0, 10),
                ),
              ],
              border: Border.all(color: AppColors.navBarBorder, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(Icons.home, 0),
                _buildNavItem(Icons.apartment, 1),
                _buildNavItem(Icons.perm_media_outlined, 2),
                _buildNavItem(Icons.qr_code, 3),
                _buildNavItem(Icons.settings, 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = widget.currentIndex == index;
    return IconButton(
      onPressed: () {
        setState(() {
          widget.currentIndex = index;
        });
        context.read<UserBloc>().add(NavItemSelectedEvent(index: index));
      },

      icon: Icon(icon, size: 30),
      color: isSelected ? AppColors.navBarSelected : AppColors.navBarUnselected,
    );
  }
}
