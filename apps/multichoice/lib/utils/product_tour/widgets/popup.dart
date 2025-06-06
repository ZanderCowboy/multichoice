part of '../product_tour.dart';

class _Popup extends StatelessWidget {
  const _Popup({
    required this.title,
    required this.content,
    required this.buttonText,
    required this.context,
    this.showSkipButton = true,
    bool? isCompleted,
  }) : _isCompleted = isCompleted ?? false;

  final String title;
  final String content;
  final String buttonText;
  final bool? showSkipButton;
  final bool _isCompleted;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        if (_isCompleted) ...[
          TextButton(
            onPressed: () {
              context.read<HomeBloc>().add(
                    const HomeEvent.onPressedDeleteAll(),
                  );
            },
            child: const Text('Clear Data'),
          ),
          TextButton(
            onPressed: () {
              coreSl<ProductBloc>().add(const ProductEvent.resetTour());
              Navigator.of(context).pop();
            },
            child: const Text('Restart Tour'),
          ),
        ],
        if (showSkipButton ?? true)
          TextButton(
            onPressed: () {
              coreSl<ProductBloc>().add(const ProductEvent.skipTour());
              Navigator.of(context).pop();
            },
            child: const Text('Skip Tour'),
          ),
        TextButton(
          onPressed: () {
            coreSl<ProductBloc>().add(
              _isCompleted
                  ? const ProductEvent.skipTour()
                  : const ProductEvent.nextStep(),
            );
            Navigator.of(context).pop();
          },
          child: Text(buttonText),
        ),
      ],
    );
  }
}
