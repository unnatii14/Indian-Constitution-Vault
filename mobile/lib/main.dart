import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/acts_list_screen.dart';
import 'screens/sections_list_screen.dart';
import 'screens/section_detail_screen.dart';
import 'screens/ai_explanation_screen.dart';

void main() {
  runApp(const ProviderScope(child: IndianConstitutionApp()));
}

// Provider to check if onboarding is complete
final onboardingCompleteProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('onboarding_complete') ?? false;
});

// Router configuration
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(path: '/', builder: (context, state) => const ActsListScreen()),
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
      GoRoute(
        path: '/explain',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return AiExplanationScreen(
            sectionText: extra['sectionContent'] as String,
            heading: extra['sectionTitle'] as String,
            language: extra['language'] as String,
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
      title: 'Indian Law Guide',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      ),
      routerConfig: router,
    );
  }
}
