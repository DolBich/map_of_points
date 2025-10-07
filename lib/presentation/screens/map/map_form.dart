part of 'map_screen.dart';

class MapForm extends StatelessWidget {
  const MapForm({super.key});

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      title: const Text('Flight Log'),
      actions: [
        IconButton(
          icon: const Icon(Icons.file_upload),
          tooltip: 'Upload file',
          onPressed: () => _pickFile(context),
        ),
      ],
    );
  }

  bool _listenWhen(MapState p, MapState c) => p.error != c.error;

  void _listener(BuildContext context, MapState state) {
    if (state.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.error!.toText),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  bool _buildWhen(MapState p, MapState c) =>
      p.isLoading != c.isLoading || p.points != c.points || p.selectedPoint != c.selectedPoint;

  Widget _builder(BuildContext context, MapState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // Карта
        Expanded(
          child: Center(
            child: state.points.isEmpty
                ? const Center(child: Text('No data loaded\nUse upload button to load flight log'))
                : const MapWidget(),
          ),
        ),
        // Панель информации о точке
        if (state.selectedPoint != null) _PointWidget(point: state.selectedPoint!),
        // Слайдер
        if (state.points.isNotEmpty) _TimelineSlider(),
      ],
    );
  }

  Future<void> _pickFile(BuildContext context) async {
    final bloc = context.read<MapBloc>();
    try {
      final result = await FilePicker.platform.pickFiles(
        dialogTitle: 'Select .bin file',
        type: FileType.custom,
        allowedExtensions: ['bin'],
        withData: true,
      );

      if (result == null) return;
      final bytes = result.files.single.bytes;
      if (bytes == null) return;
      bloc.add(MapEvent.fileSelected(bytes));
    } catch (e) {
      debugPrint('failed to pick file: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: BlocConsumer<MapBloc, MapState>(
        listener: _listener,
        listenWhen: _listenWhen,
        builder: _builder,
        buildWhen: _buildWhen,
      ),
    );
  }
}
