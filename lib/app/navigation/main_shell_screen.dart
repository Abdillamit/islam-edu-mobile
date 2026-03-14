import 'package:flutter/material.dart';
import '../../core/utils/context_l10n.dart';
import '../../features/bookmarks/presentation/screens/bookmarks_screen.dart';
import '../../features/categories/presentation/screens/categories_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/learning_path/presentation/screens/learning_path_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import 'app_routes.dart';

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _currentIndex = 0;

  void _openCategory((String id, String title) category) {
    Navigator.of(context).pushNamed(
      AppRoutes.categoryLessons,
      arguments: CategoryLessonsRouteArgs(
        categoryId: category.$1,
        categoryTitle: category.$2,
      ),
    );
  }

  void _openLesson(String lessonId) {
    Navigator.of(context).pushNamed(
      AppRoutes.lessonDetail,
      arguments: LessonDetailRouteArgs(lessonId: lessonId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final titles = [
      l10n.homeTab,
      l10n.categoriesTab,
      l10n.learningPathTab,
      l10n.bookmarksTab,
      l10n.profileTab,
    ];

    final pages = [
      HomeScreen(onOpenCategory: _openCategory, onOpenLesson: _openLesson),
      CategoriesScreen(onOpenCategory: _openCategory),
      LearningPathScreen(onOpenLesson: _openLesson),
      BookmarksScreen(onOpenLesson: _openLesson),
      const ProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(titles[_currentIndex])),
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(12, 0, 12, 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFF4F7F4), Color(0xFFE8EEE9)],
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 18,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              backgroundColor: Colors.transparent,
              indicatorColor: const Color(0xFFD7EBDD),
              iconTheme: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return const IconThemeData(
                    color: Color(0xFF0E5B49),
                    size: 24,
                  );
                }
                return const IconThemeData(color: Color(0xFF46524D), size: 22);
              }),
            ),
            child: NavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              height: 72,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              destinations: [
                NavigationDestination(
                  icon: const Icon(Icons.home_outlined),
                  selectedIcon: const Icon(Icons.home_rounded),
                  label: l10n.homeTab,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.grid_view_outlined),
                  selectedIcon: const Icon(Icons.grid_view_rounded),
                  label: l10n.categoriesTab,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.route_outlined),
                  selectedIcon: const Icon(Icons.route_rounded),
                  label: l10n.learningPathTab,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.bookmark_outline),
                  selectedIcon: const Icon(Icons.bookmark_rounded),
                  label: l10n.bookmarksTab,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.person_outline),
                  selectedIcon: const Icon(Icons.person_rounded),
                  label: l10n.profileTab,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
