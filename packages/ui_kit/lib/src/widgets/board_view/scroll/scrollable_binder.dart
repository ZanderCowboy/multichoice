import 'package:flutter/widgets.dart';

/// Binds to the ancestor [Scrollable] once mounted (must be a descendant).
class ScrollableBinder extends StatefulWidget {
  const ScrollableBinder({
    required this.onReady,
    this.onDispose,
    super.key,
  });

  final void Function(ScrollableState scrollable) onReady;
  final VoidCallback? onDispose;

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
  void dispose() {
    widget.onDispose?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
