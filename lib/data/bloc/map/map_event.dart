part of 'map_bloc.dart';

sealed class MapEvent {
  const MapEvent();

  const factory MapEvent.fileSelected(Uint8List fileData) = _FileSelected;
  const factory MapEvent.pointSelected(int index) = _PointSelected;
}

class _FileSelected extends MapEvent {
  final Uint8List fileData;
  const _FileSelected(this.fileData);
}

class _PointSelected extends MapEvent {
  final int index;
  const _PointSelected(this.index);
}