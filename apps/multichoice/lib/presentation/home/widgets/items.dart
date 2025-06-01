part of '../home_page.dart';

class Items extends StatelessWidget {
  const Items({
    required this.id,
    required this.entries,
    super.key,
  });

  final int id;
  final List<EntryDTO> entries;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return EntryLayout(
          id: id,
          entries: entries,
        );
      },
    );
  }
}
