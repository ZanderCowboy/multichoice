part of '../home_page.dart';

class EmptyTab extends StatelessWidget {
  const EmptyTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final tabCount = state.tabs.length;

        return GestureDetector(
          onTap: () {
            CustomDialog.show(
              context: context,
              title: const Text('Add New Tab'),
              content: const Text('text form'),
              actions: <Widget>[
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<HomeBloc>().add(
                          HomeEvent.onPressedAddTab(
                            Tabs(
                              id: 'tabId $tabCount',
                              title: 'tab title $tabCount',
                              subtitle: 'tab s.title $tabCount',
                            ),
                          ),
                        );
                    if (Navigator.canPop(context)) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Ok'),
                ),
              ],
            );
          },
          child: const AddTabCard(),
        );
      },
    );
  }
}
