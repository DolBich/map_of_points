import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_of_points/data/bloc/map/track_builder.dart';
import 'package:map_of_points/data/repositories/flight_log_repository.dart';
import 'package:map_of_points/domain/entities/track_segment.dart';
import 'package:map_of_points/domain/repositories/i_flight_log_repository.dart';

part 'map_event.dart';

part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  static final IFlightLogRepository _repository = FlightLogRepository();

  MapBloc() : super(MapState.initial()) {
    on<_FileSelected>(_onFileSelected);
    on<_PointSelected>(_onPointSelected);
  }

  Future<void> _onFileSelected(_FileSelected event, Emitter<MapState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));

    final result = await _repository.parseLog(event.fileData);

    result.fold(
      (points) {
        final segments = TrackBuilder.buildSegments(points);
        final selectedPoint = points.isNotEmpty ? points.first : null;

        emit(state.copyWith(
          points: points,
          segments: segments,
          selectedPoint: selectedPoint,
          isLoading: false,
        ));
      },
      (failure) {
        emit(state.copyWith(
          isLoading: false,
          error: failure,
        ));
      },
    );
  }

  void _onPointSelected(_PointSelected event, Emitter<MapState> emit) {
    if (event.index < state.points.length) {
      emit(state.copyWith(
        error: GPSFailure.smthWentWrong(),
        selectedPoint: state.points[event.index],
      ));
    }
  }
}
