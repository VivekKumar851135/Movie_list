import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class Movie extends HiveObject {
  @HiveField(0)
  final int id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final int? year;
  
  @HiveField(3)
  @JsonKey(name: 'imdb_id')
  final String? imdbId;
  
  @HiveField(4)
  @JsonKey(name: 'tmdb_id')
  final int? tmdbId;
  
  @HiveField(5)
  @JsonKey(name: 'tmdb_type')
  final String? tmdbType;
  
  @HiveField(6)
  final String type;

  Movie({
    required this.id,
    required this.title,
    this.year,
    this.imdbId,
    this.tmdbId,
    this.tmdbType,
    required this.type,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
  Map<String, dynamic> toJson() => _$MovieToJson(this);
}
