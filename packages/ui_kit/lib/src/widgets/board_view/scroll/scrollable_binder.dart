import 'package:flutter/widgets.dart';

/// Binds to the ancestor [Scrollable] once mounted (must be a descendant).
class ScrollableBinder extends StatefulWidget {
  const ScrollableBinder({required this.onReady, super.key});

  final void Function(ScrollableState scrollable) onReady;

  @override
  State<ScrollableBinder> createState() => _ScrollableBinderState();
}

class _ScrollableBinderState extends State<ScrollableBinder> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final scrollable = Scrollable.maybeOf(context);
      if (scrollable != null) widget.onReady(scrollable);
    });
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
