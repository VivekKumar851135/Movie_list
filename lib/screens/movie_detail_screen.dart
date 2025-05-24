import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/movie_detail.dart';

class MovieDetailScreen extends StatelessWidget {
  final MovieDetail detail;

  const MovieDetailScreen({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                detail.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (detail.poster.isNotEmpty)
                    Hero(
                      tag: 'movie-poster-${detail.title}',
                      child: CachedNetworkImage(
                        imageUrl: detail.poster,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.black26,
                          child: const Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.black12,
                          child: const Icon(Icons.error, color: Colors.white),
                        ),
                      ),
                    ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black54,
                          Colors.black87,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRatingBar(theme),
                  const SizedBox(height: 24),
                  _buildInfoRow(theme, 'Released', detail.year),
                  _buildInfoRow(theme, 'Rating', detail.rated),
                  _buildInfoRow(theme, 'IMDB', detail.imdbRating),
                  const SizedBox(height: 24),
                  Text(
                    'Plot',
                    style: theme.textTheme.titleLarge?.copyWith(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    detail.plot,
                    style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white60),
                  ),
                  const SizedBox(height: 24),
                  _buildCrewSection(theme, 'Director', detail.director),
                  _buildCrewSection(theme, 'Cast', detail.actors),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(ThemeData theme) {
    final rating = double.tryParse(detail.imdbRating.replaceAll('N/A', '0')) ?? 0;
    final ratingPercent = (rating / 10).clamp(0.0, 1.0);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'IMDB Rating',
          style: theme.textTheme.titleMedium?.copyWith(color: Colors.white70),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: ratingPercent,
            minHeight: 8,
            backgroundColor: Colors.grey[900],
            valueColor: AlwaysStoppedAnimation<Color>(
              HSLColor.fromAHSL(1, 120 * ratingPercent, 1, 0.5).toColor(),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${(ratingPercent * 10).toStringAsFixed(1)}/10',
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white60),
        ),
      ],
    );
  }

  Widget _buildInfoRow(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: theme.textTheme.titleMedium?.copyWith(color: Colors.white70),
          ),
          Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white60),
          ),
        ],
      ),
    );
  }

  Widget _buildCrewSection(ThemeData theme, String label, String names) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleLarge?.copyWith(color: Colors.white70),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: names.split(', ').map((name) => Chip(
            label: Text(name),
            backgroundColor: Colors.grey[900],
            labelStyle: TextStyle(color: Colors.white70),
            side: BorderSide(color: Colors.grey[800]!),
          )).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
