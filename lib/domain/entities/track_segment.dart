import 'package:map_of_points/domain/entities/gps_point.dart';

class TrackSegment {
  final List<GpsPoint> points;
  final bool hasGapBefore;

  const TrackSegment({
    required this.points,
    this.hasGapBefore = false,
  });

  bool get isEmpty => points.isEmpty;
}