
import 'package:get/get.dart';
import 'package:dartz/dartz.dart';
import 'package:webflow_auth_app/core/constants/app_url.dart';
import 'package:webflow_auth_app/core/error/exceptions.dart';
import 'package:webflow_auth_app/core/network/network_api_service.dart';
import 'package:webflow_auth_app/features/movie/data/models/movies_list_model.dart';
import 'package:webflow_auth_app/features/movie/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final NetworkApiService _apiService = Get.find<NetworkApiService>();


  final Map<String, String> _headers = {
    'Authorization': 'Bearer ${AppUrl.movieBearerToken}',
  };

  @override
  Future<Either<AppException, MoviesListModel>> getUpcomingMovies({int page = 1}) async {
    try {
      final url = '${AppUrl.movieBaseUrl}/movie/upcoming?page=$page&language=en-US';
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
      final url = '${AppUrl.movieBaseUrl}/movie/now_playing?page=$page&language=en-US';
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
      final url = '${AppUrl.movieBaseUrl}/movie/popular?page=$page&language=en-US';
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
      final url = '${AppUrl.movieBaseUrl}/movie/top_rated?page=$page&language=en-US';
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
      final url = '${AppUrl.movieBaseUrl}/movie/$movieId?language=en-US';
      final response = await _apiService.getApi(url, headers: _headers);
      return Right(Results.fromJson(response));
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(FetchDataException(e.toString()));
    }
  }
}
