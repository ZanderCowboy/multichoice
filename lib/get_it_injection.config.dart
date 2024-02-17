// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:isar/isar.dart' as _i3;

import 'application/home/home_bloc.dart' as _i8;
import 'injectable_module.dart' as _i9;
import 'repositories/implementation/entry_repository.dart' as _i5;
import 'repositories/implementation/tabs_repository.dart' as _i7;
import 'repositories/interfaces/i_entry_repository.dart' as _i4;
import 'repositories/interfaces/i_tabs_repository.dart' as _i6;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final injectableModule = _$InjectableModule();
    await gh.factoryAsync<_i3.Isar>(
      () => injectableModule.isar,
      preResolve: true,
    );
    gh.lazySingleton<_i4.IEntryRepository>(
        () => _i5.EntryRepository(gh<_i3.Isar>()));
    gh.lazySingleton<_i6.ITabsRepository>(
        () => _i7.TabsRepository(gh<_i3.Isar>()));
    gh.factory<_i8.HomeBloc>(() => _i8.HomeBloc(
          gh<_i6.ITabsRepository>(),
          gh<_i4.IEntryRepository>(),
        ));
    return this;
  }
}

class _$InjectableModule extends _i9.InjectableModule {}
