part of '../product_tour.dart';

class _MyPopup extends StatelessWidget {
  const _MyPopup({
    required this.title,
    required this.content,
    required this.buttonText,
  });
  final String title;
  final String content;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            productTourController.nextStep();
            Navigator.of(context).pop();
          },
          child: Text(buttonText),
        ),
      ],
    );
  }
}
