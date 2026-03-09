part of '../home_page.dart';

class EditModeButton extends StatelessWidget {
  const EditModeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return IconButton(
          onPressed: () async {
            if (!state.isEditMode) {
              await _triggerEditModeHaptic();
              await coreSl<IAnalyticsService>().logEvent(
                const UiActionEventData(
                  page: AnalyticsPage.home,
                  button: AnalyticsButton.editOrder,
                  action: AnalyticsAction.open,
                ),
              );
            } else {
              await coreSl<IAnalyticsService>().logEvent(
                const UiActionEventData(
                  page: AnalyticsPage.home,
                  button: AnalyticsButton.editOrder,
                  action: AnalyticsAction.close,
                ),
              );
            }
            // ignore: use_build_context_synchronously
            context.read<HomeBloc>().add(
              const HomeEvent.onToggleEditMode(),
            );
          },
          tooltip: state.isEditMode ? 'Finish editing' : 'Edit order',
          icon: Icon(
            state.isEditMode ? Icons.check : Icons.edit_outlined,
          ),
        );
      },
    );
  }
}
