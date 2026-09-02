import 'package:flutter/material.dart';

import '../drag/board_drag_session.dart';
import '../models/board_builders.dart';
import '../models/board_drag_models.dart';
import '../models/board_view_style.dart';

/// Floating delete-bin drop target shown in edit mode when delete callbacks
/// are provided.
class BoardDeleteBin<T> extends StatelessWidget {
  const BoardDeleteBin({
    required this.session,
    required this.style,
    required this.onItemDeleted,
    required this.onCollectionDeleted,
    super.key,
  });

  static const keyId = ValueKey<String>('board-delete-bin');

  final BoardDragSession<T> session;
  final BoardViewStyle style;
  final void Function(String itemId, String fromLaneId, int fromIndex)?
      onItemDeleted;
  final BoardCollectionDeletedCallback? onCollectionDeleted;

  bool _accepts(Object? data) {
    if (data is ItemDragPayload<T>) return onItemDeleted != null;
    if (data is LaneDragPayload) return onCollectionDeleted != null;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: Listenable.merge([
        session.deleteHover,
      ]),
      builder: (context, _) {
        final isDragging = session.isDragging;
        final hovered = session.deleteHover.active;
        final size =
            isDragging ? style.deleteBinActiveSize : style.deleteBinIdleSize;
        final background = hovered
            ? scheme.error
            : scheme.errorContainer.withValues(alpha: isDragging ? 0.95 : 0.85);
        final foreground =
            hovered ? scheme.onError : scheme.onErrorContainer;
        final icon = hovered ? Icons.delete : Icons.delete_outline;

        return AnimatedScale(
          scale: isDragging ? 1 : 0.92,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          child: DragTarget<Object>(
            onWillAcceptWithDetails: (details) => _accepts(details.data),
            onMove: (_) => session.onDeleteHover(),
            onLeave: (_) => session.onDeleteHoverEnd(),
            onAcceptWithDetails: (details) {
              final data = details.data;
              if (data is ItemDragPayload<T>) {
                final callback = onItemDeleted;
                if (callback == null) return;
                session.acceptItemDelete(data, onItemDeleted: callback);
              } else if (data is LaneDragPayload) {
                final callback = onCollectionDeleted;
                if (callback == null) return;
                session.acceptLaneDelete(
                  data,
                  onCollectionDeleted: callback,
                );
              }
            },
            builder: (context, candidate, rejected) {
              return Tooltip(
                key: keyId,
                message: isDragging ? 'Drop to delete' : 'Delete',
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: background,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: scheme.shadow.withValues(alpha: 0.22),
                        blurRadius: isDragging ? 12 : 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final side = constraints.maxWidth;
                      final showLabel =
                          side > style.deleteBinIdleSize + 4 && isDragging;
                      return Center(
                        child: showLabel
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    icon,
                                    color: foreground,
                                    size: side * 0.32,
                                  ),
                                  SizedBox(height: side * 0.04),
                                  Text(
                                    'Delete',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: foreground,
                                          fontSize: side * 0.14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                              )
                            : Icon(
                                icon,
                                color: foreground,
                                size: side * 0.42,
                              ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
