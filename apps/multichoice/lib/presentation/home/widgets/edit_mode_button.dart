import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:multichoice/presentation/home/utils/trigger_edit_mode_haptic.dart';

class EditModeButton extends StatelessWidget {
  const EditModeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return IconButton(
          visualDensity: VisualDensity.compact,
          onPressed: () async {
            if (!state.isEditMode) {
              await triggerEditModeHaptic();
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

            if (!context.mounted) return;

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
