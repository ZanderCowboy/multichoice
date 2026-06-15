import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multichoice/presentation/home/widgets/app_tips_banner.dart';

class AppTipsHandler extends StatefulWidget {
  const AppTipsHandler({
    required this.builder,
    super.key,
  });

  final WidgetBuilder builder;

  @override
  State<AppTipsHandler> createState() => _AppTipsHandlerState();
}

class _AppTipsHandlerState extends State<AppTipsHandler> {
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
    return BlocBuilder<ProductBloc, ProductState>(
      buildWhen: (previous, current) => previous.activeTip != current.activeTip,
      builder: (context, state) {
        final activeTip = state.activeTip;

        return Column(
          children: [
            if (activeTip != null)
              AppTipsBanner(
                tip: activeTip,
                onDismiss: () {
                  context.read<ProductBloc>().add(
                    ProductEvent.dismissTip(activeTip),
                  );
                },
              ),
            Expanded(child: widget.builder(context)),
          ],
        );
      },
    );
  }
}
