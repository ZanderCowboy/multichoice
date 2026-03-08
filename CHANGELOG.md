# 286 - Refactor = Remove HookWidgets

- Refactor: Remove all HookWidgets and replace with Flutter's native StatefulWidget
- Remove flutter_hooks dependency from application code
- Convert custom hooks to StatefulWidget lifecycle methods
  - Replace useScrollController() with ScrollController in StatefulWidget
  - Replace useTextEditingController() with TextEditingController in StatefulWidget
  - Replace useState() with class fields and setState()
  - Replace useEffect() with initState(), didUpdateWidget(), and dispose()
  - Replace useMemoized() with late final initialization
  - Replace useFuture() with FutureBuilder
  - Replace useScrollToStartIndicator custom hook with native scroll listeners
- Updated widgets:
  - `_VerticalHome`, `_HorizontalHome`, `_VerticalTab`, `_HorizontalTab`
  - `CollectionTab`, `EntryCard`, `NewEntry`, `NewTab`
  - `_DetailsSection`, `_SearchBar`, `LightDarkModeButton`
  - `HomeLayout`, `DataTransferScreen`, `HorizontalVerticalLayoutButton`
- Remove unused BlocBuilder from EntryCard
- Improve UI responsiveness by removing unnecessary EntryCard rebuilds caused by watching AppLayout
