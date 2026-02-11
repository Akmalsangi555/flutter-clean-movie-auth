
class UserEntity {
  final int? userId;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? profileImg;
  final String? token;

  UserEntity({
    this.userId,
    this.email,
    this.firstName,
    this.lastName,
    this.profileImg,
    this.token,
  });

  UserEntity copyWith({
    int? userId,
    String? email,
    String? firstName,
    String? lastName,
    String? profileImg,
    String? token,
  }) {
    return UserEntity(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profileImg: profileImg ?? this.profileImg,
      token: token ?? this.token,
    );
  }
}
