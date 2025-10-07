import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_of_points/data/bloc/map/map_bloc.dart';
import 'package:map_of_points/domain/entities/gps_point.dart';
import 'package:map_of_points/domain/entities/track_segment.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final MapController _mapController = MapController();

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MapBloc, MapState>(
      listenWhen: (previous, current) =>
      previous.selectedPoint != current.selectedPoint &&
          current.selectedPoint != null &&
          current.selectedPoint!.isValid,
      listener: (context, state) {
        // Центрируем карту на выбранной точке
        final point = state.selectedPoint!;
        _mapController.move(
          LatLng(point.latitudeInDegrees, point.longitudeInDegrees),
          15.0, // zoom level
        );
      },
      child: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          return FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(55.7558, 37.6173), // Москва по умолчанию
              initialZoom: 13.0,
              minZoom: 3.0,
              maxZoom: 18.0,
            ),
            children: [
              // Слой тайлов (карта)
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.mapoftpoints',
              ),
              // Слой полилиний (треки)
              ..._buildPolylines(state.segments),
              // Слой маркеров (текущая точка)
              if (state.selectedPoint != null && state.selectedPoint!.isValid)
                _buildSelectedMarker(state.selectedPoint!),
            ],
          );
        },
      ),
    );
  }

  List<PolylineLayer> _buildPolylines(List<TrackSegment> segments) {
    return segments.map((segment) {
      return PolylineLayer(
        polylines: [
          Polyline(
            points: segment.points
                .where((point) => point.isValid)
                .map((point) => LatLng(
              point.latitudeInDegrees,
              point.longitudeInDegrees,
            ))
                .toList(),
            strokeWidth: 4.0,
            color: segment.hasGapBefore ? Colors.orange : Colors.blue,
          ),
        ],
      );
    }).toList();
  }

  MarkerLayer _buildSelectedMarker(GpsPoint point) {
    return MarkerLayer(
      markers: [
        Marker(
          width: 40.0,
          height: 40.0,
          point: LatLng(point.latitudeInDegrees, point.longitudeInDegrees),
          child: const Icon(
            Icons.location_pin,
            color: Colors.red,
            size: 40.0,
          ),
        ),
      ],
    );
  }
}
