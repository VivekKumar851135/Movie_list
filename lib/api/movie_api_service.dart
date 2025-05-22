import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/watchmode_response.dart';
import '../models/movie_detail.dart';

part 'movie_api_service.g.dart';

@RestApi(baseUrl: "https://api.watchmode.com/v1")
abstract class MovieApiService {
  factory MovieApiService(Dio dio) = _MovieApiService;

  @GET("/list-titles/")
  Future<WatchmodeResponse> getMovies(
    @Query("source_ids") String sourceIds,
    @Query("apiKey") String apiKey,
  );

  @GET("http://www.omdbapi.com/")
  Future<MovieDetail> getMovieDetails(
    @Query("i") String imdbId,
    @Query("apikey") String apiKey,
  );
}
