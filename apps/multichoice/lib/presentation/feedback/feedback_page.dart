import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:multichoice/app/engine/static_keys.dart';
import 'package:multichoice/app/view/analytics/analytics_page_tracker.dart';
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
          final messenger = ScaffoldMessenger.of(context);
          if (state.isLoading) {
            messenger.clearSnackBars();
            return;
          }
          if (state.isSuccess) {
            messenger
              ..clearSnackBars()
              ..showSnackBar(
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
            messenger.clearSnackBars();
            final message = state.errorMessage?.trim();
            if (message == null || message.isEmpty) return;
            messenger.showSnackBar(
              SnackBar(content: Text(message)),
            );
          }
        },
        child: AnalyticsPageTracker(
          page: AnalyticsPage.feedback,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Send Feedback'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_outlined),
                onPressed: () async {
                  await coreSl<IAnalyticsService>().logEvent(
                    const UiActionEventData(
                      page: AnalyticsPage.feedback,
                      button: AnalyticsButton.back,
                      action: AnalyticsAction.tap,
                    ),
                  );
                  if (!context.mounted) return;
                  context.router.pop();
                },
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.home),
                  onPressed: () async {
                    await coreSl<IAnalyticsService>().logEvent(
                      const UiActionEventData(
                        page: AnalyticsPage.feedback,
                        button: AnalyticsButton.home,
                        action: AnalyticsAction.tap,
                      ),
                    );
                    if (!context.mounted) return;
                    context.router.popUntilRoot();
                    scaffoldKey.currentState?.closeDrawer();
                  },
                ),
              ],
            ),
            body: const SafeArea(
              child: SingleChildScrollView(
                child: FeedbackForm(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
