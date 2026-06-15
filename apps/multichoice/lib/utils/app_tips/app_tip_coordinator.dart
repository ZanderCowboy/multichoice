import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:multichoice/utils/app_tips/app_tip_keys.dart';
import 'package:showcaseview/showcaseview.dart';

/// Hosts [ShowCaseWidget] and starts contextual tips without rebuilding the home body.
class AppTipCoordinator extends StatefulWidget {
  const AppTipCoordinator({
    required this.child,
    this.onDrawerOpened,
    super.key,
  });

  final Widget child;
  final ValueChanged<bool>? onDrawerOpened;

  @override
  State<AppTipCoordinator> createState() => AppTipCoordinatorState();
}

class AppTipCoordinatorState extends State<AppTipCoordinator> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ProductBloc>().add(const ProductEvent.init());
    });
  }

  @override
  Widget build(BuildContext context) {
    // ShowCaseWidget is deprecated but still required until ShowcaseView.register()
    // migration is planned. See showcaseview v5.0.0 changelog.
    // ignore: deprecated_member_use
    return ShowCaseWidget(
      builder: (_) {
        return BlocListener<ProductBloc, ProductState>(
          listenWhen: (previous, current) =>
              previous.activeTip != current.activeTip,
          listener: (context, state) {
            _handleActiveTipChanged(state.activeTip);
          },
          child: widget.child,
        );
      },
    );
  }

  void handleDrawerChanged({required bool isOpened}) {
    widget.onDrawerOpened?.call(isOpened);

    if (!isOpened || !mounted) {
      return;
    }

    final activeTip = context.read<ProductBloc>().state.activeTip;
    if (activeTip != AppTip.drawer) {
      return;
    }

    ShowcaseView.get().dismiss();
    _startShowcase([appTipKeys.drawerAppearance]);
  }

  void _handleActiveTipChanged(AppTip? tip) {
    if (tip == null) {
      ShowcaseView.get().dismiss();
      return;
    }

    if (tip == AppTip.drawer) {
      _startShowcase([appTipKeys.drawerMenu]);
      return;
    }

    final key = appTipKeys.forTip(tip);
    if (key == null) {
      return;
    }

    _startShowcase([key]);
  }

  void _startShowcase(List<GlobalKey> keys) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ShowcaseView.get().startShowCase(keys);
    });
  }
}
