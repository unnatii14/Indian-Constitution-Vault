import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/services.dart';
import '../models/act_summary.dart';
import '../models/section_summary.dart';
import '../models/section_detail.dart';

/// Local data service that loads Constitution and law data from bundled assets
/// This replaces the API service for fully offline functionality
class LocalDataService {
  // Cache for loaded data
  final Map<String, Map<String, dynamic>> _dataCache = {};
  bool _isInitialized = false;

  // Act metadata - Only acts with complete content
  static const List<Map<String, dynamic>> _actMetadata = [
    {
      'act_id': 'bns',
      'title': 'Bharatiya Nyaya Sanhita, 2023 (BNS)',
      'file': 'assets/data/bns_en.json',
      'languages': ['en'],
    },
    {
      'act_id': 'bnss',
      'title': 'Bharatiya Nagarik Suraksha Sanhita, 2023 (BNSS)',
      'file': 'assets/data/bnss_en.json',
      'languages': ['en'],
    },
    {
      'act_id': 'bsa',
      'title': 'Bharatiya Sakshya Adhiniyam, 2023 (BSA)',
      'file': 'assets/data/bsa_en.json',
      'languages': ['en'],
    },
  ];

  /// Initialize the service by preloading all data files
  Future<void> initialize() async {
    if (_isInitialized) return;

    for (final actMeta in _actMetadata) {
      try {
        final actId = actMeta['act_id'] as String;
        final filePath = actMeta['file'] as String;

        final jsonString = await rootBundle.loadString(filePath);
        final data = jsonDecode(jsonString) as Map<String, dynamic>;
        _dataCache[actId] = data;
      } catch (e, st) {
        developer.log(
          'Failed to load ${actMeta['act_id']}',
          name: 'LocalDataService',
          error: e,
          stackTrace: st,
        );
        // Continue loading other files even if one fails
      }
    }

    _isInitialized = true;
  }

  /// Health check - always returns true since data is local
  Future<bool> checkHealth() async {
    return _isInitialized;
  }

  /// List all available acts
  Future<List<ActSummary>> listActs() async {
    if (!_isInitialized) {
      await initialize();
    }

    final acts = <ActSummary>[];

    for (final actMeta in _actMetadata) {
      final cacheKey = actMeta['act_id'] as String;
      final data = _dataCache[cacheKey];

      if (data != null) {
        final sections = data['sections'] as List? ?? [];
        // Use the actual act_id from the JSON data
        final actualActId = data['act_id'] as String? ?? cacheKey.toUpperCase();
        acts.add(
          ActSummary(
            actId: actualActId,
            title: actMeta['title'] as String,
            sectionCount: sections.length,
            languages: List<String>.from(actMeta['languages'] as List),
          ),
        );
      }
    }

    return acts;
  }

