part of '../home_page.dart';

class EmptyEntry extends StatelessWidget {
  const EmptyEntry({
    required this.tabId,
    super.key,
  });

  final String tabId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EntryBloc, EntryState>(
      builder: (context, state) {
        final entryCount = state.entryCards?.length;

        return GestureDetector(
          onTap: () {
            CustomDialog.show(
              context: context,
              title: const Text('Add New Entry'),
              content: const SizedBox(height: 20),
              actions: <Widget>[
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<EntryBloc>().add(
                          EntryEvent.onPressedAddEntry(
                            tabId,
                            Entry(
                              id: 'e-ID: $entryCount',
                              tabId: tabId,
                              title: 'e-title $entryCount',
                              subtitle: 'e-s.title $entryCount',
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
          child: const AddEntryCard(),
        );
      },
    );
  }
}
