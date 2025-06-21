import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:models/models.dart';

part 'product_bloc.freezed.dart';
part 'product_event.dart';
part 'product_state.dart';

@Singleton()
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc(
    this._productTourController,
    this._tutorialRepository,
  ) : super(ProductState.initial()) {
    on<ProductEvent>((event, emit) async {
      switch (event) {
        case OnInit():
          final currentStep = await _productTourController.currentStep;

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

          emit(state.copyWith(
            tabs: tabs,
            isLoading: false,
          ));
          break;
        case OnClearData():
          emit(
            state.copyWith(
              tabs: null,
              isLoading: true,
            ),
          );

          break;
        default:
      }
    });
  }

  final IProductTourController _productTourController;
  final ITutorialRepository _tutorialRepository;
}
