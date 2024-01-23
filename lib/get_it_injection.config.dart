// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'application/entry/entry_bloc.dart' as _i7;
import 'application/home/home_bloc.dart' as _i8;
import 'domain/entry/i_entry_repository.dart' as _i3;
import 'domain/tabs/i_tabs_repository.dart' as _i5;
import 'infrastructure/entries/entry_repository.dart' as _i4;
import 'infrastructure/tabs/tabs_repository.dart' as _i6;

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
    gh.lazySingleton<_i3.IEntryRepository>(() => _i4.EntryRepository());
    gh.lazySingleton<_i5.ITabsRepository>(() => _i6.TabsRepository());
    gh.factory<_i7.EntryBloc>(() => _i7.EntryBloc(gh<_i3.IEntryRepository>()));
    gh.factory<_i8.HomeBloc>(() => _i8.HomeBloc(gh<_i5.ITabsRepository>()));
    return this;
  }
}
