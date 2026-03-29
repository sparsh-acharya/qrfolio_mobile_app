// import 'package:qr_folio/features/auth/domain/entity/auth_user_entity.dart';

import 'dart:typed_data';

class UserDataEntity {
  final String id;
  final String xid;
  final int version;
  final String? profilePhotoUrl;

  final AuthInfo auth;
  final CoreUserInfo core;
  final PersonalInfo personal;
  final SocialInfo social;
  final ProfessionalInfo professional;
  final QrInfo qr;
  final SystemInfo system;

  const UserDataEntity({
    required this.id,
    required this.xid,
    required this.version,
    this.profilePhotoUrl,
    required this.auth,
    required this.core,
    required this.personal,
    required this.social,
    required this.professional,
    required this.qr,
    required this.system,
  });
}

class AuthInfo {
  final String token;
  final bool? isVerified;
  final bool? isPaid;

  const AuthInfo({required this.token, this.isVerified, this.isPaid});
}

class CoreUserInfo {
  final String? name;
  final String? email;
  final String phone;

  const CoreUserInfo({this.name, this.email, required this.phone});
}

class PersonalInfo {
  final String address;
  final String bloodGroup;
  final DateTime dateOfBirth;
  final String description;

  const PersonalInfo({
    required this.address,
    required this.bloodGroup,
    required this.dateOfBirth,
    required this.description,
  });
}

class SocialInfo {
  final String instagram;
  final String linkedin;
  final String github;
  final String twitter;
  final String facebook;
  final String website;
  final String whatsapp;

  const SocialInfo({
    required this.instagram,
    required this.linkedin,
    required this.github,
    required this.twitter,
    required this.facebook,
    required this.website,
    required this.whatsapp,
  });
}

class ProfessionalInfo {
  final String companyName;
  final String designation;
  final String companyEmail;
  final String companyPhone;
  final String companyWebsite;
  final String companyAddress;
  final String companyDescription;
  final String companyExperience;
  final String referralCode;

  const ProfessionalInfo({
    required this.companyName,
    required this.designation,
    required this.companyEmail,
    required this.companyPhone,
    required this.companyWebsite,
    required this.companyAddress,
    required this.companyDescription,
    required this.companyExperience,
    required this.referralCode,
  });
}

class QrInfo {
  final Uint8List imageBytes;
  final String url;

  const QrInfo({required this.imageBytes, required this.url});
}

class SystemInfo {
  final DateTime createdAt;
  final DateTime updatedAt;

  const SystemInfo({required this.createdAt, required this.updatedAt});
}
