import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:multichoice/utils/app_tips/app_tip_content.dart';
import 'package:multichoice/utils/app_tips/app_tip_coordinator.dart'
    show AppTipCoordinator;
import 'package:multichoice/utils/app_tips/app_tip_keys.dart';
import 'package:showcaseview/showcaseview.dart';

/// Anchors a contextual, dismissible showcase tooltip to [child].
///
/// The [Showcase] stays in the tree so tip changes do not rebuild/dispose
/// descendants (e.g. add-tab dialogs with active [TextEditingController]s).
/// Visibility is driven by [AppTipCoordinator] via [ShowcaseView.startShowCase].
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
      disposeOnTap: false,
      overlayOpacity: isLightMode ? 0.65 : 0.35,
      onTargetClick: () => _dismissTip(context, tip),
      onToolTipClick: () => _dismissTip(context, tip),
      child: child,
    );
  }

  static void _dismissTip(BuildContext context, AppTip tip) {
    final productBloc = context.read<ProductBloc>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowcaseView.get().dismiss();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        productBloc.add(ProductEvent.dismissTip(tip));
      });
    });
  }
}
