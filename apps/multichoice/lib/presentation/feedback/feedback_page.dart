import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:multichoice/app/engine/static_keys.dart';
import 'package:multichoice/presentation/feedback/widgets/feedback_form.dart';

@RoutePage()
class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => coreSl<FeedbackBloc>(),
      child: BlocListener<FeedbackBloc, FeedbackState>(
        listener: (context, state) {
          if (state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Thank you for your feedback!'),
                action: SnackBarAction(
                  label: 'Go Home',
                  onPressed: () {
                    context.router.popUntilRoot();
                    scaffoldKey.currentState?.closeDrawer();
                  },
                ),
              ),
            );
          } else if (state.isError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text('Error submitting feedback: ${state.errorMessage}'),
              ),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: BlocBuilder<FeedbackBloc, FeedbackState>(
              builder: (context, _) {
                return kDebugMode
                    ? GestureDetector(
                        onDoubleTap: () {
                          context.read<FeedbackBloc>().add(
                                FeedbackEvent.submit(
                                  FeedbackDTO(
                                    id: 'test',
                                    message: 'Test feedback',
                                    userEmail: 'test@test.com',
                                    rating: 5,
                                    deviceInfo: 'Test device',
                                    appVersion: '1.0.0',
                                    timestamp: DateTime.now(),
                                    category: 'Test',
                                  ),
                                ),
                              );
                        },
                        child: const Text('Send Feedback'),
                      )
                    : const Text('Send Feedback');
              },
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_outlined),
              onPressed: () => context.router.pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  context.router.popUntilRoot();
                  scaffoldKey.currentState?.closeDrawer();
                },
              ),
            ],
          ),
          body: const SingleChildScrollView(
            child: FeedbackForm(),
          ),
        ),
      ),
    );
  }
}
