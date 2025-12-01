import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/act_providers.dart';

class ActsListScreen extends ConsumerWidget {
  const ActsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actsAsync = ref.watch(actsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Legal Acts')),
      body: actsAsync.when(
        data: (acts) => ListView.builder(
          itemCount: acts.length,
          itemBuilder: (context, index) {
            final act = acts[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(
                    act.actId.substring(0, 2),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                title: Text(act.title),
                subtitle: Text(
                  '${act.sectionCount} sections • ${act.languages.join(", ")}',
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  ref.read(selectedActProvider.notifier).state = act.actId;
                  context.go('/acts/${act.actId}/sections');
                },
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Failed to load acts',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => ref.invalidate(actsProvider),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
