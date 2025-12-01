import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'screens/home_screen.dart';
import 'screens/acts_list_screen.dart';
import 'screens/sections_list_screen.dart';
import 'screens/section_detail_screen.dart';

void main() {
  runApp(const ProviderScope(child: IndianConstitutionApp()));
}

// Router configuration
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/acts',
        builder: (context, state) => const ActsListScreen(),
      ),
      GoRoute(
        path: '/acts/:actId/sections',
        builder: (context, state) {
          final actId = state.pathParameters['actId']!;
          return SectionsListScreen(actId: actId);
        },
      ),
      GoRoute(
        path: '/acts/:actId/sections/:sectionNumber',
        builder: (context, state) {
          final actId = state.pathParameters['actId']!;
          final sectionNumber = state.pathParameters['sectionNumber']!;
          return SectionDetailScreen(
            actId: actId,
            sectionNumber: sectionNumber,
          );
        },
      ),
    ],
  );
});

class IndianConstitutionApp extends ConsumerWidget {
  const IndianConstitutionApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'Indian Constitution Vault',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
