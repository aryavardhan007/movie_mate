import 'package:equatable/equatable.dart';

class MovieDetail extends Equatable {
  final int id;
  final String title;
  final String? backdropPath;
  final String? posterPath;
  final double voteAverage;
  final String overview;
  final String releaseDate;
  final int runtime;
  final int budget;
  final int revenue;
  final List<String> genres;
  final bool isBookmarked;

  const MovieDetail({
    required this.id,
    required this.title,
    this.backdropPath,
    this.posterPath,
    required this.voteAverage,
    required this.overview,
    required this.releaseDate,
    required this.runtime,
    required this.budget,
    required this.revenue,
    required this.genres,
    this.isBookmarked = false,
  });

  String get fullBackdropPath => backdropPath != null
      ? 'https://image.tmdb.org/t/p/w500$backdropPath'
      : '';

  String get fullPosterPath =>
      posterPath != null ? 'https://image.tmdb.org/t/p/w500$posterPath' : '';

  @override
  List<Object?> get props => [
        id,
        title,
        backdropPath,
        posterPath,
        voteAverage,
        overview,
        releaseDate,
        runtime,
        budget,
        revenue,
        genres,
        isBookmarked,
      ];

  MovieDetail copyWith({
    int? id,
    String? title,
    String? backdropPath,
    String? posterPath,
    double? voteAverage,
    String? overview,
    String? releaseDate,
    int? runtime,
    int? budget,
    int? revenue,
    List<String>? genres,
    bool? isBookmarked,
  }) {
    return MovieDetail(
      id: id ?? this.id,
      title: title ?? this.title,
      backdropPath: backdropPath ?? this.backdropPath,
      posterPath: posterPath ?? this.posterPath,
      voteAverage: voteAverage ?? this.voteAverage,
      overview: overview ?? this.overview,
      releaseDate: releaseDate ?? this.releaseDate,
      runtime: runtime ?? this.runtime,
      budget: budget ?? this.budget,
      revenue: revenue ?? this.revenue,
      genres: genres ?? this.genres,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}
