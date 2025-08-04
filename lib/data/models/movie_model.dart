import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/movie.dart';

part 'movie_model.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class MovieModel extends Movie {
  @HiveField(0)
  @override
  final int id;

  @HiveField(1)
  @override
  final String title;

  @HiveField(2)
  @JsonKey(name: 'poster_path')
  @override
  final String? posterPath;

  @HiveField(3)
  @JsonKey(name: 'backdrop_path')
  @override
  final String? backdropPath;

  @HiveField(4)
  @override
  final String overview;

  @HiveField(5)
  @JsonKey(name: 'release_date')
  @override
  final String releaseDate;

  @HiveField(6)
  @JsonKey(name: 'vote_average')
  @override
  final double voteAverage;

  @HiveField(7)
  @override
  final bool isBookmarked;

  const MovieModel({
    required this.id,
    required this.title,
    this.posterPath,
    this.backdropPath,
    required this.overview,
    required this.releaseDate,
    required this.voteAverage,
    this.isBookmarked = false,
  }) : super(
          id: id,
          title: title,
          posterPath: posterPath,
          backdropPath: backdropPath,
          overview: overview,
          releaseDate: releaseDate,
          voteAverage: voteAverage,
          isBookmarked: isBookmarked,
        );

  factory MovieModel.fromJson(Map<String, dynamic> json) =>
      _$MovieModelFromJson(json);

  Map<String, dynamic> toJson() => _$MovieModelToJson(this);

  factory MovieModel.fromMovie(Movie movie) {
    return MovieModel(
      id: movie.id,
      title: movie.title,
      posterPath: movie.posterPath,
      backdropPath: movie.backdropPath,
      overview: movie.overview,
      releaseDate: movie.releaseDate,
      voteAverage: movie.voteAverage,
      isBookmarked: movie.isBookmarked,
    );
  }

  MovieModel copyWith({
    int? id,
    String? title,
    String? posterPath,
    String? backdropPath,
    String? overview,
    String? releaseDate,
    double? voteAverage,
    bool? isBookmarked,
  }) {
    return MovieModel(
      id: id ?? this.id,
      title: title ?? this.title,
      posterPath: posterPath ?? this.posterPath,
      backdropPath: backdropPath ?? this.backdropPath,
      overview: overview ?? this.overview,
      releaseDate: releaseDate ?? this.releaseDate,
      voteAverage: voteAverage ?? this.voteAverage,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}

@JsonSerializable()
class MovieResponse {
  final List<MovieModel> results;
  final int page;
  @JsonKey(name: 'total_pages')
  final int totalPages;
  @JsonKey(name: 'total_results')
  final int totalResults;

  MovieResponse({
    required this.results,
    required this.page,
    required this.totalPages,
    required this.totalResults,
  });

  factory MovieResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MovieResponseToJson(this);
}
