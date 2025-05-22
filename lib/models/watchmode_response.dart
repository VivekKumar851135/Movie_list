import 'package:json_annotation/json_annotation.dart';
import 'movie.dart';

part 'watchmode_response.g.dart';

@JsonSerializable()
class WatchmodeResponse {
  final List<Movie> titles;

  WatchmodeResponse({required this.titles});

  factory WatchmodeResponse.fromJson(Map<String, dynamic> json) =>
      _$WatchmodeResponseFromJson(json);
  
  Map<String, dynamic> toJson() => _$WatchmodeResponseToJson(this);
}
