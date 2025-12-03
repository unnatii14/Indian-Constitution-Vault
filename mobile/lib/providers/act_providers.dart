import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';
import '../models/act_summary.dart';

// API Service Provider
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

// Acts List Provider
final actsProvider = FutureProvider<List<ActSummary>>((ref) async {
  print('[PROVIDER] actsProvider called');
  final apiService = ref.watch(apiServiceProvider);
  print('[PROVIDER] apiService obtained: ${apiService.baseUrl}');
  final result = await apiService.listActs();
  print('[PROVIDER] Acts loaded: ${result.length}');
  return result;
});

// Selected Act Provider
final selectedActProvider = StateProvider<String?>((ref) => null);
