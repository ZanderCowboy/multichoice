part of '../home_page.dart';

class NewTab extends HookWidget {
  const NewTab({super.key});

  @override
  Widget build(BuildContext context) {
    final titleTextController = useTextEditingController();
    final subtitleTextController = useTextEditingController();

    Future<void> onPressed() async {
      Navigator.of(context).pop();
      await Future.microtask(() {
        titleTextController.clear();
        subtitleTextController.clear();
      });
    }

    return AddTabCard(
      key: context.keys.addNewTabButton,
      width: UIConstants.newTabWidth(context),
      onPressed: () {
        CustomDialog<AlertDialog>.show(
          context: context,
          title: const Text('Add New Tab'),
          content: BlocProvider.value(
            value: context.read<HomeBloc>(),
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                return ReusableForm(
                  titleController: titleTextController,
                  subtitleController: subtitleTextController,
                  onTitleChanged: (value) => context.read<HomeBloc>().add(
                    HomeEvent.onChangedTabTitle(value),
                  ),
                  onSubtitleChanged: (value) => context.read<HomeBloc>().add(
                    HomeEvent.onChangedTabSubtitle(value),
                  ),
                  onCancel: () async {
                    context.read<HomeBloc>().add(
                      const HomeEvent.onPressedCancel(),
                    );
                    await onPressed();
                  },
                  onAdd: () async {
                    context.read<HomeBloc>().add(
                      const HomeEvent.onPressedAddTab(),
                    );
                    await onPressed();
                  },
                  isValid: state.isValid,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
