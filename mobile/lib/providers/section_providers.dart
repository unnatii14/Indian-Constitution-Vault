import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/section_summary.dart';
import '../services/api_service.dart';

// Provider for API service
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

// Provider for fetching sections of an act
final sectionsProvider = FutureProvider.family<List<SectionSummary>, String>((
  ref,
  actId,
) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.getActSections(actId, limit: 200);
});
