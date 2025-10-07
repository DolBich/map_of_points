import 'package:auto_route/annotations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_of_points/data/bloc/map/map_bloc.dart';
import 'package:map_of_points/domain/entities/gps_point.dart';
import 'package:map_of_points/presentation/screens/map/widgets/map_widget.dart';

part 'map_form.dart';
part 'widgets.dart';

@RoutePage()
class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MapBloc>(
      create: (_) => MapBloc(),
      child: MapForm(),
    );
  }
}
