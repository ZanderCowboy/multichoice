import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/src/services/implementations/noop_analytics_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:models/models.dart';

import '../../../mocks.mocks.dart';

void main() {
  late ProductBloc productBloc;
  late MockAppTipsController mockAppTipsController;

  setUp(() {
    mockAppTipsController = MockAppTipsController();
    productBloc = ProductBloc(
      mockAppTipsController,
      const NoopAnalyticsService(),
    );
  });

  tearDown(() {
    productBloc.close();
  });

  group('ProductBloc Tip Events', () {
    blocTest<ProductBloc, ProductState>(
      'emits active tip when OnInit is added',
      build: () {
        when(
          mockAppTipsController.activeTip,
        ).thenAnswer((_) async => AppTip.collections);
        return productBloc;
      },
      act: (bloc) => bloc.add(const ProductEvent.init()),
      expect: () => [
        isA<ProductState>()
            .having((s) => s.activeTip, 'activeTip', AppTip.collections)
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.errorMessage, 'errorMessage', null),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'emits next active tip when OnDismissTip is added',
      build: () {
        when(
          mockAppTipsController.dismissTip(AppTip.collections),
        ).thenAnswer((_) async => null);
        when(
          mockAppTipsController.activeTip,
        ).thenAnswer((_) async => AppTip.addCollection);
        return productBloc;
      },
      act: (bloc) => bloc.add(const ProductEvent.dismissTip(AppTip.collections)),
      expect: () => [
        isA<ProductState>()
            .having((s) => s.activeTip, 'activeTip', AppTip.addCollection)
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.errorMessage, 'errorMessage', null),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'clears active tip when OnSkipAllTips is added',
      build: () {
        when(
          mockAppTipsController.completeTips(),
        ).thenAnswer((_) async => null);
        return productBloc;
      },
      act: (bloc) => bloc.add(const ProductEvent.skipAllTips()),
      expect: () => [
        isA<ProductState>()
            .having((s) => s.activeTip, 'activeTip', isNull)
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.errorMessage, 'errorMessage', null),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'reloads tips when OnResetTips is added',
      build: () {
        when(mockAppTipsController.resetTips()).thenAnswer((_) async => null);
        when(
          mockAppTipsController.activeTip,
        ).thenAnswer((_) async => AppTip.collections);
        return productBloc;
      },
      act: (bloc) => bloc.add(const ProductEvent.resetTips()),
      expect: () => [
        isA<ProductState>().having((s) => s.isLoading, 'isLoading', true),
        isA<ProductState>()
            .having((s) => s.activeTip, 'activeTip', AppTip.collections)
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.errorMessage, 'errorMessage', null),
      ],
    );
  });
}
