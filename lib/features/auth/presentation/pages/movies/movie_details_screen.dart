
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:webflow_auth_app/app/colors/app_colors.dart';
import 'package:webflow_auth_app/features/data/models/movies_list_model.dart';
import 'package:webflow_auth_app/features/auth/presentation/controllers/movie_controller.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Results? movie;
  final int? movieId;

  const MovieDetailsScreen({Key? key, this.movie, this.movieId})
    : super(key: key);

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  final MovieController movieController = Get.find<MovieController>();

  @override
  void initState() {
    super.initState();
    // If we only have the ID, try to fetch the full movie data
    if (widget.movie == null && widget.movieId != null) {
      // Use microtask to avoid calling setState during build if fetch finishes instantly
      Future.microtask(() => movieController.fetchMovieById(widget.movieId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Accessing an observable variable (isLoading) ensures Obx has something to watch,
      // preventing the "improper use of GetX" error when widget.movie is provided.
      final bool loading = movieController.isLoading.value;

      // If movie is null, try to find it in the controller using movieId
      final movieData =
          widget.movie ??
          (widget.movieId != null
              ? movieController.getMovieById(widget.movieId!)
              : null);

      if (movieData == null) {
        // If still loading, show a loading indicator
        if (loading) {
          return Scaffold(
            appBar: AppBar(backgroundColor: AppColors.primaryColor),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(backgroundColor: AppColors.primaryColor),
          body: const Center(child: Text('Movie not found')),
        );
      }

      final displayMovie = movieData;

      return Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      'https://image.tmdb.org/t/p/original${displayMovie.backdropPath ?? displayMovie.posterPath ?? ''}',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade900,
                          child: Center(
                            child: Icon(
                              Icons.movie,
                              size: 64,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        );
                      },
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.7),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              backgroundColor: AppColors.primaryColor,
            ),
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Title
                  Text(
                    displayMovie.title ?? 'No Title',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Rating and Date
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              displayMovie.voteAverage?.toStringAsFixed(1) ??
                                  '0.0',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              color: Colors.blue,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              displayMovie.releaseDate ?? 'Unknown',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Overview
                  const Text(
                    'Overview',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    displayMovie.overview ?? 'No overview available',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Additional Info
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Additional Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          'Original Title',
                          displayMovie.originalTitle ?? 'N/A',
                        ),
                        _buildInfoRow(
                          'Original Language',
                          displayMovie.originalLanguage?.toUpperCase() ?? 'N/A',
                        ),
                        _buildInfoRow(
                          'Vote Count',
                          '${displayMovie.voteCount ?? 0}',
                        ),
                        _buildInfoRow(
                          'Adult Content',
                          displayMovie.adult == true ? 'Yes' : 'No',
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
