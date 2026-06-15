import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:multichoice/utils/app_tips/app_tip_content.dart';
import 'package:multichoice/utils/app_tips/app_tip_keys.dart';
import 'package:showcaseview/showcaseview.dart';

/// Anchors a contextual, dismissible showcase tooltip to [child] when [tip] is active.
class AppTipShowcase extends StatelessWidget {
  const AppTipShowcase({
    required this.tip,
    required this.child,
    this.showcaseKey,
    this.enabled = true,
    super.key,
  });

  final AppTip tip;
  final Widget child;
  final GlobalKey? showcaseKey;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (!enabled) {
      return child;
    }

    return BlocSelector<ProductBloc, ProductState, bool>(
      selector: (state) => state.activeTip == tip,
      builder: (context, isActive) {
        if (!isActive) {
          return child;
        }

        final key = showcaseKey ?? appTipKeys.forTip(tip);
        if (key == null) {
          return child;
        }

        final strings = appTipStrings(context, tip);
        final isLightMode = Theme.of(context).brightness == Brightness.light;

        return Showcase(
          key: key,
          title: strings.title,
          description: strings.body,
          disableBarrierInteraction: false,
          disposeOnTap: false,
          overlayOpacity: isLightMode ? 0.65 : 0.35,
          onTargetClick: () => _dismissTip(context, tip),
          onToolTipClick: () => _dismissTip(context, tip),
          child: child,
        );
      },
    );
  }

  static void _dismissTip(BuildContext context, AppTip tip) {
    ShowcaseView.get().dismiss();
    context.read<ProductBloc>().add(ProductEvent.dismissTip(tip));
  }
}
