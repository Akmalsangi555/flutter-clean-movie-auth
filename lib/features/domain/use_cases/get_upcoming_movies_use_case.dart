import 'package:dartz/dartz.dart';
import 'package:webflow_auth_app/core/error/exceptions.dart';
import 'package:webflow_auth_app/features/data/models/movies_list_model.dart';
import 'package:webflow_auth_app/features/domain/repositories/movie_repository.dart';

class GetUpcomingMoviesUseCase {
  final MovieRepository repository;

  GetUpcomingMoviesUseCase({required this.repository});

  Future<Either<AppException, MoviesListModel>> call({int page = 1}) {
    return repository.getUpcomingMovies(page: page);
  }
}
