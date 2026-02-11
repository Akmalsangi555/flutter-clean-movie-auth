
import 'package:get/get.dart';
import 'package:dartz/dartz.dart';
import 'package:webflow_auth_app/core/error/exceptions.dart';
import 'package:webflow_auth_app/core/network/network_api_service.dart';
import 'package:webflow_auth_app/features/data/models/movies_list_model.dart';
import 'package:webflow_auth_app/features/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final NetworkApiService _apiService = Get.find<NetworkApiService>();

  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String bearerToken = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwZDE1ZGY3YWNkN2VlMjlmNzBiNGNjNGQzMjM2MzA5ZSIsIm5iZiI6MTczNzYxODE0Mi4wODcwMDAxLCJzdWIiOiI2NzkxZjJkZTc0OWIyYmM1YjU0NmZiZWEiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.izhWrQ3nRCDvfzxLWt-BtpKlUSz7hkJ4Mo5R_iyUrTc';

  final Map<String, String> _headers = {
    'Authorization': 'Bearer $bearerToken',
  };

  @override
  Future<Either<AppException, MoviesListModel>> getUpcomingMovies({int page = 1}) async {
    try {
      final url = '$baseUrl/movie/upcoming?page=$page&language=en-US';
      final response = await _apiService.getApi(url, headers: _headers);
      return Right(MoviesListModel.fromJson(response));
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(FetchDataException(e.toString()));
    }
  }

  @override
  Future<Either<AppException, MoviesListModel>> getNowPlayingMovies({int page = 1}) async {
    try {
      final url = '$baseUrl/movie/now_playing?page=$page&language=en-US';
      final response = await _apiService.getApi(url, headers: _headers);
      return Right(MoviesListModel.fromJson(response));
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(FetchDataException(e.toString()));
    }
  }

  @override
  Future<Either<AppException, MoviesListModel>> getPopularMovies({int page = 1}) async {
    try {
      final url = '$baseUrl/movie/popular?page=$page&language=en-US';
      final response = await _apiService.getApi(url, headers: _headers);
      return Right(MoviesListModel.fromJson(response));
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(FetchDataException(e.toString()));
    }
  }

  @override
  Future<Either<AppException, MoviesListModel>> getTopRatedMovies({int page = 1}) async {
    try {
      final url = '$baseUrl/movie/top_rated?page=$page&language=en-US';
      final response = await _apiService.getApi(url, headers: _headers);
      return Right(MoviesListModel.fromJson(response));
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(FetchDataException(e.toString()));
    }
  }

  @override
  Future<Either<AppException, Results>> getMovieDetails(int movieId) async {
    try {
      final url = '$baseUrl/movie/$movieId?language=en-US';
      final response = await _apiService.getApi(url, headers: _headers);
      return Right(Results.fromJson(response));
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(FetchDataException(e.toString()));
    }
  }
}
