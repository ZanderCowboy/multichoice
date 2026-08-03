/// How [BoardView] surfaces overflow on board and per-lane scroll axes.
enum BoardScrollIndicator {
  /// Draggable edge thumb ([BoardScrollThumb]).
  thumb,

  /// Bidirectional edge arrows that nudge by roughly one viewport.
  arrows,
}
