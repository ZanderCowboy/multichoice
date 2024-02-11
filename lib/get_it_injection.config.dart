// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:isar/isar.dart' as _i5;

import 'application/entry/entry_bloc.dart' as _i8;
import 'application/home/home_bloc.dart' as _i9;
import 'domain/entry/i_entry_repository.dart' as _i3;
import 'domain/tabs/i_tabs_repository.dart' as _i6;
import 'infrastructure/entries/entry_repository.dart' as _i4;
import 'infrastructure/tabs/tabs_repository.dart' as _i7;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.lazySingleton<_i3.IEntryRepository>(
        () => _i4.EntryRepository(gh<_i5.Isar>()));
    gh.lazySingleton<_i6.ITabsRepository>(
        () => _i7.TabsRepository(gh<_i5.Isar>()));
    gh.factory<_i8.EntryBloc>(() => _i8.EntryBloc(gh<_i3.IEntryRepository>()));
    gh.factory<_i9.HomeBloc>(() => _i9.HomeBloc(gh<_i6.ITabsRepository>()));
    return this;
  }
}
