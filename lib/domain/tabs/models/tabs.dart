import 'package:freezed_annotation/freezed_annotation.dart';

part 'tabs.freezed.dart';

@freezed
class Tabs with _$Tabs {
  const factory Tabs({
    required String uuid,
    required String title,
    required String subtitle,
  }) = _Tabs;

  const Tabs._();

  factory Tabs.empty() => const Tabs(
        uuid: '',
        title: '',
        subtitle: '',
      );

  String get id => uuid;
}
