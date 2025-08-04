import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/movie.dart';
import '../bloc/movie/movie_bloc.dart';
import '../bloc/movie/movie_event.dart';
import '../bloc/movie/movie_state.dart';

class MovieDetailsPage extends StatefulWidget {
  final Movie movie;

  const MovieDetailsPage({super.key, required this.movie});

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<MovieBloc>().add(LoadMovieDetails(widget.movie.id));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<MovieBloc>().add(const ClearMovieDetails());
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: BlocBuilder<MovieBloc, MovieState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.amber,
                ),
              );
            }

            if (state.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Failed to load movie details',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.error!,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<MovieBloc>()
                            .add(LoadMovieDetails(widget.movie.id));
                      },
                      child: const Text('Retry'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Clear error state before navigating back
                        context
                            .read<MovieBloc>()
                            .add(const ClearMovieDetails());
                        Navigator.of(context).pop();
                      },
                      child: const Text('Back'),
                    )
                  ],
                ),
              );
            }

            final movieDetails = state.movieDetails;
            if (movieDetails == null) {
              return const Center(
                child: Text(
                  'No movie details available',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // App Bar with backdrop
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  backgroundColor: Colors.black,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      // Clear error state before navigating back
                      context.read<MovieBloc>().add(const ClearMovieDetails());
                      Navigator.pop(context);
                    },
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(
                        movieDetails.isBookmarked
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                        color: movieDetails.isBookmarked
                            ? Colors.red
                            : Colors.white,
                      ),
                      onPressed: () {
                        context
                            .read<MovieBloc>()
                            .add(ToggleBookmark(widget.movie));
                      },
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: movieDetails.backdropPath != null
                        ? Image.network(
                            movieDetails.fullBackdropPath,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              color: Colors.grey[800],
                              child: const Icon(
                                Icons.movie,
                                color: Colors.white,
                                size: 50,
                              ),
                            ),
                          )
                        : Container(
                            color: Colors.grey[800],
                            child: const Icon(
                              Icons.movie,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                  ),
                ),
                // Movie content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title and rating
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                movieDetails.title,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${movieDetails.voteAverage.toStringAsFixed(1)} ⭐',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Genres
                        if (movieDetails.genres.isNotEmpty)
                          Wrap(
                            spacing: 8,
                            children: movieDetails.genres
                                .map((genre) => Chip(
                                      label: Text(genre),
                                      backgroundColor: Colors.grey[800],
                                      labelStyle:
                                          const TextStyle(color: Colors.white),
                                    ))
                                .toList(),
                          ),
                        const SizedBox(height: 16),

                        if (movieDetails.runtime > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${movieDetails.runtime} min',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        const SizedBox(height: 16),

                        const Text(
                          'Overview',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          movieDetails.overview,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade300,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),

                        _buildInfoRow('Release Date', movieDetails.releaseDate),
                        _buildInfoRow('Budget',
                            '\$${(movieDetails.budget / 1000000).toStringAsFixed(1)}M'),
                        _buildInfoRow('Revenue',
                            '\$${(movieDetails.revenue / 1000000).toStringAsFixed(1)}M'),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
