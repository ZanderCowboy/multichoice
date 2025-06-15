part of '../details_page.dart';

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({
    required this.onBack,
  });

  final VoidCallback onBack;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsBloc, DetailsState>(
      builder: (context, state) {
        return AppBar(
          title: const Text('Details'),
          leading: IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back),
          ),
          actions: [
            if (state.isEditingMode)
              IconButton(
                onPressed: () {
                  context.read<DetailsBloc>().add(
                        const DetailsEvent.onSubmit(),
                      );
                },
                icon: const Icon(
                  Icons.check,
                ),
              )
            else
              IconButton(
                onPressed: () {
                  context.read<DetailsBloc>().add(
                        const DetailsEvent.onToggleEditMode(),
                      );
                },
                icon: const Icon(
                  Icons.edit,
                ),
              ),
            IconButton(
              onPressed: () {
                // TODO: Confirm that popping to root does not change anything
                context.router.popUntilRoot();
              },
              icon: const Icon(
                Icons.home,
              ),
            ),
          ],
        );
      },
    );
  }
}
