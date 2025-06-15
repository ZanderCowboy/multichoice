part of '../home_page.dart';

class NewEntry extends HookWidget {
  const NewEntry({
    required this.tabId,
    super.key,
  });

  final int tabId;

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

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final homeBloc = context.read<HomeBloc>();
        return AddEntryCard(
          key: context.keys.addNewEntryButton,
          padding: zeroPadding,
          onPressed: () {
            CustomDialog<AlertDialog>.show(
              context: context,
              title: RichText(
                key: context.keys.addNewEntryTitle,
                text: TextSpan(
                  text: 'Add New Entry',
                  style: DefaultTextStyle.of(context).style.copyWith(
                        fontSize: 24,
                      ),
                ),
              ),
              content: BlocProvider.value(
                value: homeBloc,
                child: BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    return ReusableForm(
                      titleController: titleTextController,
                      subtitleController: subtitleTextController,
                      onTitleChanged: (value) => context
                          .read<HomeBloc>()
                          .add(HomeEvent.onChangedEntryTitle(value)),
                      onTitleTap: () => context
                          .read<HomeBloc>()
                          .add(HomeEvent.onGetTab(tabId)),
                      onSubtitleChanged: (value) => context
                          .read<HomeBloc>()
                          .add(HomeEvent.onChangedEntrySubtitle(value)),
                      onCancel: () {
                        context.read<HomeBloc>().add(
                              const HomeEvent.onPressedCancel(),
                            );
                        onPressed();
                      },
                      onAdd: () {
                        context.read<HomeBloc>().add(
                              const HomeEvent.onPressedAddEntry(),
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
      },
    );
  }
}
