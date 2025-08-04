import 'package:hive/hive.dart';
import '../../models/movie_model.dart';
import '../../../domain/entities/movie.dart';

class MovieLocalDataSource {
  final Box<MovieModel> movieBox;

  MovieLocalDataSource({required this.movieBox});

  Future<void> cacheMovies(List<MovieModel> movies, String key) async {
    final Map<int, MovieModel> movieMap = {
      for (var movie in movies) movie.id: movie
    };
    await movieBox.putAll(movieMap);
  }

  List<MovieModel> getMovies([String? category]) {
    return movieBox.values.toList();
  }

  Future<void> toggleBookmark(Movie movie) async {
    final movieModel = MovieModel.fromMovie(movie);

    final existingMovie = movieBox.get(movie.id);

    if (existingMovie != null) {
      final updatedMovie =
          existingMovie.copyWith(isBookmarked: !existingMovie.isBookmarked);
      await movieBox.put(movie.id, updatedMovie);
    } else {
      final newMovie = movieModel.copyWith(isBookmarked: true);
      await movieBox.put(movie.id, newMovie);
    }
  }

  List<Movie> getBookmarkedMovies() {
    return movieBox.values
        .where((movie) => movie.isBookmarked)
        .toList();
  }
}
