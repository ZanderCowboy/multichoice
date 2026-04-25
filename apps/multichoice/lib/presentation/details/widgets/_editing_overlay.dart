part of '../details_page.dart';

class _EditingOverlay extends StatelessWidget {
  const _EditingOverlay();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsBloc, DetailsState>(
      builder: (context, state) {
        final isTab =
            state.parent == null &&
            state.children != null &&
            state.tabId != null;

        return Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: allPadding4,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor.withValues(
                  alpha: 0.4,
                ),
                borderRadius: borderCircular16,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 0.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      context.read<DetailsBloc>().add(
                        const DetailsEvent.onToggleEditMode(),
                      );
                    },
                    icon: const Icon(
                      Icons.undo_outlined,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                  gap12,
                  IconButton(
                    onPressed: () {
                      final title = state.title;
                      final message = isTab
                          ? 'Are you sure you want to delete $title and all its entries?'
                          : 'Are you sure you want to delete $title?';

                      deleteModal(
                        context: context,
                        title: title,
                        content: Text(message),
                        onConfirm: () {
                          context.read<DetailsBloc>().add(
                            const DetailsEvent.onDelete(),
                          );
                          Navigator.of(context).pop();
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                  gap12,
                  IconButton(
                    onPressed: () {
                      context.read<DetailsBloc>().add(
                        const DetailsEvent.onSubmit(),
                      );
                    },
                    icon: const Icon(
                      Icons.check,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
