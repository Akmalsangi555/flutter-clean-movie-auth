
import 'package:get/get.dart';
import '../network/network_api_service.dart';

class TmdbApiService extends GetxService {
  final NetworkApiService _networkApiService = Get.find<NetworkApiService>();

  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String bearerToken = '';

  Future<dynamic> getUpcomingMovies({int page = 1}) async {
    final url = '$baseUrl/movie/upcoming?page=$page&language=en-US';

    final headers = {
      'Authorization': 'Bearer $bearerToken',
    };

    try {
      final response = await _networkApiService.getApi(url, headers: headers);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getMovieDetails(int movieId) async {
    final url = '$baseUrl/movie/$movieId?language=en-US';

    final headers = {
      'Authorization': 'Bearer $bearerToken',
    };

    try {
      final response = await _networkApiService.getApi(url, headers: headers);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> searchMovies(String query, {int page = 1}) async {
    final url = '$baseUrl/search/movie?query=$query&page=$page&language=en-US';

    final headers = {
      'Authorization': 'Bearer $bearerToken',
    };

    try {
      final response = await _networkApiService.getApi(url, headers: headers);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getNowPlaying({int page = 1}) async {
    final url = '$baseUrl/movie/now_playing?page=$page&language=en-US';

    final headers = {
      'Authorization': 'Bearer $bearerToken',
    };

    try {
      final response = await _networkApiService.getApi(url, headers: headers);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getPopular({int page = 1}) async {
    final url = '$baseUrl/movie/popular?page=$page&language=en-US';

    final headers = {
      'Authorization': 'Bearer $bearerToken',
    };

    try {
      final response = await _networkApiService.getApi(url, headers: headers);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getTopRated({int page = 1}) async {
    final url = '$baseUrl/movie/top_rated?page=$page&language=en-US';

    final headers = {
      'Authorization': 'Bearer $bearerToken',
    };

    try {
      final response = await _networkApiService.getApi(url, headers: headers);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
