import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapState.initial()) {
    on<_UploadData>(_uploadData);
  }

  Future<void> _uploadData(_UploadData event, Emitter<MapState> emit) async {

  }
}