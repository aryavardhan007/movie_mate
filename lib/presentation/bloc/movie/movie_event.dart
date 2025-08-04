import 'package:equatable/equatable.dart';
import '../../../domain/entities/movie.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object?> get props => [];
}

class LoadMovies extends MovieEvent {
  const LoadMovies();
}

class LoadBookmarkedMovies extends MovieEvent {
  const LoadBookmarkedMovies();
}

class ToggleBookmark extends MovieEvent {
  final Movie movie;

  const ToggleBookmark(this.movie);

  @override
  List<Object?> get props => [movie];
}

class SearchMovies extends MovieEvent {
  final String query;

  const SearchMovies(this.query);

  @override
  List<Object?> get props => [query];
}

class LoadMovieDetails extends MovieEvent {
  final int movieId;

  const LoadMovieDetails(this.movieId);

  @override
  List<Object?> get props => [movieId];
}

class ClearMovieDetails extends MovieEvent {
  const ClearMovieDetails();
}
