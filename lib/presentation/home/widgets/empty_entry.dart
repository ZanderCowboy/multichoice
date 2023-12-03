part of '../home_page.dart';

class EmptyEntry extends StatelessWidget {
  const EmptyEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        CustomDialog.show(
          context: context,
          title: const Text('title'),
          actions: [
            ElevatedButton(
              onPressed: () {
                context
                    .read<EntryBloc>()
                    .add(const onPressedAddEntry(EntryCard()));
                Navigator.of(context).pop();
              },
              child: const Text('press'),
            ),
          ],
        );
      },
      child: Card(
        elevation: 5,
        color: Colors.grey[600],
        shape: RoundedRectangleBorder(
          borderRadius: circularBorder5,
        ),
        child: const Padding(
          padding: allPadding6,
          child: IconButton(
            iconSize: 36,
            onPressed: null,
            icon: Icon(
              Icons.add_outlined,
            ),
          ),
        ),
      ),
    );
  }
}
