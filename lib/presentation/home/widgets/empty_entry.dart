part of '../home_page.dart';

class EmptyEntry extends HookWidget {
  const EmptyEntry({
    required this.tabId,
    super.key,
  });

  final int tabId;

  @override
  Widget build(BuildContext context) {
    final titleTextController = TextEditingController();
    final subtitleTextController = TextEditingController();

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            CustomDialog<Widget>.show(
              context: context,
              title: Text('Add new entry to ${state.tab.title}'),
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
                        SizedBox(
                          width: 200,
                          child: TextFormField(
                            controller: titleTextController,
                            onChanged: (value) {
                              context
                                  .read<HomeBloc>()
                                  .add(HomeEvent.onChangedEntryTitle(value));
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
                        SizedBox(
                          width: 200,
                          child: TextFormField(
                            controller: subtitleTextController,
                            onChanged: (value) {
                              context
                                  .read<HomeBloc>()
                                  .add(HomeEvent.onChangedEntrySubtitle(value));
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
                    context
                        .read<HomeBloc>()
                        .add(const HomeEvent.onPressedCancel());
                    titleTextController.clear();
                    subtitleTextController.clear();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<HomeBloc>().add(
                          HomeEvent.onPressedAddEntry(tabId),
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
