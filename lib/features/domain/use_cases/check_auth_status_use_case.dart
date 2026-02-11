
import 'package:dartz/dartz.dart';
import 'package:webflow_auth_app/core/error/exceptions.dart';
import 'package:webflow_auth_app/features/domain/entities/user_entity.dart';
import 'package:webflow_auth_app/features/domain/repositories/auth_repository.dart';

class CheckAuthStatusUseCase {
  final AuthRepository repository;

  CheckAuthStatusUseCase({required this.repository});

  Future<Either<AppException, UserEntity?>> call() {
    return repository.getCurrentUser();
  }
}
