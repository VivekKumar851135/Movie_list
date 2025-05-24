import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_list_app/bloc/bloc_event.dart';
import 'package:movie_list_app/bloc/bloc_state.dart';
import 'package:movie_list_app/bloc/movie_bloc.dart';
import 'package:movie_list_app/screens/movie_detail_screen.dart';
import 'package:movie_list_app/widgets/loading_overlay.dart';
import 'package:movie_list_app/widgets/connectivity_icon.dart';

class MovieListScreen extends StatelessWidget {
  const MovieListScreen({super.key});

  void _dismissDialog(BuildContext context) {
    if (ModalRoute.of(context)?.isCurrent != true) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<MovieBloc, MovieState>(
      listenWhen: (previous, current) => 
          current is MovieDetailLoaded || 
          current is MovieDetailLoading || 
          current is MovieError,
      listener: (context, state) async {
        if (state is MovieDetailLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const LoadingOverlay(),
          );
        } else if (state is MovieDetailLoaded) {
          _dismissDialog(context);
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MovieDetailScreen(detail: state.detail),
            ),
          );
        } else if (state is MovieError) {
          _dismissDialog(context);
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              backgroundColor: Colors.grey[900],
              title: Row(
                children: [
                  Icon(Icons.error_outline, color: theme.colorScheme.error),
                  const SizedBox(width: 8),
                  const Text('Error', style: TextStyle(color: Colors.white)),
                ],
              ),
              content: Text(
                state.message,
                style: const TextStyle(color: Colors.white70),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ],
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Movies',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
             const ConnectivityIcon(),
            const SizedBox(width: 8),
            
          ],
        ),
        body: BlocBuilder<MovieBloc, MovieState>(
          buildWhen: (previous, current) => 
              current is! MovieDetailLoaded && current is! MovieDetailLoading,
          builder: (context, state) {
            if (state is MovieLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MovieError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: theme.textTheme.titleMedium?.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              );
            } else if (state is MovieLoaded) {
              return ListView.builder(
                padding: const EdgeInsets.only(top: 8),
                itemCount: state.movies.length,
                itemBuilder: (context, index) {
                  final movie = state.movies[index];
                  return Card(
                    child: InkWell(
                      onTap: () {
                        if (movie.imdbId != null) {
                          context.read<MovieBloc>().add(FetchMovieDetail(movie.imdbId!));
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.grey[900]!,
                              Colors.grey[850]!,
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 100,
                                height: 150,
                                decoration: BoxDecoration(
                                  color: Colors.grey[800],
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    movie.title.substring(0, 1),
                                    style: theme.textTheme.displayMedium?.copyWith(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      movie.title,
                                      style: theme.textTheme.titleLarge?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Year: ${movie.year ?? "N/A"}',
                                      style: theme.textTheme.bodyLarge?.copyWith(
                                        color: Colors.white70,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Chip(
                                      label: Text(movie.type),
                                      backgroundColor: Colors.grey[800],
                                      side: BorderSide(color: Colors.grey[700]!),
                                      labelStyle: TextStyle(color: Colors.white70),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
