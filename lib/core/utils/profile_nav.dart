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
    MaterialPageRoute(
      builder: (context) => ProfilePage(user: user, initialIndex: initialIndex),
    ),
  );
}
