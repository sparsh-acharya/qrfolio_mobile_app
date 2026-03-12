import 'dart:convert';
import 'dart:typed_data';

import 'package:qr_folio/core/utils/app_storage.dart';
import 'package:qr_folio/features/home/domain/entity/user_data_entity.dart';

class UserDataModel {
  final String id;
  final String xid;
  final int version;

  final AuthInfoModel auth;
  final CoreUserInfoModel core;
  final PersonalInfoModel personal;
  final SocialInfoModel social;
  final ProfessionalInfoModel professional;
  final QrInfoModel qr;
  final SystemInfoModel system;

  UserDataModel({
    required this.id,
    required this.xid,
    required this.version,
    required this.auth,
    required this.core,
    required this.personal,
    required this.social,
    required this.professional,
    required this.qr,
    required this.system,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
      id: json['authUserId'] ?? '',
      xid: json['_id'] ?? '',
      version: json['__v'] ?? 0,

      auth: AuthInfoModel.fromJson(json),
      core: CoreUserInfoModel.fromJson(json),
      personal: PersonalInfoModel.fromJson(json),
      social: SocialInfoModel.fromJson(json),
      professional: ProfessionalInfoModel.fromJson(json),
      qr: QrInfoModel.fromJson(json),
      system: SystemInfoModel.fromJson(json),
    );
  }

  UserDataEntity toEntity() {
    return UserDataEntity(
      id: id,
      xid: xid,
      version: version,
      auth: auth.toEntity(),
      core: core.toEntity(),
      personal: personal.toEntity(),
      social: social.toEntity(),
      professional: professional.toEntity(),
      qr: qr.toEntity(),
      system: system.toEntity(),
    );
  }

  @override
  String toString() =>
      "UserDataModel(id:$id, xid:$xid, version:$version, token:${auth.token}, name:${core.name}, bloodGroup:${personal.bloodGroup}, insta:${social.instagram}, company:${professional.companyName}, qrurl:${qr.url}, createdAt:${system.createdAt})";
}

class AuthInfoModel {
  final String token;
  final bool? isVerified;
  final bool? isPaid;

  AuthInfoModel({required this.token, this.isPaid, this.isVerified});

  factory AuthInfoModel.fromJson(Map<String, dynamic> json) {
    return AuthInfoModel(
      token: json['token'] ?? '',
      isVerified: json.containsKey('isVerified')
          ? json['isVerified'] == true
          : null,
      isPaid: json.containsKey('isPaid') ? json['isPaid'] == true : null,
    );
  }

  AuthInfo toEntity() {
    return AuthInfo(token: token, isVerified: isVerified, isPaid: isPaid);
  }
}

class CoreUserInfoModel {
  final String? name;
  final String? email;
  final String phone;

  CoreUserInfoModel({this.name, this.email, required this.phone});

  factory CoreUserInfoModel.fromJson(Map<String, dynamic> json) {
    return CoreUserInfoModel(
      name: json.containsKey('name') ? json['name'] : null,
      email: json.containsKey('email') ? json['email'] : null,
      phone: json['phone'] ?? '',
    );
  }

  CoreUserInfo toEntity() {
    return CoreUserInfo(name: name, email: email, phone: phone);
  }
}

class PersonalInfoModel {
  final String address;
  final String bloodGroup;
  final DateTime dateOfBirth;
  final String description;

  PersonalInfoModel({
    required this.address,
    required this.bloodGroup,
    required this.dateOfBirth,
    required this.description,
  });

  factory PersonalInfoModel.fromJson(Map<String, dynamic> json) {
    return PersonalInfoModel(
      address: json['address'] ?? '',
      bloodGroup: json['bloodGroup'] ?? '',
      description: json['description'] ?? '',
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : DateTime(1900),
    );
  }

  PersonalInfo toEntity() {
    return PersonalInfo(
      address: address,
      bloodGroup: bloodGroup,
      dateOfBirth: dateOfBirth,
      description: description,
    );
  }
}

class SystemInfoModel {
  final DateTime createdAt;
  final DateTime updatedAt;

  SystemInfoModel({required this.createdAt, required this.updatedAt});

  factory SystemInfoModel.fromJson(Map<String, dynamic> json) {
    return SystemInfoModel(
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  SystemInfo toEntity() {
    return SystemInfo(createdAt: createdAt, updatedAt: updatedAt);
  }
}

class SocialInfoModel {
  final String instagram;
  final String linkedin;
  final String github;
  final String twitter;
  final String facebook;
  final String website;
  final String whatsapp;

  SocialInfoModel({
    required this.instagram,
    required this.linkedin,
    required this.github,
    required this.twitter,
    required this.facebook,
    required this.website,
    required this.whatsapp,
  });

  factory SocialInfoModel.fromJson(Map<String, dynamic> json) {
    return SocialInfoModel(
      instagram: json['instagram'] ?? '',
      linkedin: json['linkedin'] ?? '',
      github: json['github'] ?? '',
      twitter: json['twitter'] ?? '',
      facebook: json['facebook'] ?? '',
      website: json['website'] ?? '',
      whatsapp: json['whatsapp'] ?? '',
    );
  }

  SocialInfo toEntity() {
    return SocialInfo(
      instagram: instagram,
      linkedin: linkedin,
      github: github,
      twitter: twitter,
      facebook: facebook,
      website: website,
      whatsapp: whatsapp,
    );
  }
}

class ProfessionalInfoModel {
  final String companyName;
  final String designation;
  final String companyEmail;
  final String companyPhone;
  final String companyWebsite;
  final String companyAddress;
  final String companyDescription;
  final String companyExperience;
  final String referralCode;

  ProfessionalInfoModel({
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

  factory ProfessionalInfoModel.fromJson(Map<String, dynamic> json) {
    return ProfessionalInfoModel(
      companyName: json['companyName'] ?? '',
      designation: json['designation'] ?? '',
      companyEmail: json['companyEmail'] ?? '',
      companyPhone: json['companyPhone'] ?? '',
      companyWebsite: json['companyWebsite'] ?? '',
      companyAddress: json['companyAddress'] ?? '',
      companyDescription: json['companyDescription'] ?? '',
      companyExperience: json['companyExperience'] ?? '',
      referralCode: json['companyReferralCode'] ?? '',
    );
  }

  ProfessionalInfo toEntity() {
    return ProfessionalInfo(
      companyName: companyName,
      designation: designation,
      companyEmail: companyEmail,
      companyPhone: companyPhone,
      companyWebsite: companyWebsite,
      companyAddress: companyAddress,
      companyDescription: companyDescription,
      companyExperience: companyExperience,
      referralCode: referralCode,
    );
  }
}

class QrInfoModel {
  final Uint8List imageBytes;
  final String url;

  QrInfoModel({required this.imageBytes, required this.url});

  factory QrInfoModel.fromJson(Map<String, dynamic> json) {
    return QrInfoModel(
      imageBytes: base64Decode(json['qrCodeImage'].split(',').last),
      url: json['qrCodeUrl'] ?? '',
    );
  }

  QrInfo toEntity() {
    return QrInfo(imageBytes: imageBytes, url: url);
  }
}
