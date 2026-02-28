import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkedSection {
  final String actId;
  final String sectionNumber;
  final String heading;
  final String actName;

  const BookmarkedSection({
    required this.actId,
    required this.sectionNumber,
    required this.heading,
    required this.actName,
  });

  Map<String, dynamic> toJson() => {
    'actId': actId,
    'sectionNumber': sectionNumber,
    'heading': heading,
    'actName': actName,
  };

  factory BookmarkedSection.fromJson(Map<String, dynamic> json) =>
      BookmarkedSection(
        actId: json['actId'] as String,
        sectionNumber: json['sectionNumber'] as String,
        heading: json['heading'] as String,
        actName: json['actName'] as String,
      );

  String get id => '$actId-$sectionNumber';

  @override
  bool operator ==(Object other) =>
      other is BookmarkedSection && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

class BookmarkService {
  static const _key = 'bookmarks_v1';

  Future<List<BookmarkedSection>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => BookmarkedSection.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> _saveAll(List<BookmarkedSection> bookmarks) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(bookmarks.map((b) => b.toJson()).toList()),
    );
  }

  Future<bool> isBookmarked(String actId, String sectionNumber) async {
    final all = await loadAll();
    return all.any((b) => b.actId == actId && b.sectionNumber == sectionNumber);
  }

  Future<void> add(BookmarkedSection section) async {
    final all = await loadAll();
    if (!all.any((b) => b.id == section.id)) {
      all.insert(0, section); // newest first
      await _saveAll(all);
    }
  }

  Future<void> remove(String actId, String sectionNumber) async {
    final all = await loadAll();
    all.removeWhere(
      (b) => b.actId == actId && b.sectionNumber == sectionNumber,
    );
    await _saveAll(all);
  }

  Future<void> toggle(BookmarkedSection section) async {
    final all = await loadAll();
    final exists = all.any((b) => b.id == section.id);
    if (exists) {
      all.removeWhere((b) => b.id == section.id);
    } else {
      all.insert(0, section);
    }
    await _saveAll(all);
  }
}
