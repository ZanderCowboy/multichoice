import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'product_bloc.freezed.dart';
part 'product_event.dart';
part 'product_state.dart';

@Injectable()
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductState.initial()) {
    on<ProductEvent>((event, emit) {
      event.map(
          onGetCurrentStep: (_) {},
          updateCurrentStep: (_) {
            emit(
              state.copyWith(
                currentStep: state.currentStep + 1,
              ),
            );
          });
    });
  }
}
