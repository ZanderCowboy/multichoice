import 'package:auto_route/auto_route.dart';
import 'package:multichoice/app/engine/app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route,Screen')
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomePageRoute.page, initial: true),
        AutoRoute(page: EditTabPageRoute.page),
        AutoRoute(page: EditEntryPageRoute.page),
      ];
}
