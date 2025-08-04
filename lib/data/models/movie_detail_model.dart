import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/movie_detail.dart';

part 'movie_detail_model.g.dart';

@JsonSerializable()
class MovieDetailModel {
  final int id;
  final String title;
  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;
  @JsonKey(name: 'poster_path')
  final String? posterPath;
  @JsonKey(name: 'vote_average')
  final double voteAverage;
  final String overview;
  @JsonKey(name: 'release_date')
  final String releaseDate;
  final int runtime;
  final int budget;
  final int revenue;
  final List<GenreModel> genres;
  @JsonKey(name: 'vote_count')
  final int voteCount;

  const MovieDetailModel({
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
    required this.voteCount,
  });

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$MovieDetailModelToJson(this);

  MovieDetail toMovieDetail({bool isBookmarked = false}) {
    return MovieDetail(
      id: id,
      title: title,
      backdropPath: backdropPath,
      posterPath: posterPath,
      voteAverage: voteAverage,
      overview: overview,
      releaseDate: releaseDate,
      runtime: runtime,
      budget: budget,
      revenue: revenue,
      genres: genres.map((g) => g.name).toList(),
      isBookmarked: isBookmarked,
    );
  }
}

@JsonSerializable()
class GenreModel {
  final int id;
  final String name;

  const GenreModel({
    required this.id,
    required this.name,
  });

  factory GenreModel.fromJson(Map<String, dynamic> json) =>
      _$GenreModelFromJson(json);

  Map<String, dynamic> toJson() => _$GenreModelToJson(this);
}
