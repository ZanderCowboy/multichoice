// Bloc test template
// Path: packages/core/test/src/application/<feature>/<feature>_bloc_test.dart

import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks.mocks.dart';

void main() {
  late <Feature>Bloc bloc;
  late MockDependency mockDependency;

  setUp(() {
    mockDependency = MockDependency();
    bloc = <Feature>Bloc(mockDependency);
  });

  tearDown(() {
    bloc.close();
  });

  group('<Feature>Bloc', () {
    test('initial state is correct', () {
      expect(bloc.state, <Feature>State.initial());
    });

    blocTest<<Feature>Bloc, <Feature>State>(
      '<Feature>Started updates state',
      build: () {
        when(mockDependency.fetch()).thenAnswer((_) async => 'value');
        return bloc;
      },
      act: (b) => b.add(const <Feature>Started()),
      expect: () => [
        isA<<Feature>State>().having((s) => s.isLoading, 'isLoading', true),
        isA<<Feature>State>().having((s) => s.isLoading, 'isLoading', false),
      ],
    );
  });
}
