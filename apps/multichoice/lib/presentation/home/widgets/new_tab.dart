part of '../home_page.dart';

class NewTab extends StatefulWidget {
  const NewTab({super.key});

  @override
  State<NewTab> createState() => _NewTabState();
}

class _NewTabState extends State<NewTab> {
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
