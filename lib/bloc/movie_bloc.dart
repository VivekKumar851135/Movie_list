import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_list_app/models/movie_detail.dart';
import '../models/movie.dart';
import '../api/movie_api_service.dart';
import 'package:hive/hive.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Events
abstract class MovieEvent {}
class FetchMovies extends MovieEvent {}
class FetchMovieDetail extends MovieEvent {
  final String imdbId;
  FetchMovieDetail(this.imdbId);
}

// States
abstract class MovieState {}
class MovieInitial extends MovieState {}
class MovieLoading extends MovieState {}
class MovieLoaded extends MovieState {
  final List<Movie> movies;
  final bool isOffline;
  MovieLoaded(this.movies, {this.isOffline = false});
}
class MovieDetailLoaded extends MovieState {
  final MovieDetail detail;
  MovieDetailLoaded(this.detail);
}
class MovieError extends MovieState {
  final String message;
  MovieError(this.message);
}

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieApiService _apiService;
  final Box<Movie> _movieBox;

  MovieBloc(this._apiService, this._movieBox) : super(MovieInitial()) {
    on<FetchMovies>(_onFetchMovies);
    on<FetchMovieDetail>(_onFetchMovieDetail);
  }

  Future<void> _onFetchMovies(FetchMovies event, Emitter<MovieState> emit) async {
    emit(MovieLoading());
    
    final connectivityResult = await Connectivity().checkConnectivity();
    
    if (connectivityResult == ConnectivityResult.none) {
      // Load from Hive when offline
      final cachedMovies = _movieBox.values.toList();
      if (cachedMovies.isNotEmpty) {
        emit(MovieLoaded(cachedMovies, isOffline: true));
      } else {
        emit(MovieError("No cached data available offline"));
      }
      return;
    }

    try {
      final response = await _apiService.getMovies("203,57", "rDiPBDGNyiS2mdiCIO2OVAaNHrJ5tmnODZ7EfDej");
      await _movieBox.clear(); // Clear old cache
      await _movieBox.putAll(Map.fromIterable(response.titles, 
          key: (m) => m.id.toString()));
      emit(MovieLoaded(response.titles));
    } catch (e) {
      // Try to load from cache if API call fails
      final cachedMovies = _movieBox.values.toList();
      if (cachedMovies.isNotEmpty) {
        emit(MovieLoaded(cachedMovies, isOffline: true));
      } else {
        emit(MovieError(_handleError(e)));
      }
    }
  }

  Future<void> _onFetchMovieDetail(FetchMovieDetail event, Emitter<MovieState> emit) async {
    emit(MovieLoading());
    try {
      if (event.imdbId.isEmpty) {
        emit(MovieError("Invalid IMDB ID"));
        return;
      }
      
      final detail = await _apiService.getMovieDetails(
        event.imdbId,
        "66d21b38", // OMDB API key
      );
      emit(MovieDetailLoaded(detail));
    } catch (e) {
      if (e is DioError) {
        emit(MovieError(_handleError(e)));
      } else {
        emit(MovieError("Failed to load movie details"));
      }
    }
  }

  String _handleError(error) {
    switch (error.response?.statusCode) {
      case 400:
        return "Invalid request. Please try again.";
      case 401:
        return "Unauthorized. Please login again.";
      case 404:
        return "The requested resource was not found.";
      case 500:
        return "Server error. Please try again later.";
      default:
        return "An error occurred. Please try again.";
    }
  }
}
