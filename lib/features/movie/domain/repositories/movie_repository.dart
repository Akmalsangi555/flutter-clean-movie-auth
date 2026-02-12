
import 'package:dartz/dartz.dart';
import 'package:webflow_auth_app/core/error/exceptions.dart';
import 'package:webflow_auth_app/features/movie/data/models/movies_list_model.dart';

abstract class MovieRepository {
  Future<Either<AppException, MoviesListModel>> getUpcomingMovies({
    int page = 1,
  });
  Future<Either<AppException, MoviesListModel>> getNowPlayingMovies({
    int page = 1,
  });
  Future<Either<AppException, MoviesListModel>> getPopularMovies({
    int page = 1,
  });
  Future<Either<AppException, MoviesListModel>> getTopRatedMovies({
    int page = 1,
  });
  Future<Either<AppException, Results>> getMovieDetails(int movieId);
}
