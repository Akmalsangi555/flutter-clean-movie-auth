
import 'package:webflow_auth_app/features/domain/entities/user_entity.dart';

class SignUpUserModel {
  String? message;
  String? status;
  SignUpData? data;

  SignUpUserModel({this.message, this.status, this.data});

  SignUpUserModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? SignUpData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }

  // Convert to UserEntity
  UserEntity toEntity() {
    return UserEntity(
      userId: data?.id,
      email: data?.email,
      firstName: data?.firstName,
      lastName: data?.lastName,
      profileImg: null,
      token: null,
    );
  }
}

class SignUpData {
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  int? otp;
  String? otpExpiresAt;
  String? updatedAt;
  String? createdAt;
  int? id;

  SignUpData({
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.otp,
    this.otpExpiresAt,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  SignUpData.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    otp = json['otp'];
    otpExpiresAt = json['otp_expires_at'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone_number'] = phoneNumber;
    data['otp'] = otp;
    data['otp_expires_at'] = otpExpiresAt;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}
