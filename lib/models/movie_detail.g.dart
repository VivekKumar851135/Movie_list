// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_detail.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieDetailAdapter extends TypeAdapter<MovieDetail> {
  @override
  final int typeId = 1;

  @override
  MovieDetail read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieDetail(
      title: fields[0] as String,
      year: fields[1] as String,
      rated: fields[2] as String,
      plot: fields[3] as String,
      poster: fields[4] as String,
      imdbRating: fields[5] as String,
      director: fields[6] as String,
      actors: fields[7] as String,
      runtime: fields[8] as String,
      genre: fields[9] as String,
      released: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MovieDetail obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.year)
      ..writeByte(2)
      ..write(obj.rated)
      ..writeByte(3)
      ..write(obj.plot)
      ..writeByte(4)
      ..write(obj.poster)
      ..writeByte(5)
      ..write(obj.imdbRating)
      ..writeByte(6)
      ..write(obj.director)
      ..writeByte(7)
      ..write(obj.actors)
      ..writeByte(8)
      ..write(obj.runtime)
      ..writeByte(9)
      ..write(obj.genre)
      ..writeByte(10)
      ..write(obj.released);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieDetailAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieDetail _$MovieDetailFromJson(Map<String, dynamic> json) => MovieDetail(
      title: json['Title'] as String? ?? '',
      year: json['Year'] as String? ?? 'N/A',
      rated: json['Rated'] as String? ?? 'N/A',
      plot: json['Plot'] as String? ?? 'No plot available',
      poster: json['Poster'] as String? ?? '',
      imdbRating: json['imdbRating'] as String? ?? 'N/A',
      director: json['Director'] as String? ?? 'N/A',
      actors: json['Actors'] as String? ?? 'N/A',
      runtime: json['Runtime'] as String? ?? 'N/A',
      genre: json['Genre'] as String? ?? 'N/A',
      released: json['Released'] as String? ?? 'N/A',
    );

Map<String, dynamic> _$MovieDetailToJson(MovieDetail instance) =>
    <String, dynamic>{
      'Title': instance.title,
      'Year': instance.year,
      'Rated': instance.rated,
      'Plot': instance.plot,
      'Poster': instance.poster,
      'imdbRating': instance.imdbRating,
      'Director': instance.director,
      'Actors': instance.actors,
      'Runtime': instance.runtime,
      'Genre': instance.genre,
      'Released': instance.released,
    };
