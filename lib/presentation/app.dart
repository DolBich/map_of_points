import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:map_of_points/presentation/routes/router.dart';
import 'package:map_of_points/presentation/widgets/loading_error_widget.dart';

class App extends StatelessWidget {
  final _appRouter = AppRouter();

  App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Map of points',
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        if (child == null) return const LoadingErrorWidget();
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
      routerDelegate: AutoRouterDelegate(
        _appRouter,
      ),
      routeInformationParser: _appRouter.defaultRouteParser(),
    );
  }
}
