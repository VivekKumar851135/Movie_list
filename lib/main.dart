import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dio/dio.dart';
import 'package:movie_list_app/models/movie_detail.dart';
import 'models/movie.dart';
import 'api/movie_api_service.dart';
import 'bloc/movie_bloc.dart';
import 'api/api_interceptor.dart';

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
    return MaterialApp(
      title: 'Movie List App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: BlocProvider(
        create: (context) => MovieBloc(movieService, movieBox)..add(FetchMovies()),
        child: const MovieListScreen(),
      ),
    );
  }
}

class MovieListScreen extends StatelessWidget {
  const MovieListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movies')),
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is MovieLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MovieError) {
            return Center(child: Text(state.message));
          } else if (state is MovieLoaded) {
            return ListView.builder(
              itemCount: state.movies.length,
              itemBuilder: (context, index) {
                final movie = state.movies[index];
                return ListTile(
                  title: Text(movie.title),
                  subtitle: Text('Year: ${movie.year ?? "N/A"}'),
                  trailing: Text(movie.type),
                  onTap: () {
                    if (movie.imdbId != null) {
                      context.read<MovieBloc>().add(FetchMovieDetail(movie.imdbId!));
                      _showMovieDetails(context);
                    }
                  },
                );
              },
            );
          } else if (state is MovieDetailLoaded) {
            return _buildMovieDetailView(state.detail);
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildMovieDetailView(MovieDetail detail) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (detail.poster.isNotEmpty)
            Center(
              child: CachedNetworkImage(
                imageUrl: detail.poster,
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          const SizedBox(height: 16),
          Text(detail.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Year: ${detail.year}'),
          Text('Rating: ${detail.rated}'),
          Text('IMDB Rating: ${detail.imdbRating}'),
          const SizedBox(height: 16),
          Text('Director: ${detail.director}'),
          Text('Actors: ${detail.actors}'),
          const SizedBox(height: 16),
          Text('Plot: ${detail.plot}'),
        ],
      ),
    );
  }

  void _showMovieDetails(BuildContext context) {
     final bloc = context.read<MovieBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (_, controller) => BlocProvider.value(
          value: bloc,
          child: BlocBuilder<MovieBloc, MovieState>(
            builder: (context, state) {
              if (state is MovieDetailLoaded) {
                return _buildMovieDetailView(state.detail);
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
