part of '../product_tour.dart';

class _Popup extends StatelessWidget {
  const _Popup({
    required this.title,
    required this.content,
    required this.buttonText,
    this.showSkipButton = true,
    bool? isCompleted,
  }) : _isCompleted = isCompleted ?? false;

  final String title;
  final String content;
  final String buttonText;
  final bool? showSkipButton;
  final bool _isCompleted;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
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
