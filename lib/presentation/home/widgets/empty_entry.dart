part of '../home_page.dart';

class EmptyEntry extends StatelessWidget {
  const EmptyEntry({
    required this.tabId,
    super.key,
  });

  final int tabId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final entryCount = state.entryCards?.length;

        return GestureDetector(
          onTap: () {
            CustomDialog<Widget>.show(
              context: context,
              title: const Text('Add New Entry'),
              content: const SizedBox(
                height: 20,
                child: Text(
                  'TODO: Add FormFields to add data',
                ),
              ),
              actions: <Widget>[
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<HomeBloc>().add(
                          HomeEvent.onPressedAddEntry(
                            tabId,
                            'e-title $entryCount',
                            'e-s.title $entryCount',
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
          child: const AddEntryCard(),
        );
      },
    );
  }
}
