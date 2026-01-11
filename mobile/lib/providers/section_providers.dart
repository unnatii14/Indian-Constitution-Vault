import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/section_summary.dart';
import '../services/local_data_service.dart';

// Provider for local data service (offline)
final localDataServiceProvider = Provider<LocalDataService>(
  (ref) => LocalDataService(),
);

// Provider for fetching sections of an act
final sectionsProvider = FutureProvider.family<List<SectionSummary>, String>((
  ref,
  actId,
) async {
  final localDataService = ref.watch(localDataServiceProvider);
  return localDataService.getActSections(actId, limit: 600);
});