  /// Get sections for a specific act with pagination
  Future<List<SectionSummary>> getActSections(
    String actId, {
    int offset = 0,
    int limit = 20,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    // Find data by matching act_id from JSON or cache key
    final data = _findDataByActId(actId);
    if (data == null) {
      throw Exception('Act not found: $actId');
    }

    final allSections = data['sections'] as List? ?? [];
    final endIndex = (offset + limit).clamp(0, allSections.length);
    final paginatedSections = allSections.sublist(
      offset.clamp(0, allSections.length),
      endIndex,
    );

    return paginatedSections.map((section) {
      final sectionMap = section as Map<String, dynamic>;

      // Extract preview from text (first 150 characters)
      String? preview;
      final text =
          sectionMap['text'] as String? ?? sectionMap['content'] as String?;
      if (text != null && text.isNotEmpty) {
        preview = text.length > 150 ? '${text.substring(0, 150)}...' : text;
      }

      return SectionSummary(
        sectionNumber: sectionMap['section_number']?.toString() ?? '',
        heading: sectionMap['heading']?.toString() ?? 'Untitled',
        preview: preview,
      );
    }).toList();
  }

  /// Get detailed information for a specific section
  Future<SectionDetail> getSectionDetail(
    String actId,
    String sectionNumber,
  ) async {
    if (!_isInitialized) {
      await initialize();
    }

    // Find data by matching act_id from JSON or cache key
    final data = _findDataByActId(actId);
    if (data == null) {
      throw Exception('Act not found: $actId');
    }

    final sections = data['sections'] as List? ?? [];

    // Find the section by number
    final sectionData = sections.firstWhere(
      (s) =>
          (s as Map<String, dynamic>)['section_number']?.toString() ==
          sectionNumber,
      orElse: () => null,
    );

    if (sectionData == null) {
      throw Exception('Section not found: $sectionNumber');
    }

    final sectionMap = sectionData as Map<String, dynamic>;

    return SectionDetail(
      actId: actId,
      sectionNumber: sectionNumber,
      heading: sectionMap['heading']?.toString() ?? 'Untitled',
      content:
          sectionMap['text']?.toString() ??
          sectionMap['content']?.toString() ??
          '',
      contentHi:
          sectionMap['text_hi']?.toString() ??
          sectionMap['content_hi']?.toString(),
    );
  }

  /// Search across all acts or within a specific act
  Future<List<Map<String, dynamic>>> search(
    String query, {
    String? actId,
    int limit = 20,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    if (query.isEmpty) {
      return [];
    }

    final results = <Map<String, dynamic>>[];
    final queryLower = query.toLowerCase();

    // Determine which acts to search
    final actsToSearch = actId != null ? [actId] : _dataCache.keys.toList();

    for (final searchActId in actsToSearch) {
      final data = _dataCache[searchActId];
      if (data == null) continue;

      final sections = data['sections'] as List? ?? [];

      for (final section in sections) {
        if (results.length >= limit) break;

        final sectionMap = section as Map<String, dynamic>;
        final sectionNumber = sectionMap['section_number']?.toString() ?? '';
        final heading = sectionMap['heading']?.toString() ?? '';
        final text =
            sectionMap['text']?.toString() ??
            sectionMap['content']?.toString() ??
            '';

        // Simple text search in heading and text
        if (heading.toLowerCase().contains(queryLower) ||
            text.toLowerCase().contains(queryLower)) {
          // Extract snippet around the match
          String snippet = '';
          final textLower = text.toLowerCase();
          final index = textLower.indexOf(queryLower);

          if (index >= 0) {
            final start = (index - 50).clamp(0, text.length);
            final end = (index + queryLower.length + 100).clamp(0, text.length);
            snippet = '...${text.substring(start, end)}...';
          } else {
            snippet = text.length > 150 ? '${text.substring(0, 150)}...' : text;
          }

          results.add({
            'act_id': searchActId,
            'section_number': sectionNumber,
            'heading': heading,
            'snippet': snippet,
            'score': 1.0, // Simple relevance score
          });
        }
      }

      if (results.length >= limit) break;
    }

    return results;
  }

  /// Helper method to find data by act_id (handles both cache key and JSON act_id)
  Map<String, dynamic>? _findDataByActId(String actId) {
    // First try direct cache lookup
    if (_dataCache.containsKey(actId)) {
      return _dataCache[actId];
    }

    // Then try to find by matching act_id in the JSON data
    for (final entry in _dataCache.entries) {
      final data = entry.value;
      final jsonActId = data['act_id'] as String?;
      if (jsonActId != null && jsonActId.toUpperCase() == actId.toUpperCase()) {
        return data;
      }
    }

    return null;
  }

  /// Get total section count for an act
  int getSectionCount(String actId) {
    final data = _findDataByActId(actId);
    if (data == null) return 0;

    final sections = data['sections'] as List? ?? [];
    return sections.length;
  }

  /// Check if service is initialized
  bool get isInitialized => _isInitialized;

  /// Clear cache (useful for testing)
  void clearCache() {
    _dataCache.clear();
    _isInitialized = false;
  }
}
