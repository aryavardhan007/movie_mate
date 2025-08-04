import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/movie.dart';
import '../../../domain/repositories/movie_repository.dart';
import '../../../data/models/movie_model.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepository repository;

  MovieBloc({required this.repository}) : super(const MovieState()) {
    on<LoadMovies>(_onLoadMovies);
    on<LoadBookmarkedMovies>(_onLoadBookmarkedMovies);
    on<ToggleBookmark>(_onToggleBookmark);
    on<SearchMovies>(_onSearchMovies);
    on<LoadMovieDetails>(_onLoadMovieDetails);
    on<ClearMovieDetails>(_onClearMovieDetails);
  }

  Future<void> _onLoadMovies(LoadMovies event, Emitter<MovieState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final nowPlayingMovies = await repository.getNowPlayingMovies();
      final trendingMovies = await repository.getTrendingMovies();
      final bookmarkedMovies = await repository.getBookmarkedMovies();

      final updatedNowPlayingMovies = _updateBookmarkStatus(
        nowPlayingMovies,
        bookmarkedMovies,
      );
      final updatedTrendingMovies = _updateBookmarkStatus(
        trendingMovies,
        bookmarkedMovies,
      );

      emit(state.copyWith(
        isLoading: false,
        nowPlayingMovies: updatedNowPlayingMovies,
        trendingMovies: updatedTrendingMovies,
        bookmarkedMovies: bookmarkedMovies,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onLoadBookmarkedMovies(
    LoadBookmarkedMovies event,
    Emitter<MovieState> emit,
  ) async {
    try {
      final bookmarkedMovies = await repository.getBookmarkedMovies();
      emit(state.copyWith(bookmarkedMovies: bookmarkedMovies));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onToggleBookmark(
    ToggleBookmark event,
    Emitter<MovieState> emit,
  ) async {
    try {
      await repository.toggleBookmark(event.movie);

      final updatedBookmarkedMovies = await repository.getBookmarkedMovies();

      final updatedNowPlayingMovies = _updateBookmarkStatus(
        state.nowPlayingMovies,
        updatedBookmarkedMovies,
      );
      final updatedTrendingMovies = _updateBookmarkStatus(
        state.trendingMovies,
        updatedBookmarkedMovies,
      );
      final updatedSearchResults = _updateBookmarkStatus(
        state.searchResults,
        updatedBookmarkedMovies,
      );

      emit(state.copyWith(
        nowPlayingMovies: updatedNowPlayingMovies,
        trendingMovies: updatedTrendingMovies,
        searchResults: updatedSearchResults,
        bookmarkedMovies: updatedBookmarkedMovies,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onSearchMovies(
    SearchMovies event,
    Emitter<MovieState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(state.copyWith(searchResults: []));
      return;
    }

    try {
      final searchResults = await repository.searchMovies(event.query);
      final bookmarkedMovies = await repository.getBookmarkedMovies();

      final updatedSearchResults = _updateBookmarkStatus(
        searchResults,
        bookmarkedMovies,
      );

      emit(state.copyWith(searchResults: updatedSearchResults));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onLoadMovieDetails(
    LoadMovieDetails event,
    Emitter<MovieState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final movieDetails = await repository.getMovieDetails(event.movieId);
      emit(state.copyWith(
        isLoading: false,
        movieDetails: movieDetails,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  void _onClearMovieDetails(
    ClearMovieDetails event,
    Emitter<MovieState> emit,
  ) {
    emit(state.copyWith(
      movieDetails: null,
      error: null,
      isLoading: false,
    ));
  }

  List<Movie> _updateBookmarkStatus(
    List<Movie> movies,
    List<Movie> bookmarkedMovies,
  ) {
    final bookmarkedIds = bookmarkedMovies.map((m) => m.id).toSet();
    return movies.map((movie) {
      if (movie is MovieModel) {
        return movie.copyWith(isBookmarked: bookmarkedIds.contains(movie.id));
      }
      return movie;
    }).toList();
  }
}
