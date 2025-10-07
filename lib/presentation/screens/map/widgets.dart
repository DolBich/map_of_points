part of 'map_screen.dart';

class _PointWidget extends StatelessWidget {
  final GpsPoint point;
  const _PointWidget({required this.point});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Point ${point.index}: ${point.fixDescription}'),
          Text('Lat: ${point.latitudeInDegrees.toStringAsFixed(6)}'),
          Text('Lon: ${point.longitudeInDegrees.toStringAsFixed(6)}'),
          Text('Alt: ${point.altitude} m'),
          Text('Valid: ${point.isValid}'),
        ],
      ),
    );
  }
}

class _TimelineSlider extends StatelessWidget {
  const _TimelineSlider();

  Color _getFixColor(int gpsFix) {
    switch (gpsFix) {
      case 3: return Colors.green;
      case 2: return Colors.blue;
      case 1: return Colors.orange;
      case 0: return Colors.red;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      buildWhen: (p, c) => p.points.length != c.points.length || p.selectedPoint != c.selectedPoint,
      builder: (context, state) {
        final index = state.selectedPoint?.index ?? 0;
        final length = state.points.length;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Slider(
                value: index.toDouble(),
                min: 0,
                max: length - 1,
                onChanged: (value) {
                  context.read<MapBloc>().add(MapEvent.pointSelected(value.toInt()));
                },
              ),
              Text('Point $index of $length'),
            ],
          ),
        );
      },
    );
  }
}

