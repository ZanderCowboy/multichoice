import 'package:auto_route/auto_route.dart';
import 'package:multichoice/app/engine/app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route,Screen')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomePageWrapperRoute.page, initial: true),
        AutoRoute(page: DataTransferScreenRoute.page),
        AutoRoute(page: EditTabPageRoute.page),
        AutoRoute(page: EditEntryPageRoute.page),
        AutoRoute(page: TutorialPageRoute.page),
        AutoRoute(page: FeedbackPageRoute.page),
        AutoRoute(page: SearchPageRoute.page),
        AutoRoute(page: DetailsPageRoute.page),
      ];
}
