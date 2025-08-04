import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../models/movie_model.dart';
import '../../models/movie_detail_model.dart';

part 'movie_remote_datasource.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class MovieRemoteDataSource {
  factory MovieRemoteDataSource() {
    final dio = Dio()
      ..options = BaseOptions(
        headers: {
          'accept': 'application/json',
        },
      );
    return _MovieRemoteDataSource(dio);
  }

  @GET("/movie/now_playing")
  Future<MovieResponse> getNowPlayingMovies(
    @Query("api_key") String apiKey,
    @Query("page") int page,
  );

  @GET("/trending/movie/week")
  Future<MovieResponse> getTrendingMovies(
    @Query("api_key") String apiKey,
    @Query("page") int page,
  );

  @GET("/search/movie")
  Future<MovieResponse> searchMovies(
    @Query("api_key") String apiKey,
    @Query("query") String query,
    @Query("page") int page,
  );

  @GET("/movie/{movie_id}")
  Future<MovieDetailModel> getMovieDetails(
    @Path("movie_id") int movieId,
    @Query("api_key") String apiKey,
  );
}
