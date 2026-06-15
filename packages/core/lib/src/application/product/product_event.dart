part of 'product_bloc.dart';

sealed class ProductEvent {
  const ProductEvent();

  const factory ProductEvent.init() = OnInit;
  const factory ProductEvent.dismissTip(AppTip tip) = OnDismissTip;
  const factory ProductEvent.skipAllTips() = OnSkipAllTips;
  const factory ProductEvent.resetTips() = OnResetTips;
}

final class OnInit extends ProductEvent {
  const OnInit();
}

final class OnDismissTip extends ProductEvent {
  const OnDismissTip(this.tip);

  final AppTip tip;
}

final class OnSkipAllTips extends ProductEvent {
  const OnSkipAllTips();
}

final class OnResetTips extends ProductEvent {
  const OnResetTips();
}
