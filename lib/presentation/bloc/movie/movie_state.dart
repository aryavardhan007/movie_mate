import 'package:equatable/equatable.dart';
import '../../../domain/entities/movie.dart';
import '../../../domain/entities/movie_detail.dart';

class MovieState extends Equatable {
  final List<Movie> nowPlayingMovies;
  final List<Movie> trendingMovies;
  final List<Movie> bookmarkedMovies;
  final List<Movie> searchResults;
  final MovieDetail? movieDetails;
  final bool isLoading;
  final String? error;

  const MovieState({
    this.nowPlayingMovies = const [],
    this.trendingMovies = const [],
    this.bookmarkedMovies = const [],
    this.searchResults = const [],
    this.movieDetails,
    this.isLoading = false,
    this.error,
  });

  MovieState copyWith({
    List<Movie>? nowPlayingMovies,
    List<Movie>? trendingMovies,
    List<Movie>? bookmarkedMovies,
    List<Movie>? searchResults,
    MovieDetail? movieDetails,
    bool? isLoading,
    String? error,
  }) {
    return MovieState(
      nowPlayingMovies: nowPlayingMovies ?? this.nowPlayingMovies,
      trendingMovies: trendingMovies ?? this.trendingMovies,
      bookmarkedMovies: bookmarkedMovies ?? this.bookmarkedMovies,
      searchResults: searchResults ?? this.searchResults,
      movieDetails: movieDetails ?? this.movieDetails,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        nowPlayingMovies,
        trendingMovies,
        bookmarkedMovies,
        searchResults,
        movieDetails,
        isLoading,
        error,
      ];
}
