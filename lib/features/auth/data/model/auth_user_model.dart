import 'package:qr_folio/features/auth/domain/entity/auth_user_entity.dart';

class AuthUserModel extends AuthUserEntity {
  AuthUserModel({
    required super.token,
    required super.id,
    required super.email,
    required super.name,
    required super.isVerified,
    required super.isPaid,
  });
  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      token: json['token'],
      id: json['user']['id'],
      email: json['user']['email'],
      name: json['user']['name'],
      isVerified: json['user']['isVerified'] == "true" ? true : false,
      isPaid: json['user']['isPaid'] == "true" ? true : false,
    );
  }
  @override
  String toString() {
    // TODO: implement toString
    return 'AuthUserModel(token: $token, id: $id, email: $email, name: $name, isVerified: $isVerified, isPaid: $isPaid)';
  }
}
