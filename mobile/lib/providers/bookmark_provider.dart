import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/bookmark_service.dart';

final bookmarkServiceProvider = Provider<BookmarkService>(
  (_) => BookmarkService(),
);

// Loads the full list of bookmarks
final bookmarksProvider =
    AsyncNotifierProvider<BookmarksNotifier, List<BookmarkedSection>>(
      BookmarksNotifier.new,
    );

class BookmarksNotifier extends AsyncNotifier<List<BookmarkedSection>> {
  BookmarkService get _service => ref.read(bookmarkServiceProvider);

  @override
  Future<List<BookmarkedSection>> build() => _service.loadAll();

  Future<void> toggle(BookmarkedSection section) async {
    await _service.toggle(section);
    state = AsyncData(await _service.loadAll());
  }

  Future<void> remove(String actId, String sectionNumber) async {
    await _service.remove(actId, sectionNumber);
    state = AsyncData(await _service.loadAll());
  }

  bool isBookmarked(String actId, String sectionNumber) {
    return state.valueOrNull?.any(
          (b) => b.actId == actId && b.sectionNumber == sectionNumber,
        ) ??
        false;
  }
}
