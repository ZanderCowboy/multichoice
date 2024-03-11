part of '../home_page.dart';

class _NewTab extends StatelessWidget {
  const _NewTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return AddTabCard(
          width: MediaQuery.sizeOf(context).width / 4,
          onPressed: () {
            CustomDialog<AlertDialog>.show(
              context: context,
              title: const Text('Add New Tab'),
              content: const Text('TODO: Add FormFields to enter data.'),
              actions: [
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<HomeBloc>().add(
                          HomeEvent.onPressedAddTab(
                            't-title ${state.tabs!.length + 1}',
                            't-s.title',
                          ),
                        );
                    Navigator.of(context).pop();
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
