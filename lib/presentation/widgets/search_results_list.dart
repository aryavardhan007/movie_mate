import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/movie.dart';
import '../bloc/movie/movie_bloc.dart';
import '../bloc/movie/movie_event.dart';

class SearchResultsList extends StatelessWidget {
  final List<Movie> movies;

  const SearchResultsList({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Search Results',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    movie.safePosterPath.isNotEmpty
                        ? movie.safePosterPath
                        : 'https://via.placeholder.com/50x75/333333/FFFFFF?text=No+Image',
                    width: 50,
                    height: 75,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 50,
                      height: 75,
                      color: Colors.grey[800],
                      child: const Icon(
                        Icons.movie,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                title: Text(movie.title),
                subtitle: Text(
                  movie.overview,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.bookmark,
                    color: movie.isBookmarked ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    context.read<MovieBloc>().add(ToggleBookmark(movie));
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
