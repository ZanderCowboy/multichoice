part of '../details_page.dart';

class _EditingOverlay extends StatelessWidget {
  const _EditingOverlay();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16,
      left: 0,
      right: 0,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              onPressed: () {
                context.read<DetailsBloc>().add(
                      const DetailsEvent.onToggleEditMode(),
                    );
              },
              backgroundColor: Theme.of(context)
                  .scaffoldBackgroundColor
                  .withValues(alpha: 0.4),
              child: const Icon(
                Icons.undo_outlined,
                size: 32,
                color: Colors.white,
              ),
            ),
            gap12,
            FloatingActionButton(
              onPressed: () {
                context.read<DetailsBloc>().add(
                      const DetailsEvent.onSubmit(),
                    );
              },
              backgroundColor: Theme.of(context)
                  .scaffoldBackgroundColor
                  .withValues(alpha: 0.4),
              child: const Icon(
                Icons.check,
                size: 32,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
