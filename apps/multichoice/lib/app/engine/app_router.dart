import 'package:auto_route/auto_route.dart';
import 'package:multichoice/app/engine/app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route,Screen')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType =>
      RouteType.custom(transitionsBuilder: TransitionsBuilders.noTransition);

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: HomePageWrapperRoute.page, initial: true),
    AutoRoute(page: LoginPageRoute.page),
    AutoRoute(page: SignupPageRoute.page),
    AutoRoute(page: ForgotPasswordPageRoute.page),
    AutoRoute(page: ResetPasswordPageRoute.page),
    AutoRoute(page: DebugPageRoute.page),
    AutoRoute(page: DataTransferScreenRoute.page),
    AutoRoute(page: EditTabPageRoute.page),
    AutoRoute(page: EditEntryPageRoute.page),
    AutoRoute(page: TutorialPageRoute.page),
    AutoRoute(page: FeedbackPageRoute.page),
    AutoRoute(page: ChangelogPageRoute.page),
    AutoRoute(page: SearchPageRoute.page),
    AutoRoute(page: DetailsPageRoute.page),
  ];
}
