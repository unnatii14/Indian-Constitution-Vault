import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/local_data_service.dart';
import '../models/act_summary.dart';

// Local Data Service Provider (offline)
final localDataServiceProvider = Provider<LocalDataService>((ref) {
  return LocalDataService();
});

// Acts List Provider
final actsProvider = FutureProvider<List<ActSummary>>((ref) async {
  final localDataService = ref.watch(localDataServiceProvider);
  return localDataService.listActs();
});

// Selected Act Provider
final selectedActProvider = StateProvider<String?>((ref) => null);
