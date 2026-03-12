part of '../home_page.dart';

class NewEntry extends StatefulWidget {
  const NewEntry({
    required this.tabId,
    super.key,
  });

  final int tabId;

  @override
  State<NewEntry> createState() => _NewEntryState();
}

class _NewEntryState extends State<NewEntry> {
  late final TextEditingController _titleTextController;
  late final TextEditingController _subtitleTextController;

  @override
  void initState() {
    super.initState();
    _titleTextController = TextEditingController();
    _subtitleTextController = TextEditingController();
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    _subtitleTextController.dispose();
    super.dispose();
  }

  Future<void> onPressed() async {
    Navigator.of(context).pop();
    await Future.microtask(() {
      _titleTextController.clear();
      _subtitleTextController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      titleController: _titleTextController,
                      subtitleController: _subtitleTextController,
                      onTitleChanged: (value) => context.read<HomeBloc>().add(
                        HomeEvent.onChangedEntryTitle(value),
                      ),
                      onTitleTap: () => context.read<HomeBloc>().add(
                        HomeEvent.onGetTab(widget.tabId),
                      ),
                      onSubtitleChanged: (value) => context
                          .read<HomeBloc>()
                          .add(HomeEvent.onChangedEntrySubtitle(value)),
                      onCancel: () async {
                        context.read<HomeBloc>().add(
                          const HomeEvent.onPressedCancel(),
                        );
                        await onPressed();
                      },
                      onAdd: () async {
                        context.read<HomeBloc>().add(
                          const HomeEvent.onPressedAddEntry(),
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
      },
    );
  }
}
