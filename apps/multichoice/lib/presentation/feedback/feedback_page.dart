import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:multichoice/presentation/feedback/widgets/feedback_form.dart';

@RoutePage()
class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Feedback'),
      ),
      body: const SingleChildScrollView(
        child: FeedbackForm(),
      ),
    );
  }
}
