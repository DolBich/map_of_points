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
          Text('Point ${point.index}: ${point.fixDescription}',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Latitude: ${point.latitudeInDegrees.toStringAsFixed(6)}°'),
          Text('Longitude: ${point.longitudeInDegrees.toStringAsFixed(6)}°'),
          Text('Altitude: ${point.altitude} m'),
          Text('Status: ${point.isValid ? "Valid" : "Invalid"}',
              style: TextStyle(
                color: point.isValid ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }
}

class _TimelineSlider extends StatelessWidget {
  const _TimelineSlider();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      buildWhen: (p, c) =>
      p.points.length != c.points.length ||
          p.selectedPoint != c.selectedPoint,
      builder: (context, state) {
        final index = state.selectedPoint?.index ?? 0;
        final length = state.points.length;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              Slider(
                value: index.toDouble(),
                min: 0,
                max: (length - 1).toDouble(),
                onChanged: (value) {
                  context.read<MapBloc>().add(MapEvent.pointSelected(value.toInt()));
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Point ${index + 1} of $length'),
                  if (state.selectedPoint != null)
                    Text(
                      state.selectedPoint!.fixDescription,
                      style: TextStyle(
                        color: _getFixColor(state.selectedPoint!.gpsFix),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getFixColor(int gpsFix) {
    switch (gpsFix) {
      case 3: return Colors.green;
      case 2: return Colors.blue;
      case 1: return Colors.orange;
      case 0: return Colors.red;
      default: return Colors.grey;
    }
  }
}

