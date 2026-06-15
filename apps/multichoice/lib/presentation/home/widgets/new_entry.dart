part of '../home_page.dart';

class NewEntry extends StatelessWidget {
  const NewEntry({
    required this.tabId,
    super.key,
  });

  final int tabId;

  @override
  Widget build(BuildContext context) {
    return AddEntryCard(
      key: context.keys.addNewEntryButton,
      padding: zeroPadding,
      onPressed: () {
        final homeBloc = context.read<HomeBloc>();
        CustomDialog<AlertDialog>.show(
          context: context,
          title: Text(
            key: context.keys.addNewEntryTitle,
            context.t.home.addNewEntry,
            style: DefaultTextStyle.of(context).style.copyWith(
              fontSize: 24,
            ),
          ),
          content: BlocProvider.value(
            value: homeBloc,
            child: _AddEntryDialogContent(tabId: tabId),
          ),
        );
      },
    );
  }
}

class _AddEntryDialogContent extends StatefulWidget {
  const _AddEntryDialogContent({
    required this.tabId,
  });

  final int tabId;

  @override
  State<_AddEntryDialogContent> createState() => _AddEntryDialogContentState();
}

class _AddEntryDialogContentState extends State<_AddEntryDialogContent> {
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

  Future<void> _closeDialog() async {
    Navigator.of(context).pop();
    await Future.microtask(() {
      if (mounted) {
        _titleTextController.clear();
        _subtitleTextController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
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
          onSubtitleChanged: (value) => context.read<HomeBloc>().add(
            HomeEvent.onChangedEntrySubtitle(value),
          ),
          onCancel: () async {
            context.read<HomeBloc>().add(
              const HomeEvent.onPressedCancel(),
            );
            await _closeDialog();
          },
          onAdd: () async {
            context.read<HomeBloc>().add(
              const HomeEvent.onPressedAddEntry(),
            );
            await _closeDialog();
          },
          isValid: state.isValid,
        );
      },
    );
  }
}
