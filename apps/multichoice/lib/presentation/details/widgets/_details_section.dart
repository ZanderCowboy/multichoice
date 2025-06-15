part of '../details_page.dart';

class _DetailsSection extends HookWidget {
  const _DetailsSection();

  @override
  Widget build(BuildContext context) {
    final titleController = useTextEditingController();
    final subtitleController = useTextEditingController();

    return BlocBuilder<DetailsBloc, DetailsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return Center(child: CircularLoader.medium());
        }

        titleController.text = state.title;
        subtitleController.text = state.subtitle;

        final isEditing = state.isEditingMode;

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: borderCircular12),
          margin: horizontal12 + top12 + bottom6,
          color: context.theme.appColors.primary,
          child: Padding(
            padding: allPadding16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailsListTile(
                  title: 'Title',
                  subtitle: state.title,
                  isEditing: isEditing,
                  controller: titleController,
                  onChanged: (value) {
                    context.read<DetailsBloc>().add(
                          DetailsEvent.onChangeTitle(value),
                        );
                  },
                  labelText: 'Edit Title',
                ),
                gap4,
                _DetailsListTile(
                  title: 'Subtitle',
                  subtitle: state.subtitle,
                  isEditing: isEditing,
                  controller: subtitleController,
                  onChanged: (value) {
                    context.read<DetailsBloc>().add(
                          DetailsEvent.onChangeSubtitle(value),
                        );
                  },
                  labelText: 'Edit Subtitle',
                ),
                gap4,
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
