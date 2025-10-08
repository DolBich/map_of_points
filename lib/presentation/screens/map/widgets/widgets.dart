part of '../map_screen.dart';

class _PointWidget extends StatelessWidget {
  final GpsPoint point;

  const _PointWidget({required this.point});

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

    return TextStyle(
      fontWeight: FontWeight.bold,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
              text: TextSpan(
                  children: [
                    TextSpan(text: 'Point ${point.index}: ', style: TextStyle(color: Colors.black)),
                    TextSpan(text: point.fixDescription, style: _getFixStyle(point.gpsFix)),
                  ]
              ),
          ),
          const SizedBox(height: 8),
          Text('Latitude: ${point.latitudeInDegrees.toStringAsFixed(6)}°'),
          Text('Longitude: ${point.longitudeInDegrees.toStringAsFixed(6)}°'),
          Text('Altitude: ${point.altitude} m'),
          Text(
            'Status: ${point.isValid ? "Valid" : "Invalid"}',
            style: TextStyle(
              color: point.isValid ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineSlider extends StatelessWidget {
  const _TimelineSlider();

  BoxDecoration get _decoration {
    return BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(25),
          blurRadius: 4,
          offset: const Offset(0, -2),
        ),
      ],
    );
  }

  Widget _slider({
    required BuildContext context,
    required int length,
    required int index,
  }) {
    return Slider(
      value: index.toDouble(),
      min: 0,
      max: (length - 1).toDouble(),
      onChanged: (value) {
        final bloc = context.read<MapBloc>();
        bloc.add(MapEvent.pointSelected(value.toInt()));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      buildWhen: (p, c) => p.points.length != c.points.length || p.selectedPoint != c.selectedPoint,
      builder: (context, state) {
        final index = state.selectedPoint?.index ?? 0;
        final length = state.points.length;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: _decoration,
          child: Column(
            children: [
              Text('Point ${index + 1} of $length'),
              _slider(context: context, length: length, index: index),
            ],
          ),
        );
      },
    );
  }
}
