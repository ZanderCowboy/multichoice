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
    this._productTourController,
    this._tutorialRepository,
    this._analyticsService,
  ) : super(ProductState.initial()) {
    on<ProductEvent>((event, emit) async {
      switch (event) {
        case OnInit():
          final currentStep = await _productTourController.currentStep;
          await _analyticsService.logEvent(
            TutorialEventData(
              page: AnalyticsPage.tutorial,
              action: AnalyticsAction.open,
              step: currentStep,
            ),
          );

          emit(
            state.copyWith(
              currentStep: currentStep,
              isLoading: false,
              errorMessage: null,
            ),
          );
          break;
        case OnNextStep():
          await _productTourController.nextStep();
          final currentStep = await _productTourController.currentStep;
          await _analyticsService.logEvent(
            TutorialEventData(
              page: AnalyticsPage.tutorial,
              action: AnalyticsAction.next,
              step: currentStep,
            ),
          );

          emit(
            state.copyWith(
              currentStep: currentStep,
              isLoading: false,
              errorMessage: null,
            ),
          );

          break;
        case OnPreviousStep():
          await _productTourController.previousStep();
          final currentStep = await _productTourController.currentStep;
          await _analyticsService.logEvent(
            TutorialEventData(
              page: AnalyticsPage.tutorial,
              action: AnalyticsAction.previous,
              step: currentStep,
            ),
          );

          emit(
            state.copyWith(
              currentStep: currentStep,
              isLoading: false,
              errorMessage: null,
            ),
          );
          break;
        case OnSkipTour():
          await _productTourController.completeTour();
          await _analyticsService.logEvent(
            const TutorialEventData(
              page: AnalyticsPage.tutorial,
              action: AnalyticsAction.skip,
              step: ProductTourStep.noneCompleted,
            ),
          );

          emit(
            state.copyWith(
              currentStep: ProductTourStep.noneCompleted,
              isLoading: false,
              errorMessage: null,
            ),
          );
          break;
        case OnResetTour():
          emit(state.copyWith(isLoading: true));

          await _productTourController.resetTour();
          await _analyticsService.logEvent(
            const TutorialEventData(
              page: AnalyticsPage.tutorial,
              action: AnalyticsAction.reset,
              step: ProductTourStep.reset,
            ),
          );

          emit(
            state.copyWith(
              currentStep: ProductTourStep.reset,
              isLoading: false,
              errorMessage: null,
            ),
          );
          break;
        case OnLoadData():
          final tabs = await _tutorialRepository.loadTutorialData();
          await _analyticsService.logEvent(
            CrudEventData(
              page: AnalyticsPage.tutorial,
              entity: AnalyticsEntity.tab,
              action: AnalyticsAction.open,
              itemCount: tabs.length,
            ),
          );

          emit(
            state.copyWith(
              tabs: tabs,
              isLoading: false,
            ),
          );
          break;
        case OnClearData():
          emit(
            state.copyWith(
              tabs: null,
              isLoading: true,
            ),
          );

          break;
      }
    });
  }

  final IProductTourController _productTourController;
  final ITutorialRepository _tutorialRepository;
  final IAnalyticsService _analyticsService;
}
