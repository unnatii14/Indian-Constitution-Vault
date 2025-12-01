import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';
import '../models/section_detail.dart';

// Provider for fetching section detail
final sectionDetailProvider =
    FutureProvider.family<
      SectionDetail,
      ({String actId, String sectionNumber})
    >((ref, params) async {
      final apiService = ref.watch(apiServiceProvider);
      return apiService.getSectionDetail(params.actId, params.sectionNumber);
    });

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

class SectionDetailScreen extends ConsumerWidget {
  final String actId;
  final String sectionNumber;

  const SectionDetailScreen({
    super.key,
    required this.actId,
    required this.sectionNumber,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sectionAsync = ref.watch(
      sectionDetailProvider((actId: actId, sectionNumber: sectionNumber)),
    );

    return Scaffold(
      appBar: AppBar(title: Text('Section $sectionNumber')),
      body: sectionAsync.when(
        data: (section) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                section.heading,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Chip(
                label: Text('Section ${section.sectionNumber}'),
                avatar: const Icon(Icons.tag, size: 16),
              ),
              const SizedBox(height: 24),
              Text(
                'English',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                section.textEn,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              if (section.textHi != null) ...[
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                Text(
                  'हिंदी',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  section.textHi!,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Failed to load section',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(error.toString(), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
