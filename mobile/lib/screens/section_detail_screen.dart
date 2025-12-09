import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../services/api_service.dart';
import '../models/section_detail.dart';
import '../providers/section_providers.dart';

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

  Color _getActColor(String actId) {
    if (actId.contains('BNS')) return Colors.orange.shade700;
    if (actId.contains('BNSS')) return Colors.green.shade700;
    if (actId.contains('BSA')) return Colors.blue.shade700;
    if (actId.contains('CONST')) return Colors.purple.shade700;
    if (actId.contains('CRPC')) return Colors.red.shade700;
    if (actId.contains('IPC')) return Colors.cyan.shade700;
    return Colors.grey.shade700;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sectionAsync = ref.watch(
      sectionDetailProvider((actId: actId, sectionNumber: sectionNumber)),
    );
    final actColor = _getActColor(actId);

    return PopScope(
      canPop: true,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [actColor.withOpacity(0.1), Colors.white],
            ),
          ),
          child: SafeArea(
            child: sectionAsync.when(
              data: (section) => CustomScrollView(
                slivers: [
                  // App Bar
                  SliverAppBar(
                    expandedHeight: 140,
                    pinned: true,
                    backgroundColor: actColor,
                    automaticallyImplyLeading: true,
                    leading: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black87,
                        ),
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          } else {
                            context.go('/acts/$actId/sections');
                          }
                        },
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        'Section $sectionNumber',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [actColor, actColor.withOpacity(0.7)],
                          ),
                        ),
                        child: SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 56,
                              top: 16,
                              right: 16,
                            ),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                section.heading,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Content
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Section Info Card
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: actColor.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: actColor.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        actId,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: actColor,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.numbers,
                                            size: 14,
                                            color: Colors.grey.shade700,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Section $sectionNumber',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  section.heading,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // English Content
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.language,
                                        color: Colors.blue.shade700,
                                        size: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      'English',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  section.content,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    height: 1.6,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Hindi Content
                          if (section.contentHi != null) ...[
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.orange.shade50,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.translate,
                                          color: Colors.orange.shade700,
                                          size: 18,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      const Text(
                                        'हिंदी',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    section.contentHi!,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      height: 1.6,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          const SizedBox(height: 32),

                          // Navigation buttons
                          _NavigationButtons(
                            actId: actId,
                            currentSectionNumber: sectionNumber,
                            actColor: actColor,
                          ),

                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 80,
                        color: Colors.red.shade300,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Failed to load section',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        error.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => ref.invalidate(sectionDetailProvider),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: actColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Navigation buttons widget
class _NavigationButtons extends ConsumerWidget {
  final String actId;
  final String currentSectionNumber;
  final Color actColor;

  const _NavigationButtons({
    required this.actId,
    required this.currentSectionNumber,
    required this.actColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sectionsAsync = ref.watch(sectionsProvider(actId));

    return sectionsAsync.when(
      data: (sections) {
        if (sections.isEmpty) return const SizedBox();

        // Find current section index
        final currentIndex = sections.indexWhere(
          (s) => s.sectionNumber == currentSectionNumber,
        );

        if (currentIndex == -1) return const SizedBox();

        final hasPrevious = currentIndex > 0;
        final hasNext = currentIndex < sections.length - 1;
        final previousSection = hasPrevious ? sections[currentIndex - 1] : null;
        final nextSection = hasNext ? sections[currentIndex + 1] : null;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: actColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: actColor.withOpacity(0.2), width: 1),
          ),
          child: Row(
            children: [
              // Previous button
              if (hasPrevious)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.go(
                        '/acts/$actId/sections/${previousSection!.sectionNumber}',
                      );
                    },
                    icon: const Icon(Icons.arrow_back, size: 18),
                    label: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Previous', style: TextStyle(fontSize: 12)),
                        Text(
                          'Sec ${previousSection!.sectionNumber}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: actColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: actColor.withOpacity(0.3)),
                      ),
                    ),
                  ),
                )
              else
                const Expanded(child: SizedBox()),

              if (hasPrevious && hasNext) const SizedBox(width: 12),

              // Next button
              if (hasNext)
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.go(
                        '/acts/$actId/sections/${nextSection!.sectionNumber}',
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: actColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Next',
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                'Sec ${nextSection!.sectionNumber}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, size: 18),
                      ],
                    ),
                  ),
                )
              else
                const Expanded(child: SizedBox()),
            ],
          ),
        );
      },
      loading: () => const SizedBox(),
      error: (_, __) => const SizedBox(),
    );
  }
}
