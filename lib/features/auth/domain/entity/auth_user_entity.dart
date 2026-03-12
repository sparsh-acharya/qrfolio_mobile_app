
class AuthUserEntity {
  final String token;
  final String id;
  final String email;
  final String name;
  final bool isVerified;
  final bool isPaid;

  AuthUserEntity({
    required this.token,
    required this.id,
    required this.email,
    required this.name,
    required this.isVerified,
    required this.isPaid,
  });

  AuthUserEntity copyWith({
    String? token,
    String? id,
    String? email,
    String? name,
    bool? isVerified,
    bool? isPaid,
  }) {
    return AuthUserEntity(
      token: token ?? this.token,
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      isVerified: isVerified ?? this.isVerified,
      isPaid: isPaid ?? this.isPaid,
    );
  }
}
