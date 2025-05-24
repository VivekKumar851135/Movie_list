import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_list_app/bloc/bloc_event.dart';
import 'package:movie_list_app/bloc/bloc_state.dart';
import 'package:movie_list_app/models/movie_detail.dart';
import '../models/movie.dart';
import '../api/movie_api_service.dart';
import 'package:hive/hive.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../utils/error_handler.dart';



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
    if (state is MovieLoaded) {
      final currentMovies = (state as MovieLoaded).movies;
      emit(MovieDetailLoading(currentMovies));
      
      try {
        final detail = await _apiService.getMovieDetails(event.imdbId, "66d21b38");
        emit(MovieDetailLoaded(currentMovies, detail));
      } catch (e) {
        emit(MovieError(ErrorHandler.getErrorMessage(e)));
        emit(MovieLoaded(currentMovies)); // Restore previous state on error
      }
    }
  }

  String _handleError(error) {
    return ErrorHandler.getErrorMessage(error);
  }
}
