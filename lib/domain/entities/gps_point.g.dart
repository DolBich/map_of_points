// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gps_point.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GpsPoint _$GpsPointFromJson(Map<String, dynamic> json) => GpsPoint(
      gpsFix: (json['gpsFix'] as num).toInt(),
      latitude: (json['latitude'] as num).toInt(),
      longitude: (json['longitude'] as num).toInt(),
      altitude: (json['altitude'] as num).toInt(),
      index: (json['index'] as num).toInt(),
    );

Map<String, dynamic> _$GpsPointToJson(GpsPoint instance) => <String, dynamic>{
      'gpsFix': instance.gpsFix,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'altitude': instance.altitude,
      'index': instance.index,
    };
