part of '../home_page.dart';

class EmptyTab extends HookWidget {
  const EmptyTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final titleTextController = TextEditingController();
    final subtitleTextController = TextEditingController();

    return GestureDetector(
      onTap: () {
        CustomDialog<Widget>.show(
          context: context,
          title: const Text('Add new tab'),
          content: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(
                      width: 80,
                      child: Text('Title'),
                    ),
                    gap4,
                    Expanded(
                      child: TextFormField(
                        controller: titleTextController,
                        onChanged: (value) {
                          context
                              .read<HomeBloc>()
                              .add(HomeEvent.onChangedTabTitle(value));
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(
                      width: 80,
                      child: Text('Subtitle'),
                    ),
                    gap4,
                    Expanded(
                      child: TextFormField(
                        controller: subtitleTextController,
                        onChanged: (value) {
                          context
                              .read<HomeBloc>()
                              .add(HomeEvent.onChangedTabSubtitle(value));
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            OutlinedButton(
              onPressed: () {
                context.read<HomeBloc>().add(const HomeEvent.onPressedCancel());
                titleTextController.clear();
                subtitleTextController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<HomeBloc>().add(const HomeEvent.onPressedAddTab());

                if (Navigator.canPop(context)) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
      child: AddTabCard(
        width: MediaQuery.sizeOf(context).width / 4,
      ),
    );
  }
}
