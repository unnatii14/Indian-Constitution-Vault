import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'providers/app_providers.dart';
import 'screens/root_navigation_screen.dart';
import 'screens/about_app_screen.dart';
import 'screens/acts_list_screen.dart';
import 'screens/sections_list_screen.dart';
import 'screens/section_detail_screen.dart';
import 'screens/law_finder_screen.dart';
import 'screens/about_constitution_screen.dart';
import 'screens/bookmarks_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';

void main() {
  runApp(const ProviderScope(child: IndianConstitutionApp()));
}

// Router configuration
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    // Start with splash so we can warm up backend and show onboarding
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
      GoRoute(
        path: '/',
        builder: (context, state) => const RootNavigationScreen(),
      ),
      GoRoute(
        path: '/acts',
        builder: (context, state) => const ActsListScreen(),
      ),
      GoRoute(
        path: '/law-finder',
        builder: (context, state) => const LawFinderScreen(),
      ),
      GoRoute(
        path: '/about-constitution',
        builder: (context, state) => const AboutConstitutionScreen(),
      ),
      GoRoute(
        path: '/about-app',
        builder: (context, state) => const AboutAppScreen(),
      ),
      GoRoute(
        path: '/bookmarks',
        builder: (context, state) => const BookmarksScreen(),
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
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Indian Law Guide',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A), // Deep Blue
          brightness: Brightness.light,
          primary: const Color(0xFF1E3A8A),
          onPrimary: Colors.white,
          secondary: const Color(0xFF3B82F6), // Blue
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF1E3A8A),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: const Color(0xFFF8FAFC),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFF1E3A8A).withValues(alpha: 0.1),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(color: Color(0xFF1E3A8A), fontWeight: FontWeight.bold);
            }
            return const TextStyle(color: Colors.grey);
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: Color(0xFF1E3A8A));
            }
            return const IconThemeData(color: Colors.grey);
          }),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A),
          brightness: Brightness.dark,
          primary: const Color(0xFF3B82F6),
          surface: const Color(0xFF0F172A), // Slate 900
          onSurface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Color(0xFF0F172A),
          foregroundColor: Colors.white,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: const Color(0xFF1E293B), // Slate 800
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: const Color(0xFF1E293B),
          indicatorColor: Colors.blue.withValues(alpha: 0.2),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold);
            }
            return const TextStyle(color: Colors.white70);
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: Colors.blue);
            }
            return const IconThemeData(color: Colors.white70);
          }),
        ),
      ),
      routerConfig: router,
    );
  }
}
