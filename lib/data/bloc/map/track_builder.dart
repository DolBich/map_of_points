import 'package:map_of_points/domain/entities/gps_point.dart';
import 'package:map_of_points/domain/entities/track_segment.dart';

class TrackBuilder {
  static List<TrackSegment> buildSegments(List<GpsPoint> points) {
    final segments = <TrackSegment>[];
    var currentSegment = <GpsPoint>[];

    for (final point in points) {
      if (point.isValid) {
        if (!_isConsecutive(currentSegment.lastOrNull, point) && currentSegment.isNotEmpty) {
          segments.add(TrackSegment(
            points: List.from(currentSegment),
          ));
          currentSegment.clear();
        }
        currentSegment.add(point);
      }
    }

    if (currentSegment.isNotEmpty) {
      segments.add(TrackSegment(
        points: currentSegment,
      ));
    }

    return segments;
  }

  static bool _isConsecutive(GpsPoint? previous, GpsPoint current) {
    if(previous == null) return true;
    return current.index == previous.index + 1;
  }
}
