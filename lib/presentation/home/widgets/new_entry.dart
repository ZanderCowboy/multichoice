part of '../home_page.dart';

class _NewEntry extends StatelessWidget {
  const _NewEntry({
    required this.id,
    required this.entryCount,
  });

  final int id;
  final int entryCount;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return AddEntryCard(
          onPressed: () {
            CustomDialog<AlertDialog>.show(
              context: context,
              title: const Text('Add New Entry'),
              content: const Text(
                'TODO: Add FormFields to add data',
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
                            id,
                            'entry title ${entryCount + 1}',
                            'subtitle',
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
