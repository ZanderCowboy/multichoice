// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element, unnecessary_cast

part of 'app_text_extension.dart';

// **************************************************************************
// TailorAnnotationsGenerator
// **************************************************************************

mixin _$AppTextExtensionTailorMixin on ThemeExtension<AppTextExtension> {
  TextStyle get h1;
  TextStyle get body1;

  @override
  AppTextExtension copyWith({
    TextStyle? h1,
    TextStyle? body1,
  }) {
    return AppTextExtension(
      h1: h1 ?? this.h1,
      body1: body1 ?? this.body1,
    );
  }

  @override
  AppTextExtension lerp(
      covariant ThemeExtension<AppTextExtension>? other, double t) {
    if (other is! AppTextExtension) return this as AppTextExtension;
    return AppTextExtension(
      h1: TextStyle.lerp(h1, other.h1, t)!,
      body1: TextStyle.lerp(body1, other.body1, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AppTextExtension &&
            const DeepCollectionEquality().equals(h1, other.h1) &&
            const DeepCollectionEquality().equals(body1, other.body1));
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType.hashCode,
      const DeepCollectionEquality().hash(h1),
      const DeepCollectionEquality().hash(body1),
    );
  }
}

extension AppTextExtensionBuildContextProps on BuildContext {
  AppTextExtension get appTextExtension =>
      Theme.of(this).extension<AppTextExtension>()!;
  TextStyle get h1 => appTextExtension.h1;
  TextStyle get body1 => appTextExtension.body1;
}
