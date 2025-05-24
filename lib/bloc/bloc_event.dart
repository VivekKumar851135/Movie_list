
// Events
abstract class MovieEvent {}
class FetchMovies extends MovieEvent {}
class FetchMovieDetail extends MovieEvent {
  final String imdbId;
  FetchMovieDetail(this.imdbId);
}