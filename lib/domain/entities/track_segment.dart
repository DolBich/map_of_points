import 'package:map_of_points/domain/entities/gps_point.dart';

class TrackSegment {
  final List<GpsPoint> points;

  const TrackSegment({required this.points});

  bool get isEmpty => points.isEmpty;
}
