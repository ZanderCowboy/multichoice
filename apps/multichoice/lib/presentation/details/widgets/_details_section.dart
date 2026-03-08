part of '../details_page.dart';

class _DetailsSection extends StatefulWidget {
  const _DetailsSection();

  @override
  State<_DetailsSection> createState() => _DetailsSectionState();
}

class _DetailsSectionState extends State<_DetailsSection> {
  late final TextEditingController _titleController;
  late final TextEditingController _subtitleController;
  late final StreamSubscription<DetailsState> _blocSubscription;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _subtitleController = TextEditingController();

    _blocSubscription = context.read<DetailsBloc>().stream.listen((state) {
      if (mounted) {
        _titleController.text = state.title;
        _subtitleController.text = state.subtitle;
      }
    });
  }

  @override
  void dispose() {
    unawaited(_blocSubscription.cancel());
    _titleController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsBloc, DetailsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return Center(child: CircularLoader.medium());
        }

        final isEditing = state.isEditingMode;

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: borderCircular12),
          margin: horizontal12 + top12 + bottom6,
          color: context.theme.appColors.primary,
          child: Padding(
            padding: allPadding8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailsListTile(
                  title: 'Title',
                  subtitle: state.title,
                  isEditing: isEditing,
                  controller: _titleController,
                  onChanged: (value) {
                    context.read<DetailsBloc>().add(
                      DetailsEvent.onChangeTitle(value),
                    );
                  },
                  labelText: 'Edit Title',
                ),
                gap3,
                _DetailsListTile(
                  title: 'Subtitle',
                  subtitle: state.subtitle.isEmpty ? 'None' : state.subtitle,
                  isEditing: isEditing,
                  controller: _subtitleController,
                  onChanged: (value) {
                    context.read<DetailsBloc>().add(
                      DetailsEvent.onChangeSubtitle(value),
                    );
                  },
                  labelText: 'Edit Subtitle',
                ),
                gap3,
                _DetailsListTile(
                  title: 'Date Added',
                  subtitle: '${state.timestamp.toLocal()}'.split('.')[0],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
