import 'package:json_annotation/json_annotation.dart';

part 'gps_point.g.dart';

@JsonSerializable()
class GpsPoint {
  final int gpsFix;
  final int latitude;
  final int longitude;
  final int altitude;
  final int index;

  const GpsPoint({
    required this.gpsFix,
    required this.latitude,
    required this.longitude,
    required this.altitude,
    required this.index,
  });

  bool get isValid {
    return gpsFix >= 1 && gpsFix <= 3 &&
        latitude >= -90e7 && latitude <= 90e7 &&
        longitude >= -180e7 && longitude <= 180e7 &&
        altitude >= -500 && altitude <= 20000;
  }

  double get latitudeInDegrees => latitude / 1e7;
  double get longitudeInDegrees => longitude / 1e7;

  String get fixDescription {
    switch (gpsFix) {
      case 0: return 'No Fix';
      case 1: return 'Weak Fix';
      case 2: return '2D Fix';
      case 3: return '3D Fix';
      default: return 'Unknown';
    }
  }

  factory GpsPoint.fromJson(Map<String, dynamic> json) => _$GpsPointFromJson(json);

  Map<String, dynamic> toJson() => _$GpsPointToJson(this);

  @override
  String toString() {
    return 'fix: $gpsFix, lat: $latitudeInDegrees, lon: $longitudeInDegrees, alt: $altitude, valid: $isValid)';
  }
}