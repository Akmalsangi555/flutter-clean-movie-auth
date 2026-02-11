import 'package:get/get.dart';
import 'package:webflow_auth_app/features/data/models/movies_list_model.dart';
import 'package:webflow_auth_app/features/domain/use_cases/get_upcoming_movies_use_case.dart';
import 'package:webflow_auth_app/features/domain/use_cases/get_movie_details_use_case.dart';

class MovieController extends GetxController {
  final GetUpcomingMoviesUseCase _getUpcomingMoviesUseCase;
  final GetMovieDetailsUseCase _getMovieDetailsUseCase;

  MovieController({
    required GetUpcomingMoviesUseCase getUpcomingMoviesUseCase,
    required GetMovieDetailsUseCase getMovieDetailsUseCase,
  }) : _getUpcomingMoviesUseCase = getUpcomingMoviesUseCase,
       _getMovieDetailsUseCase = getMovieDetailsUseCase;

  // Observable variables
  final moviesList = Rx<MoviesListModel?>(null);
  final movies = <Results>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final errorMessage = ''.obs;
  final currentPage = 1.obs;
  final hasMorePages = true.obs;
  final totalPages = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUpcomingMovies();
  }

  // Fetch upcoming movies
  Future<void> fetchUpcomingMovies({int page = 1}) async {
    try {
      if (page == 1) {
        isLoading.value = true;
        movies.clear();
      } else {
        isLoadingMore.value = true;
      }

      errorMessage.value = '';

      final result = await _getUpcomingMoviesUseCase(page: page);

      result.fold((l) => errorMessage.value = l.toString(), (r) {
        moviesList.value = r;
        totalPages.value = r.totalPages ?? 0;

        if (r.results != null) {
          movies.addAll(r.results!);
        }

        currentPage.value = page;
        hasMorePages.value = page < totalPages.value;
      });
    } catch (e) {
      errorMessage.value = e.toString();
      print('Error fetching movies: $e');
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  // Load next page
  Future<void> loadNextPage() async {
    if (hasMorePages.value && !isLoadingMore.value) {
      await fetchUpcomingMovies(page: currentPage.value + 1);
    }
  }

  // Refresh movies
  Future<void> refreshMovies() async {
    await fetchUpcomingMovies(page: 1);
  }

  // Get movie by id (synchronous lookup)
  Results? getMovieById(int id) {
    try {
      return movies.firstWhere((movie) => movie.id == id);
    } catch (e) {
      return null;
    }
  }

  // Fetch movie by id (async remote fetch)
  Future<Results?> fetchMovieById(int id) async {
    try {
      // First check if we already have it
      final localMovie = getMovieById(id);
      if (localMovie != null) return localMovie;

      // If not, fetch from API
      isLoading.value = true;
      final result = await _getMovieDetailsUseCase(id);

      return result.fold(
        (l) {
          print('Error fetching movie details: ${l.toString()}');
          return null;
        },
        (r) {
          // Optionally add it to our list if we want to cache it
          if (!movies.any((m) => m.id == r.id)) {
            movies.add(r);
          }
          return r;
        },
      );
    } catch (e) {
      print('Error fetching movie details: $e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // Search movies locally
  List<Results> searchMovies(String query) {
    if (query.isEmpty) return movies;

    return movies.where((movie) {
      final title = movie.title?.toLowerCase() ?? '';
      final overview = movie.overview?.toLowerCase() ?? '';
      final searchQuery = query.toLowerCase();

      return title.contains(searchQuery) || overview.contains(searchQuery);
    }).toList();
  }
}
