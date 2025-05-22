import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'movie_detail.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class MovieDetail extends HiveObject {
  @HiveField(0)
  @JsonKey(name: 'Title', defaultValue: '')
  final String title;
  
  @HiveField(1)
  @JsonKey(name: 'Year', defaultValue: 'N/A')
  final String year;
  
  @HiveField(2)
  @JsonKey(name: 'Rated', defaultValue: 'N/A')
  final String rated;
  
  @HiveField(3)
  @JsonKey(name: 'Plot', defaultValue: 'No plot available')
  final String plot;
  
  @HiveField(4)
  @JsonKey(name: 'Poster', defaultValue: '')
  final String poster;
  
  @HiveField(5)
  @JsonKey(name: 'imdbRating', defaultValue: 'N/A')
  final String imdbRating;
  
  @HiveField(6)
  @JsonKey(name: 'Director', defaultValue: 'N/A')
  final String director;
  
  @HiveField(7)
  @JsonKey(name: 'Actors', defaultValue: 'N/A')
  final String actors;
  
  @HiveField(8)
  @JsonKey(name: 'Runtime', defaultValue: 'N/A')
  final String runtime;
  
  @HiveField(9)
  @JsonKey(name: 'Genre', defaultValue: 'N/A')
  final String genre;
  
  @HiveField(10)
  @JsonKey(name: 'Released', defaultValue: 'N/A')
  final String released;

  MovieDetail({
    required this.title,
    required this.year,
    required this.rated,
    required this.plot,
    required this.poster,
    required this.imdbRating,
    required this.director,
    required this.actors,
    required this.runtime,
    required this.genre,
    required this.released,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) => _$MovieDetailFromJson(json);
  Map<String, dynamic> toJson() => _$MovieDetailToJson(this);
}
