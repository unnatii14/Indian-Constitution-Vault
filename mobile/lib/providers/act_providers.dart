import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/local_data_service.dart';
import '../models/act_summary.dart';

// Local Data Service Provider (offline)
final localDataServiceProvider = Provider<LocalDataService>((ref) {
  return LocalDataService();
});

// Acts List Provider
final actsProvider = FutureProvider<List<ActSummary>>((ref) async {
  print('[PROVIDER] actsProvider called');
  final localDataService = ref.watch(localDataServiceProvider);
  print('[PROVIDER] Loading acts from local data');
  final result = await localDataService.listActs();
  print('[PROVIDER] Acts loaded: ${result.length}');
  return result;
});

// Selected Act Provider
final selectedActProvider = StateProvider<String?>((ref) => null);
