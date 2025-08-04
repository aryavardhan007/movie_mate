import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/movie.dart';
import '../bloc/movie/movie_bloc.dart';
import '../bloc/movie/movie_event.dart';
import '../bloc/movie/movie_state.dart';

class BookmarksPage extends StatelessWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
      ),
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state.bookmarkedMovies.isEmpty) {
            return const Center(
              child: Text('No bookmarked movies yet'),
            );
          }
          
          return ListView.builder(
            itemCount: state.bookmarkedMovies.length,
            itemBuilder: (context, index) {
              final movie = state.bookmarkedMovies[index];
              return MovieListItem(movie: movie);
            },
          );
        },
      ),
    );
  }
}

class MovieListItem extends StatelessWidget {
  final Movie movie;

  const MovieListItem({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            movie.fullPosterPath,
            width: 50,
            height: 75,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.error),
          ),
        ),
        title: Text(movie.title),
        subtitle: Text(
          movie.overview,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.bookmark, color: Colors.red),
          onPressed: () {
            context.read<MovieBloc>().add(ToggleBookmark(movie));
          },
        ),
      ),
    );
  }
}