part of '../home_page.dart';

class NewTab extends HookWidget {
  const NewTab({super.key});

  @override
  Widget build(BuildContext context) {
    final titleTextController = useTextEditingController();
    final subtitleTextController = useTextEditingController();

    void onPressed() {
      Navigator.of(context).pop();
      Future.microtask(() {
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
                  onTitleChanged: (value) => context
                      .read<HomeBloc>()
                      .add(HomeEvent.onChangedTabTitle(value)),
                  onSubtitleChanged: (value) => context
                      .read<HomeBloc>()
                      .add(HomeEvent.onChangedTabSubtitle(value)),
                  onCancel: () {
                    context.read<HomeBloc>().add(
                          const HomeEvent.onPressedCancel(),
                        );
                    onPressed();
                  },
                  onAdd: () {
                    context.read<HomeBloc>().add(
                          const HomeEvent.onPressedAddTab(),
                        );
                    onPressed();
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
