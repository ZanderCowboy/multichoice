part of '../home_page.dart';

class NewTab extends StatelessWidget {
  const NewTab({super.key});

  @override
  Widget build(BuildContext context) {
    return AddTabCard(
      key: context.keys.addNewTabButton,
      width: UIConstants.newTabWidth(context),
      onPressed: () {
        CustomDialog<AlertDialog>.show(
          context: context,
          title: Text(context.t.home.addNewTab),
          content: BlocProvider.value(
            value: context.read<HomeBloc>(),
            child: const _AddTabDialogContent(),
          ),
        );
      },
    );
  }
}

class _AddTabDialogContent extends StatefulWidget {
  const _AddTabDialogContent();

  @override
  State<_AddTabDialogContent> createState() => _AddTabDialogContentState();
}

class _AddTabDialogContentState extends State<_AddTabDialogContent> {
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
            HomeEvent.onChangedTabTitle(value),
          ),
          onSubtitleChanged: (value) => context.read<HomeBloc>().add(
            HomeEvent.onChangedTabSubtitle(value),
          ),
          onCancel: () async {
            context.read<HomeBloc>().add(
              const HomeEvent.onPressedCancel(),
            );
            await _closeDialog();
          },
          onAdd: () async {
            context.read<HomeBloc>().add(
              const HomeEvent.onPressedAddTab(),
            );
            await _closeDialog();
          },
          isValid: state.isValid,
        );
      },
    );
  }
}
