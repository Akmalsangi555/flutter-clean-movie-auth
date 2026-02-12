
import 'package:get/get.dart';
import 'package:webflow_auth_app/features/movie/domain/repositories/movie_repository.dart';
import 'package:webflow_auth_app/features/movie/data/repositories/movie_repository_impl.dart';
import 'package:webflow_auth_app/features/movie/presentation/controllers/movie_controller.dart';
import 'package:webflow_auth_app/features/movie/domain/use_cases/get_movie_details_use_case.dart';
import 'package:webflow_auth_app/features/movie/domain/use_cases/get_upcoming_movies_use_case.dart';

class MovieBinding extends Bindings {
  @override
  void dependencies() {
    // Repository
    Get.lazyPut<MovieRepository>(() => MovieRepositoryImpl(), fenix: true);

    // Use Cases
    Get.lazyPut(() => GetUpcomingMoviesUseCase(repository: Get.find<MovieRepository>()), fenix: true);
    Get.lazyPut(() => GetMovieDetailsUseCase(repository: Get.find<MovieRepository>()), fenix: true);

    // Controller
    Get.lazyPut<MovieController>(
          () => MovieController(
        getUpcomingMoviesUseCase: Get.find<GetUpcomingMoviesUseCase>(),
        getMovieDetailsUseCase: Get.find<GetMovieDetailsUseCase>(),
      ),
      fenix: true,
    );
  }
}
