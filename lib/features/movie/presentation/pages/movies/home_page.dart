
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webflow_auth_app/core/constants/app_colors.dart';
import 'package:webflow_auth_app/features/movie/presentation/widgets/movie_card.dart';
import 'package:webflow_auth_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:webflow_auth_app/features/movie/presentation/controllers/movie_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final movieController = Get.find<MovieController>();
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies List',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () async {
            await authController.logout(context);
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/login');
            }
          },
        ),

        // Logout button - Explicit logout
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authController.logout(context);
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
      body: _buildMoviesTab(movieController),
    );
  }

  // Movies Tab Widget
  Widget _buildMoviesTab(MovieController controller) {
    return RefreshIndicator(
      onRefresh: () => controller.refreshMovies(),
      color: AppColors.primaryColor,
      child: Obx(() {
        if (controller.isLoading.value && controller.movies.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading movies...'),
              ],
            ),
          );
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text('Failed to load movies',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    controller.errorMessage.value,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => controller.refreshMovies(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try Again'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
              controller.loadNextPage();
            }
            return true;
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.movies.length + (controller.isLoadingMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.movies.length) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: CircularProgressIndicator(color: AppColors.primaryColor),
                  ),
                );
              }

              final movie = controller.movies[index];
              return MovieCard(movie: movie);
            },
          ),
        );
      }),
    );
  }
}
