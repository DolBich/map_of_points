import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart' hide MapEvent;
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

  PolylineLayer _buildPolyline(List<TrackSegment> segments) {
    return PolylineLayer(
      polylines: segments.map((segment) {
        return Polyline(
          points: segment.points
              .where((point) => point.isValid)
              .map((point) => LatLng(
                    point.latitudeInDegrees,
                    point.longitudeInDegrees,
                  ))
              .toList(),
          strokeWidth: 4.0,
          color: Colors.orange,
        );
      }).toList(),
    );
  }

  static const double _markerSize = 40;
  static const double _disabledMarkerSize = 20;

  MarkerLayer _buildSelectedMarker(GpsPoint point, bool selected) {
    final icon = Icon(
      Icons.location_pin,
      color: selected ? Colors.red : Colors.grey,
      size: selected ? _markerSize : _disabledMarkerSize,
    );

    return MarkerLayer(
      markers: [
        Marker(
          height: selected ? _markerSize : _disabledMarkerSize,
          width: selected ? _markerSize : _disabledMarkerSize,
          alignment: Alignment.topCenter,
          point: LatLng(point.latitudeInDegrees, point.longitudeInDegrees),
          child: Tooltip(
            message: point.description,
            child: selected
                ? icon
                : IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      final bloc = context.read<MapBloc>();
                      bloc.add(MapEvent.pointSelected(point.index));
                    },
                    icon: Align(alignment: Alignment.topCenter, child: icon),
                  ),
          ),
        ),
      ],
    );
  }

  // GestureDetector(
  // onTap: selected ? null : (){
  // final bloc = context.read<MapBloc>();
  // bloc.add(MapEvent.pointSelected(point.index));
  // },
  // child: icon,
  // )),

  List<MarkerLayer> _buildMarkers(List<GpsPoint> points, GpsPoint? selectedPoint) {
    final List<MarkerLayer> res = [];

    for (final point in points) {
      if (point == selectedPoint || !point.isValid) {
        continue;
      }
      res.add(_buildSelectedMarker(point, false));
    }

    if (selectedPoint != null && selectedPoint.isValid) {
      res.add(_buildSelectedMarker(selectedPoint, true));
    }

    return res;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MapBloc, MapState>(
      listenWhen: _listenWhen,
      listener: _listener,
      buildWhen: _buildWhen,
      builder: (context, state) {
        final point = state.selectedPoint;
        final points = state.points;
        return FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter:
                point != null ? LatLng(point.latitudeInDegrees, point.longitudeInDegrees) : LatLng(50.5, 30.51),
            initialZoom: 15.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.mapoftpoints',
            ),
            _buildPolyline(state.segments),
            ..._buildMarkers(points, point),
            if (point != null)
              Align(
                alignment: Alignment.topRight,
                child: _PointWidget(point),
              )
          ],
        );
      },
    );
  }
}

class _PointWidget extends StatelessWidget {
  final GpsPoint point;

  const _PointWidget(this.point);

  static const _textStyle = TextStyle(fontSize: 20, color: Colors.black);
  static const _boldTextStyle = TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold);
  static const _sectionSpacing = SizedBox(height: 8);

  TextStyle _getFixStyle(int gpsFix) {
    final Color color;
    switch (gpsFix) {
      case 3:
        color = Colors.green;
      case 2:
        color = Colors.blue;
      case 1:
        color = Colors.orange;
      case 0:
        color = Colors.red;
      default:
        color = Colors.grey;
    }

    return _boldTextStyle.copyWith(color: color);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      color: Colors.grey[100]?.withAlpha(200),
      child: DefaultTextStyle(
        style: _textStyle,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(children: [
                TextSpan(text: 'Point ${point.index}: ', style: _textStyle),
                TextSpan(text: point.fixDescription, style: _getFixStyle(point.gpsFix)),
              ]),
            ),
            _sectionSpacing,
            Text('Latitude: ${point.latitudeInDegrees.toStringAsFixed(6)}°'),
            Text('Longitude: ${point.longitudeInDegrees.toStringAsFixed(6)}°'),
            Text('Altitude: ${point.altitude} m'),
            Text(
              'Status: ${point.isValid ? "Valid" : "Invalid"}',
              style: _boldTextStyle.copyWith(
                color: point.isValid ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
