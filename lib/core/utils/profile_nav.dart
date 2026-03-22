import 'package:flutter/material.dart';
import 'package:qr_folio/features/home/domain/entity/user_data_entity.dart';
import 'package:qr_folio/features/home/presentation/pages/profile.dart';

void goTpProfile(
  BuildContext context,
  UserDataEntity user,{
  int initialIndex = 0,
}) {
  Navigator.push(
    context,
    PageRouteBuilder(
      opaque: false,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) =>
          ProfilePage(user: user, initialIndex: initialIndex),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const curve = Curves.easeOutCubic;
        var tween = Tween(begin: begin, end: Offset.zero).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    ),
  );
}
