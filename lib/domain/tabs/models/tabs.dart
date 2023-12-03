import 'package:freezed_annotation/freezed_annotation.dart';

part 'tabs.freezed.dart';

@freezed
class Tabs with _$Tabs {
  const factory Tabs({
    required String title,
    required String subtitle,
  }) = _Tabs;

  factory Tabs.empty() => const Tabs(
        title: '',
        subtitle: '',
      );
}
