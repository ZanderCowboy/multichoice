import 'package:core/src/application/home/home_bloc.dart';
import 'package:core/src/repositories/interfaces/entry/i_entry_repository.dart';
import 'package:core/src/repositories/interfaces/tabs/i_tabs_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockTabsRepository extends Mock implements ITabsRepository {}

class MockEntryRepository extends Mock implements IEntryRepository {}

void main() {
  group('HomeBloc', () {
    late HomeBloc homeBloc;
    late MockTabsRepository mockTabsRepository;
    late MockEntryRepository mockEntryRepository;

    setUp(() {
      mockTabsRepository = MockTabsRepository();
      mockEntryRepository = MockEntryRepository();
      homeBloc = HomeBloc(mockTabsRepository, mockEntryRepository);
    });

    tearDown(() {
      homeBloc.close();
    });

    test('initial state is HomeState.initial()', () {
      // expect(homeBloc.state, HomeState.initial());
    });

    // Add more tests here

    test('blank test', () {
      // Add your test implementation here
    });
  });
}
