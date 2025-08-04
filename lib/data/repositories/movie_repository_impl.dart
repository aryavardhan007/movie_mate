import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_detail.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/local/movie_local_datasource.dart';
import '../datasources/remote/movie_remote_datasource.dart';
import '../models/movie_model.dart';
import '../../core/constants/api_constants.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;
  final MovieLocalDataSource localDataSource;

  MovieRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Movie>> getNowPlayingMovies() async {
    try {
      final response =
          await remoteDataSource.getNowPlayingMovies(ApiConstants.apiKey, 1);
      await localDataSource.cacheMovies(response.results, 'now_playing');
      return response.results;
    } catch (e) {
      return localDataSource.getMovies('now_playing');
    }
  }

  @override
  Future<List<Movie>> getTrendingMovies() async {
    try {
      final response =
          await remoteDataSource.getTrendingMovies(ApiConstants.apiKey, 1);
      await localDataSource.cacheMovies(response.results, 'trending');
      return response.results;
    } catch (e) {
      return localDataSource.getMovies('trending');
    }
  }

  @override
  Future<List<Movie>> searchMovies(String query) async {
    try {
      final response =
          await remoteDataSource.searchMovies(ApiConstants.apiKey, query, 1);
      return response.results;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<MovieDetail> getMovieDetails(int movieId) async {
    try {
      final movieDetail =
          await remoteDataSource.getMovieDetails(movieId, ApiConstants.apiKey);
      return movieDetail.toMovieDetail();
    } catch (e) {
      throw Exception('Failed to load movie details: $e');
    }
  }

  @override
  Future<void> toggleBookmark(Movie movie) async {
    await localDataSource.toggleBookmark(MovieModel.fromMovie(movie));
  }

  @override
  Future<List<Movie>> getBookmarkedMovies() async {
    return localDataSource.getBookmarkedMovies();
  }
}
