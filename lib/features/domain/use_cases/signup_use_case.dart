
import 'package:dartz/dartz.dart';
import 'package:webflow_auth_app/core/error/exceptions.dart';
import 'package:webflow_auth_app/features/domain/entities/user_entity.dart';
import 'package:webflow_auth_app/features/domain/repositories/auth_repository.dart';

class SignupUseCase {
  final AuthRepository repository;

  SignupUseCase({required this.repository});

  Future<Either<AppException, UserEntity>> call(SignupParams params) {
    return repository.signup(
      email: params.email,
      password: params.password,
      passwordConfirmation: params.passwordConfirmation,
      firstName: params.firstName,
      lastName: params.lastName,
      phoneNumber: params.phoneNumber,
    );
  }
}

class SignupParams {
  final String email;
  final String password;
  final String passwordConfirmation;
  final String firstName;
  final String lastName;
  final String phoneNumber;

  SignupParams({
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
  });
}
