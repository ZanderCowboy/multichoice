// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element, unnecessary_cast

part of 'app_colors_extension.dart';

// **************************************************************************
// TailorAnnotationsGenerator
// **************************************************************************

mixin _$AppColorsExtensionTailorMixin on ThemeExtension<AppColorsExtension> {
  Color get background;
  Color get primary;
  Color get secondary;

  @override
  AppColorsExtension copyWith({
    Color? background,
    Color? primary,
    Color? secondary,
  }) {
    return AppColorsExtension(
      background: background ?? this.background,
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
    );
  }

  @override
  AppColorsExtension lerp(
      covariant ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) return this as AppColorsExtension;
    return AppColorsExtension(
      background: Color.lerp(background, other.background, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AppColorsExtension &&
            const DeepCollectionEquality()
                .equals(background, other.background) &&
            const DeepCollectionEquality().equals(primary, other.primary) &&
            const DeepCollectionEquality().equals(secondary, other.secondary));
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType.hashCode,
      const DeepCollectionEquality().hash(background),
      const DeepCollectionEquality().hash(primary),
      const DeepCollectionEquality().hash(secondary),
    );
  }
}

extension AppColorsExtensionBuildContextProps on BuildContext {
  AppColorsExtension get appColorsExtension =>
      Theme.of(this).extension<AppColorsExtension>()!;
  Color get background => appColorsExtension.background;
  Color get primary => appColorsExtension.primary;
  Color get secondary => appColorsExtension.secondary;
}
