import 'package:map_of_points/domain/entities/gps_point.dart';
import 'package:map_of_points/domain/entities/track_segment.dart';

class TrackBuilder {
  static List<TrackSegment> buildSegments(List<GpsPoint> points) {
    final segments = <TrackSegment>[];
    var currentSegment = <GpsPoint>[];
    var hasGapBefore = false;

    for (final point in points) {
      if (point.isValid) {
        if (currentSegment.isNotEmpty &&
            !_isConsecutive(currentSegment.last, point)) {
          segments.add(TrackSegment(
            points: List.from(currentSegment),
            hasGapBefore: hasGapBefore,
          ));
          currentSegment.clear();
          hasGapBefore = true;
        }
        currentSegment.add(point);
        hasGapBefore = false;
      } else {
        hasGapBefore = currentSegment.isNotEmpty;
      }
    }

    if (currentSegment.isNotEmpty) {
      segments.add(TrackSegment(
        points: currentSegment,
        hasGapBefore: hasGapBefore,
      ));
    }

    return segments;
  }

  static bool _isConsecutive(GpsPoint previous, GpsPoint current) {
    return current.index == previous.index + 1;
  }
}