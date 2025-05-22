// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieAdapter extends TypeAdapter<Movie> {
  @override
  final int typeId = 0;

  @override
  Movie read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Movie(
      id: fields[0] as int,
      title: fields[1] as String,
      year: fields[2] as int?,
      imdbId: fields[3] as String?,
      tmdbId: fields[4] as int?,
      tmdbType: fields[5] as String?,
      type: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Movie obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.year)
      ..writeByte(3)
      ..write(obj.imdbId)
      ..writeByte(4)
      ..write(obj.tmdbId)
      ..writeByte(5)
      ..write(obj.tmdbType)
      ..writeByte(6)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Movie _$MovieFromJson(Map<String, dynamic> json) => Movie(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      year: (json['year'] as num?)?.toInt(),
      imdbId: json['imdb_id'] as String?,
      tmdbId: (json['tmdb_id'] as num?)?.toInt(),
      tmdbType: json['tmdb_type'] as String?,
      type: json['type'] as String,
    );

Map<String, dynamic> _$MovieToJson(Movie instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'year': instance.year,
      'imdb_id': instance.imdbId,
      'tmdb_id': instance.tmdbId,
      'tmdb_type': instance.tmdbType,
      'type': instance.type,
    };
