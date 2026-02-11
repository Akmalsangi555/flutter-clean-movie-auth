
import '../../domain/entities/user_entity.dart';

class UserLoginModel {
  String? message;
  UserModel? user;
  String? status;
  String? token;

  UserLoginModel({this.message, this.user, this.status, this.token});

  UserLoginModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    status = json['status'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['status'] = status;
    data['token'] = token;
    return data;
  }
}

class UserModel {
  int? userId;
  String? email;
  String? firstName;
  String? lastName;
  String? profileImg;

  UserModel({
    this.userId,
    this.email,
    this.firstName,
    this.lastName,
    this.profileImg,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    profileImg = json['profile_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['email'] = email;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['profile_img'] = profileImg;
    return data;
  }

  // Convert to Entity
  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      email: email,
      firstName: firstName,
      lastName: lastName,
      profileImg: profileImg,
    );
  }
}

// class UserLoginModel {
//   String? message;
//   User? user;
//   String? status;
//   String? token;
//
//   UserLoginModel({this.message, this.user, this.status, this.token});
//
//   UserLoginModel.fromJson(Map<String, dynamic> json) {
//     message = json['message'];
//     user = json['user'] != null ? new User.fromJson(json['user']) : null;
//     status = json['status'];
//     token = json['token'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['message'] = this.message;
//     if (this.user != null) {
//       data['user'] = this.user!.toJson();
//     }
//     data['status'] = this.status;
//     data['token'] = this.token;
//     return data;
//   }
// }
//
// class User {
//   int? userId;
//   String? email;
//   String? firstName;
//   String? lastName;
//   String? profileImg;
//
//   User(
//       {this.userId,
//         this.email,
//         this.firstName,
//         this.lastName,
//         this.profileImg});
//
//   User.fromJson(Map<String, dynamic> json) {
//     userId = json['user_id'];
//     email = json['email'];
//     firstName = json['first_name'];
//     lastName = json['last_name'];
//     profileImg = json['profile_img'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['user_id'] = this.userId;
//     data['email'] = this.email;
//     data['first_name'] = this.firstName;
//     data['last_name'] = this.lastName;
//     data['profile_img'] = this.profileImg;
//     return data;
//   }
// }
