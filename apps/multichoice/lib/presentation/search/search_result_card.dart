import 'package:flutter/material.dart';
import 'package:multichoice/app/export.dart';
import 'package:ui_kit/ui_kit.dart';

class SearchResultCard extends StatelessWidget {
  const SearchResultCard({
    required this.title,
    required this.subtitle,
    required this.isTab,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final String title;
  final String subtitle;
  final bool isTab;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    // TODO: Create a reusable card widget for search results and details.
    return Card(
      elevation: 3,
      // shadowColor: Colors.grey[400],
      shape: RoundedRectangleBorder(
        borderRadius: borderCircular5,
      ),
      margin: allPadding4,
      child: InkWell(
        borderRadius: borderCircular5,
        onTap: onTap,
        child: Padding(
          padding: allPadding8,
          child: Row(
            children: [
              Icon(
                isTab ? Icons.calendar_view_month : Icons.crop_landscape,
                size: 24,
              ),
              gap8,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.theme.appTextTheme.denseTitle,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    gap4,
                    Text(
                      subtitle,
                      style: context.theme.appTextTheme.denseSubtitle,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 'Edit') {
                    onEdit();
                  } else if (value == 'Delete') {
                    onDelete();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'Edit',
                    child: Text('Edit'),
                  ),
                  const PopupMenuItem(
                    value: 'Delete',
                    child: Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
