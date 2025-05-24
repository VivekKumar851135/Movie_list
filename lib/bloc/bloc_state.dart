
// States
import 'package:movie_list_app/models/movie.dart';
import 'package:movie_list_app/models/movie_detail.dart';

abstract class MovieState {}
class MovieInitial extends MovieState {}
class MovieLoading extends MovieState {}
class MovieLoaded extends MovieState {
  final List<Movie> movies;
  final bool isOffline;
  MovieLoaded(this.movies, {this.isOffline = false});
}
class MovieDetailLoading extends MovieLoaded {
  MovieDetailLoading(super.movies);
}
class MovieDetailLoaded extends MovieLoaded {
  final MovieDetail detail;
  MovieDetailLoaded(List<Movie> movies, this.detail) : super(movies);
}
class MovieError extends MovieState {
  final String message;
  MovieError(this.message);
}