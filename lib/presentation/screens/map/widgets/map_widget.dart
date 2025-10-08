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

  bool _listenWhen(MapState p, MapState c) {
    final cPoint = c.selectedPoint;
    if (cPoint == null) return false;
    if (p.selectedPoint != cPoint && cPoint.isValid) return true;
    return false;
  }

  void _listener(BuildContext context, MapState state) {
    final point = state.selectedPoint;
    if (point == null) return;
    _mapController.move(
      LatLng(point.latitudeInDegrees, point.longitudeInDegrees),
      15.0,
    );
  }

  bool _buildWhen(MapState p, MapState c) => p.segments != c.segments || p.selectedPoint != c.selectedPoint;

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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MapBloc, MapState>(
      listenWhen: _listenWhen,
      listener: _listener,
      buildWhen: _buildWhen,
      builder: (context, state) {
        return FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialZoom: 10.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.mapoftpoints',
            ),
            ..._buildPolylines(state.segments),
            if (state.selectedPoint != null && state.selectedPoint!.isValid) _buildSelectedMarker(state.selectedPoint!),
          ],
        );
      },
    );
  }
}

