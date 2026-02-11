
import 'package:dartz/dartz.dart';
import 'package:webflow_auth_app/core/error/exceptions.dart';
import 'package:webflow_auth_app/features/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<AppException, UserEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<AppException, UserEntity>> signup({
    required String email,
    required String password,
    required String passwordConfirmation,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  });

  Future<Either<AppException, void>> logout();

  // Change this to nullable
  Future<Either<AppException, UserEntity?>> getCurrentUser();

  Future<Either<AppException, bool>> isLoggedIn();
}
