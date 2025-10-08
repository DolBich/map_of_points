part of '../map_screen.dart';

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
