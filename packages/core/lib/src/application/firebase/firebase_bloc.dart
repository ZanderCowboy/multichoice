import 'package:bloc/bloc.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'firebase_bloc.freezed.dart';
part 'firebase_event.dart';
part 'firebase_state.dart';

enum AppBarTitle {
  backup_appbar_title,
  main_app_title,
}

@Injectable()
class FirebaseBloc extends Bloc<FirebaseEvent, FirebaseState> {
  FirebaseBloc() : super(FirebaseState.initial()) {
    on<FirebaseEvent>((event, emit) {
      event.map(
        onChangeColor: (e) {
          final FirebaseRemoteConfig? remoteConfig =
              FirebaseRemoteConfig.instance;

          String titleKey;
          switch (e.color) {
            case AppBarTitle.backup_appbar_title:
              titleKey = 'backup_appbar_title';
              break;
            case AppBarTitle.main_app_title:
              titleKey = 'main_app_title';
              break;
          }

          final titleName = remoteConfig?.getString(titleKey);
          final title = availableBackgroundColors[titleName] ?? 'Default';

          emit(
            state.copyWith(
              color: title,
            ),
          );
        },
      );
    });
  }

  final Map<String, String> availableBackgroundColors = {
    "main": 'Multichoice',
    "backup": 'Keep It Together',
  };
}
