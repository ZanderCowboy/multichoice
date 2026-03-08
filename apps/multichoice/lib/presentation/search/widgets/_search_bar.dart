part of '../search_page.dart';

class _SearchBar extends StatefulWidget {
  const _SearchBar();

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  late final TextEditingController _controller;

  bool get _hasQuery => _controller.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onTextChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: TextField(
        controller: _controller,
        autofocus: true,
        cursorColor: Colors.black87,
        cursorHeight: 18,
        style: const TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          hintText: 'Search...',
          hintStyle: const TextStyle(color: Colors.black54),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: borderCircular16,
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: borderCircular16,
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderCircular16,
            borderSide: BorderSide.none,
          ),
          suffixIconConstraints: const BoxConstraints(minWidth: 32),
          suffixIcon: IgnorePointer(
            ignoring: !_hasQuery,
            child: AnimatedOpacity(
              opacity: _hasQuery ? 1 : 0,
              duration: const Duration(milliseconds: 120),
              child: IconButton(
                icon: const Icon(
                  Icons.clear,
                  color: Colors.black54,
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  _controller.clear();
                  context.read<SearchBloc>().add(const SearchEvent.clear());
                },
              ),
            ),
          ),
        ),
        onChanged: (query) {
          context.read<SearchBloc>().add(SearchEvent.search(query));
        },
      ),
    );
  }
}
