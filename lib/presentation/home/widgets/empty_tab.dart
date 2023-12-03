part of '../home_page.dart';

class EmptyTab extends StatelessWidget {
  const EmptyTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return GestureDetector(
      onTap: () {
        CustomDialog.show(
          context: context,
          title: const Text('New Tab'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                context.read<HomeBloc>().add(
                      const HomeEvent.onPressedAddTab(
                        VerticalTab(
                          title: 'new',
                          subtitle: 'new',
                        ),
                      ),
                    );
                Navigator.of(context).pop();
              },
              child: const Text('ok'),
            ),
          ],
        );
      },
      child: Card(
        elevation: 5,
        color: Colors.grey[600],
        // shadowColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: circularBorder12,
        ),
        child: Padding(
          padding: allPadding6,
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width / 4,
            child: const IconButton(
              iconSize: 36,
              onPressed: null,
              icon: Icon(Icons.add_outlined),
            ),
          ),
        ),
      ),
    );
  }
}
