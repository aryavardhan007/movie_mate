import '../entities/movie.dart';
import '../entities/movie_detail.dart';

abstract class MovieRepository {
  Future<List<Movie>> getNowPlayingMovies();
  Future<List<Movie>> getTrendingMovies();
  Future<List<Movie>> searchMovies(String query);
  Future<void> toggleBookmark(Movie movie);
  Future<List<Movie>> getBookmarkedMovies();
  Future<MovieDetail> getMovieDetails(int movieId);
}
