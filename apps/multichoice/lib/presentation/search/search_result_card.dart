import 'package:flutter/material.dart';
import 'package:multichoice/app/export.dart';
import 'package:ui_kit/ui_kit.dart';

class SearchResultCard extends StatelessWidget {
  const SearchResultCard({
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    // TODO: Create a reusable card widget for search results and details.
    return Card(
      elevation: 3,
      shadowColor: Colors.grey[400],
      shape: RoundedRectangleBorder(
        borderRadius: borderCircular5,
      ),
      margin: allPadding4,
      color: context.theme.appColors.secondary,
      child: InkWell(
        borderRadius: borderCircular5,
        onTap: onTap,
        child: Padding(
          padding: allPadding8,
          child: Row(
            children: [
              Icon(
                Icons.search,
                size: 24,
                color: context.theme.appColors.primary,
              ),
              gap8,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontSize: 16,
                            letterSpacing: 0.3,
                            height: 1,
                          ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    gap4,
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 12,
                            letterSpacing: 0.5,
                            height: 1.25,
                          ),
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
