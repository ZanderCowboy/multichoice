/// When board / lane add affordances are shown.
enum BoardAddVisibility {
  /// Only while [BoardView.editMode] is true (default).
  editOnly,

  /// Always shown when the corresponding add builder is provided.
  always,
}
