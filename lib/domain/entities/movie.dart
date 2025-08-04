import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final int id;
  final String title;
  final String? posterPath;
  final String? backdropPath;
  final String overview;
  final String releaseDate;
  final double voteAverage;
  final bool isBookmarked;

  const Movie({
    required this.id,
    required this.title,
    this.posterPath,
    this.backdropPath,
    required this.overview,
    required this.releaseDate,
    required this.voteAverage,
    this.isBookmarked = false,
  });

  String get fullPosterPath =>
      posterPath != null ? 'https://image.tmdb.org/t/p/w500$posterPath' : '';

  String get fullBackdropPath => backdropPath != null
      ? 'https://image.tmdb.org/t/p/w500$backdropPath'
      : '';

  String get safePosterPath =>
      posterPath?.isNotEmpty == true ? fullPosterPath : '';

  String get safeBackdropPath =>
      backdropPath?.isNotEmpty == true ? fullBackdropPath : '';

  @override
  List<Object?> get props => [
        id,
        title,
        posterPath,
        backdropPath,
        overview,
        releaseDate,
        voteAverage,
        isBookmarked,
      ];

  Movie copyWith({
    bool? isBookmarked,
  }) {
    return Movie(
      id: id,
      title: title,
      posterPath: posterPath,
      backdropPath: backdropPath,
      overview: overview,
      releaseDate: releaseDate,
      voteAverage: voteAverage,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}
