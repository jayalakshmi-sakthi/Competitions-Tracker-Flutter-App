// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'competition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Competition _$CompetitionFromJson(Map<String, dynamic> json) => Competition(
      id: json['id'] as String?,
      name: json['name'] as String?,
      details: json['details'] as String?,
      category: json['category'] as String?,
      image: json['image'] as String?,
      fee: json['fee'] as bool?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      level: json['level'] as String?,
    );

Map<String, dynamic> _$CompetitionToJson(Competition instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'details': instance.details,
      'category': instance.category,
      'image': instance.image,
      'date': instance.date?.toIso8601String(),
      'level': instance.level,
      'fee': instance.fee,
    };
