part of 'map_bloc.dart';

sealed class MapEvent {
  const MapEvent();

  const factory MapEvent.uploadData() = _UploadData;
}

class _UploadData extends MapEvent {
  const _UploadData();
}