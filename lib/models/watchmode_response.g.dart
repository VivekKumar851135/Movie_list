// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watchmode_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WatchmodeResponse _$WatchmodeResponseFromJson(Map<String, dynamic> json) =>
    WatchmodeResponse(
      titles: (json['titles'] as List<dynamic>)
          .map((e) => Movie.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WatchmodeResponseToJson(WatchmodeResponse instance) =>
    <String, dynamic>{
      'titles': instance.titles,
    };
