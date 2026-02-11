
import 'package:get/get.dart';
import 'package:webflow_auth_app/core/services/storage_service.dart';
import 'package:webflow_auth_app/core/network/network_api_service.dart';
import 'package:webflow_auth_app/features/domain/use_cases/login_use_case.dart';
import 'package:webflow_auth_app/features/domain/use_cases/logout_use_case.dart';
import 'package:webflow_auth_app/features/domain/use_cases/signup_use_case.dart';
import 'package:webflow_auth_app/features/domain/repositories/auth_repository.dart';
import 'package:webflow_auth_app/features/domain/repositories/movie_repository.dart';
import 'package:webflow_auth_app/features/data/repositories/auth_repository_impl.dart';
import 'package:webflow_auth_app/features/data/repositories/movie_repository_impl.dart';
import 'package:webflow_auth_app/features/data/data_sources/auth_local_datasource.dart';
import 'package:webflow_auth_app/features/data/data_sources/auth_remote_datasource.dart';
import 'package:webflow_auth_app/features/domain/use_cases/check_auth_status_use_case.dart';
import 'package:webflow_auth_app/features/domain/use_cases/get_movie_details_use_case.dart';
import 'package:webflow_auth_app/features/domain/use_cases/get_upcoming_movies_use_case.dart';
import 'package:webflow_auth_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:webflow_auth_app/features/auth/presentation/controllers/movie_controller.dart';

class AuthBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    // Storage service is already initialized in main.dart
    final storageService = Get.find<StorageService>();

    // Network service
    Get.put<NetworkApiService>(
      NetworkApiService(storage: storageService.storage),
      permanent: true,
    );

    // Data sources
    Get.put<AuthRemoteDataSource>(
      AuthRemoteDataSourceImpl(
        apiService: Get.find<NetworkApiService>(),
        storage: storageService.storage,
      ),
      permanent: true,
    );

    Get.put<AuthLocalDataSource>(
      AuthLocalDataSourceImpl(storage: storageService.storage),
      permanent: true,
    );

    // Repository
    Get.put<AuthRepository>(
      AuthRepositoryImpl(
        remoteDataSource: Get.find<AuthRemoteDataSource>(),
        localDataSource: Get.find<AuthLocalDataSource>(),
      ),
      permanent: true,
    );

    // Use cases
    Get.put(
      LoginUseCase(repository: Get.find<AuthRepository>()),
      permanent: true,
    );
    Get.put(
      SignupUseCase(repository: Get.find<AuthRepository>()),
      permanent: true,
    );
    Get.put(
      CheckAuthStatusUseCase(repository: Get.find<AuthRepository>()),
      permanent: true,
    );
    Get.put(
      LogoutUseCase(repository: Get.find<AuthRepository>()),
      permanent: true,
    );

    // Auth Controller
    Get.put(
      AuthController(
        loginUseCase: Get.find<LoginUseCase>(),
        signupUseCase: Get.find<SignupUseCase>(),
        checkAuthStatusUseCase: Get.find<CheckAuthStatusUseCase>(),
        logoutUseCase: Get.find<LogoutUseCase>(),
        storageService: storageService,
      ),
      permanent: true,
    );

    // Initialize Movie bindings
    await _initMovieDependencies();
  }

  Future<void> _initMovieDependencies() async {
    if (!Get.isRegistered<MovieRepository>()) {
      Get.put<MovieRepository>(MovieRepositoryImpl(), permanent: true);
    }

    if (!Get.isRegistered<GetUpcomingMoviesUseCase>()) {
      Get.put(
        GetUpcomingMoviesUseCase(repository: Get.find<MovieRepository>()),
        permanent: true,
      );
    }

    if (!Get.isRegistered<GetMovieDetailsUseCase>()) {
      Get.put(
        GetMovieDetailsUseCase(repository: Get.find<MovieRepository>()),
        permanent: true,
      );
    }

    if (!Get.isRegistered<MovieController>()) {
      Get.put(
        MovieController(
          getUpcomingMoviesUseCase: Get.find<GetUpcomingMoviesUseCase>(),
          getMovieDetailsUseCase: Get.find<GetMovieDetailsUseCase>(),
        ),
        permanent: true,
      );
    }
  }
}
