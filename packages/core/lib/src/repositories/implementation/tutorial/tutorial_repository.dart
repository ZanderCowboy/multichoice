// ignore_for_file: unused_field, unused_local_variable

import 'dart:developer';

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:models/models.dart';

@LazySingleton(as: ITutorialRepository)
class TutorialRepository implements ITutorialRepository {
  TutorialRepository();

  @override
  Future<List<TabsDTO>> loadTutorialData() async {
    try {
      final movieEntries = [
        EntryDTO(
          id: 1,
          tabId: 1,
          title: 'The Shawshank Redemption',
          subtitle: 'A story of hope and friendship',
          timestamp: DateTime.now(),
        ),
        EntryDTO(
          id: 2,
          tabId: 1,
          title: 'The Godfather',
          subtitle: 'A crime drama masterpiece',
          timestamp: DateTime.now(),
        ),
      ];

      final bookEntries = [
        EntryDTO(
          id: 3,
          tabId: 2,
          title: 'To Kill a Mockingbird',
          subtitle: 'A classic about justice and morality',
          timestamp: DateTime.now(),
        ),
        EntryDTO(
          id: 4,
          tabId: 2,
          title: '1984',
          subtitle: 'A dystopian masterpiece',
          timestamp: DateTime.now(),
        ),
      ];

      final moviesTab = TabsDTO(
        id: 1,
        title: 'Movies',
        subtitle: 'My favorite movies',
        timestamp: DateTime.now(),
        entries: movieEntries,
        order: 0,
      );

      final booksTab = TabsDTO(
        id: 2,
        title: 'Books',
        subtitle: 'Must-read books',
        timestamp: DateTime.now(),
        entries: bookEntries,
        order: 1,
      );

      return [moviesTab, booksTab];
    } catch (e) {
      log(e.toString());
      return [];
    }
  }
}
