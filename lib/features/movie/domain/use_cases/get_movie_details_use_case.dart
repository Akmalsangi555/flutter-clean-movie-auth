import 'package:dartz/dartz.dart';
import 'package:webflow_auth_app/core/error/exceptions.dart';
import 'package:webflow_auth_app/features/movie/data/models/movies_list_model.dart';
import 'package:webflow_auth_app/features/movie/domain/repositories/movie_repository.dart';

class GetMovieDetailsUseCase {
  final MovieRepository repository;

  GetMovieDetailsUseCase({required this.repository});

  Future<Either<AppException, Results>> call(int movieId) {
    return repository.getMovieDetails(movieId);
  }
}
