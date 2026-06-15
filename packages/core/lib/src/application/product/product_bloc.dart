import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:models/models.dart';

part 'product_event.dart';
part 'product_state.dart';
part 'product_bloc.g.dart';

@Singleton()
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc(
    this._appTipsController,
    this._analyticsService,
  ) : super(ProductState.initial()) {
    on<ProductEvent>((event, emit) async {
      switch (event) {
        case OnInit():
          final activeTip = await _appTipsController.activeTip;
          await _analyticsService.logEvent(
            TutorialEventData(
              page: AnalyticsPage.home,
              action: AnalyticsAction.open,
              tip: activeTip,
            ),
          );

          emit(
            state.copyWith(
              activeTip: activeTip,
              isLoading: false,
              errorMessage: null,
            ),
          );
          break;
        case OnDismissTip(:final tip):
          await _appTipsController.dismissTip(tip);
          final activeTip = await _appTipsController.activeTip;
          await _analyticsService.logEvent(
            TutorialEventData(
              page: AnalyticsPage.home,
              action: AnalyticsAction.next,
              tip: activeTip,
            ),
          );

          emit(
            state.copyWith(
              activeTip: activeTip,
              isLoading: false,
              errorMessage: null,
            ),
          );
          break;
        case OnSkipAllTips():
          await _appTipsController.completeTips();
          await _analyticsService.logEvent(
            const TutorialEventData(
              page: AnalyticsPage.home,
              action: AnalyticsAction.skip,
            ),
          );

          emit(
            state.copyWith(
              activeTip: null,
              isLoading: false,
              errorMessage: null,
            ),
          );
          break;
        case OnResetTips():
          emit(state.copyWith(isLoading: true));

          await _appTipsController.resetTips();
          final activeTip = await _appTipsController.activeTip;
          await _analyticsService.logEvent(
            TutorialEventData(
              page: AnalyticsPage.home,
              action: AnalyticsAction.reset,
              tip: activeTip,
            ),
          );

          emit(
            state.copyWith(
              activeTip: activeTip,
              isLoading: false,
              errorMessage: null,
            ),
          );
          break;
      }
    });
  }

  final IAppTipsController _appTipsController;
  final IAnalyticsService _analyticsService;
}
