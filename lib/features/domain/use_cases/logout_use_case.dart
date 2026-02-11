
import 'package:dartz/dartz.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/error/exceptions.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase({required this.repository});

  Future<Either<AppException, void>> call() {
    return repository.logout();
  }
}
