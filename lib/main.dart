import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dio/dio.dart';
import 'package:movie_list_app/bloc/bloc_event.dart';
import 'package:movie_list_app/models/movie_detail.dart';
import 'package:movie_list_app/screens/movie_list_screen.dart';
import 'models/movie.dart';
import 'api/movie_api_service.dart';
import 'bloc/movie_bloc.dart';
import 'api/api_interceptor.dart';
import 'screens/movie_detail_screen.dart';
import 'widgets/loading_overlay.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(MovieAdapter());
  final movieBox = await Hive.openBox<Movie>('movies');
  
  final dio = Dio()
    ..interceptors.addAll([
      ApiInterceptor(),
      LogInterceptor(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        logPrint: (obj) {
          if (obj is Map) {
            print(obj.toString());
          } else {
            print(obj);
          }
        },
      ),
    ]);
    
  final movieService = MovieApiService(dio);
  
  runApp(MyApp(movieBox: movieBox, movieService: movieService));
}

class MyApp extends StatelessWidget {
  final Box<Movie> movieBox;
  final MovieApiService movieService;

  const MyApp({super.key, required this.movieBox, required this.movieService});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovieBloc(movieService, movieBox)..add(FetchMovies()),
      child: MaterialApp(
        title: 'Movie List App',
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black,
            elevation: 0,
          ),
          cardTheme: CardTheme(
            elevation: 4,
            color: Colors.grey[900],
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),
        home: const MovieListScreen(),
      ),
    );
  }
}

