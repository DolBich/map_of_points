part of 'map_bloc.dart';

class MapState with EquatableMixin {
  final List<GpsPoint> points;
  final List<TrackSegment> segments;
  final GpsPoint? selectedPoint;
  final bool isLoading;
  final GPSFailure? error;

  const MapState({
    required this.points,
    required this.segments,
    this.selectedPoint,
    this.isLoading = false,
    this.error,
  });

  factory MapState.initial() {
    return MapState(
      points: const [],
      segments: const [],
    );
  }

  MapState copyWith({
    List<GpsPoint>? points,
    List<TrackSegment>? segments,
    GpsPoint? selectedPoint,
    bool? isLoading,
    GPSFailure? error,
  }) {
    return MapState(
      points: points ?? this.points,
      segments: segments ?? this.segments,
      selectedPoint: selectedPoint ?? this.selectedPoint,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        points,
        segments,
        selectedPoint,
        isLoading,
        error,
      ];
}
