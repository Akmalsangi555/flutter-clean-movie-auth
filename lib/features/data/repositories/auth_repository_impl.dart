
import 'package:dartz/dartz.dart';
import 'package:webflow_auth_app/core/error/exceptions.dart';
import 'package:webflow_auth_app/features/domain/entities/user_entity.dart';
import 'package:webflow_auth_app/features/data/models/user_login_model.dart';
import 'package:webflow_auth_app/features/domain/repositories/auth_repository.dart';
import 'package:webflow_auth_app/features/data/data_sources/auth_local_datasource.dart';
import 'package:webflow_auth_app/features/data/data_sources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<Either<AppException, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _remoteDataSource.login(email, password);

      if (response.user != null) {
        await _localDataSource.cacheUserData(response.user!.toJson());
        await _localDataSource.cacheToken(response.token ?? '');
      }

      return Right(response.user!.toEntity());
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerException(e.toString()));
    }
  }

  @override
  Future<Either<AppException, UserEntity>> signup({
    required String email,
    required String password,
    required String passwordConfirmation,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    try {
      final userData = {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'phone_number': phoneNumber,
      };

      final response = await _remoteDataSource.signup(userData);
      return Right(response.toEntity());
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerException(e.toString()));
    }
  }

  @override
  Future<Either<AppException, void>> logout() async {
    try {
      await _remoteDataSource.logout();
      await _localDataSource.clearAll();
      return const Right(null);
    } on AppException catch (e) {
      await _localDataSource.clearAll();
      return Left(e);
    } catch (e) {
      await _localDataSource.clearAll();
      return Left(ServerException(e.toString()));
    }
  }

  @override
  Future<Either<AppException, UserEntity?>> getCurrentUser() async {
    try {
      final hasToken = await _localDataSource.hasToken();

      if (!hasToken) {
        return const Right(null);
      }

      final userData = await _localDataSource.getUserData();
      if (userData != null) {
        final userModel = UserModel.fromJson(userData);
        return Right(userModel.toEntity());
      }

      return const Right(null);
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerException(e.toString()));
    }
  }

  @override
  Future<Either<AppException, bool>> isLoggedIn() async {
    try {
      final hasToken = await _localDataSource.hasToken();
      return Right(hasToken);
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerException(e.toString()));
    }
  }
}
