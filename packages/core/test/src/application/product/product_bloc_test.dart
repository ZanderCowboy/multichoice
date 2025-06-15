import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:models/models.dart';

import '../../../mocks.mocks.dart';

void main() {
  late ProductBloc productBloc;
  late MockProductTourController mockProductTourController;
  late MockTutorialRepository mockTutorialRepository;

  setUp(() {
    mockProductTourController = MockProductTourController();
    mockTutorialRepository = MockTutorialRepository();
    productBloc =
        ProductBloc(mockProductTourController, mockTutorialRepository);
  });

  tearDown(() {
    productBloc.close();
  });

  group('ProductBloc Tour Events', () {
    blocTest<ProductBloc, ProductState>(
      'emits [currentStep: step, isLoading: false, errorMessage: null] when OnInit is added',
      build: () {
        when(mockProductTourController.currentStep)
            .thenAnswer((_) async => ProductTourStep.welcomePopup);
        return productBloc;
      },
      act: (bloc) => bloc.add(const ProductEvent.init()),
      expect: () => [
        isA<ProductState>()
            .having((s) => s.currentStep, 'currentStep',
                ProductTourStep.welcomePopup)
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.errorMessage, 'errorMessage', null),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'emits [currentStep: nextStep, isLoading: false, errorMessage: null] when OnNextStep is added',
      build: () {
        when(mockProductTourController.nextStep())
            .thenAnswer((_) async => null);
        when(mockProductTourController.currentStep)
            .thenAnswer((_) async => ProductTourStep.showCollection);
        return productBloc;
      },
      act: (bloc) => bloc.add(const ProductEvent.nextStep()),
      expect: () => [
        isA<ProductState>()
            .having((s) => s.currentStep, 'currentStep',
                ProductTourStep.showCollection)
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.errorMessage, 'errorMessage', null),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'emits [currentStep: previousStep, isLoading: false, errorMessage: null] when OnPreviousStep is added',
      build: () {
        when(mockProductTourController.previousStep())
            .thenAnswer((_) async => null);
        when(mockProductTourController.currentStep)
            .thenAnswer((_) async => ProductTourStep.welcomePopup);
        return productBloc;
      },
      act: (bloc) => bloc.add(const ProductEvent.previousStep()),
      expect: () => [
        isA<ProductState>()
            .having((s) => s.currentStep, 'currentStep',
                ProductTourStep.welcomePopup)
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.errorMessage, 'errorMessage', null),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'emits [currentStep: noneCompleted, isLoading: false, errorMessage: null] when OnSkipTour is added',
      build: () {
        when(mockProductTourController.completeTour())
            .thenAnswer((_) async => null);
        return productBloc;
      },
      act: (bloc) => bloc.add(const ProductEvent.skipTour()),
      expect: () => [
        isA<ProductState>()
            .having((s) => s.currentStep, 'currentStep',
                ProductTourStep.noneCompleted)
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.errorMessage, 'errorMessage', null),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'emits [isLoading: true, currentStep: reset, isLoading: false, errorMessage: null] when OnResetTour is added',
      build: () {
        when(mockProductTourController.resetTour())
            .thenAnswer((_) async => null);
        return productBloc;
      },
      act: (bloc) => bloc.add(const ProductEvent.resetTour()),
      expect: () => [
        isA<ProductState>().having((s) => s.isLoading, 'isLoading', true),
        isA<ProductState>()
            .having((s) => s.currentStep, 'currentStep', ProductTourStep.reset)
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.errorMessage, 'errorMessage', null),
      ],
    );
  });

  group('ProductBloc Data Events', () {
    final mockTabs = [
      TabsDTO(
        id: 1,
        title: 'Movies',
        subtitle: 'My favorite movies',
        timestamp: DateTime.now(),
        entries: [],
      ),
      TabsDTO(
        id: 2,
        title: 'Books',
        subtitle: 'Must-read books',
        timestamp: DateTime.now(),
        entries: [],
      ),
    ];

    blocTest<ProductBloc, ProductState>(
      'emits [tabs: tabs, isLoading: false] when OnLoadData is added',
      build: () {
        when(mockTutorialRepository.loadTutorialData())
            .thenAnswer((_) async => mockTabs);
        return productBloc;
      },
      act: (bloc) => bloc.add(const ProductEvent.onLoadData()),
      expect: () => [
        isA<ProductState>()
            .having((s) => s.tabs, 'tabs', mockTabs)
            .having((s) => s.isLoading, 'isLoading', false),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'emits [tabs: null, isLoading: true] when OnClearData is added',
      build: () => productBloc,
      act: (bloc) => bloc.add(const ProductEvent.onClearData()),
      expect: () => [
        isA<ProductState>()
            .having((s) => s.tabs, 'tabs', null)
            .having((s) => s.isLoading, 'isLoading', true),
      ],
    );
  });
}
