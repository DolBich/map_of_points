import 'package:auto_route/auto_route.dart';
import 'package:map_of_points/presentation/screens/map/map_screen.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  AppRouter();

  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
        CustomRoute(
          page: MapRoute.page,
          path: '/',
        ),
      ];
}
