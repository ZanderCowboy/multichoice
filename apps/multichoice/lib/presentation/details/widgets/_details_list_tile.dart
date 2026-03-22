part of '../details_page.dart';

class _DetailsListTile extends StatelessWidget {
  const _DetailsListTile({
    required this.title,
    this.subtitle,
    this.isEditing = false,
    this.controller,
    this.onChanged,
    this.labelText,
  });

  final String title;
  final String? subtitle;
  final bool isEditing;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final String? labelText;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: context.appColorsTheme.secondary?.withValues(alpha: 0.1),
      contentPadding: horizontal16,
      visualDensity: VisualDensity.compact,
      shape: RoundedRectangleBorder(
        borderRadius: borderCircular12,
      ),
      title: !isEditing
          ? Text(
              title,
              style: context.appTextTheme.denseTitle,
            )
          : null,
      subtitle: isEditing
          ? TextFormField(
              controller: controller,
              decoration: InputDecoration(
                alignLabelWithHint: true,
                labelText: labelText,
                labelStyle: context.appTextTheme.bodyMedium,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
              ),
              onChanged: onChanged,
              maxLines: 3,
              textAlignVertical: TextAlignVertical.top,
            )
          : SelectableText(
              subtitle ?? '',
              style: context.appTextTheme.bodyMedium,
            ),
    );
  }
}
