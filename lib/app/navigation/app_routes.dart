import 'package:flutter/material.dart';
import '../../features/categories/presentation/screens/lesson_list_screen.dart';
import '../../features/lessons/presentation/screens/lesson_detail_screen.dart';

class AppRoutes {
  const AppRoutes._();

  static const String categoryLessons = '/category-lessons';
  static const String lessonDetail = '/lesson-detail';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case categoryLessons:
        final args = settings.arguments as CategoryLessonsRouteArgs?;
        if (args == null) {
          return _fallbackRoute();
        }
        return MaterialPageRoute<void>(
          builder: (context) => LessonListScreen(
            categoryId: args.categoryId,
            categoryTitle: args.categoryTitle,
            onOpenLesson: (lessonId) {
              Navigator.of(context).pushNamed(
                AppRoutes.lessonDetail,
                arguments: LessonDetailRouteArgs(lessonId: lessonId),
              );
            },
          ),
          settings: settings,
        );
      case lessonDetail:
        final args = settings.arguments as LessonDetailRouteArgs?;
        if (args == null) {
          return _fallbackRoute();
        }
        return MaterialPageRoute<void>(
          builder: (_) => LessonDetailScreen(lessonId: args.lessonId),
          settings: settings,
        );
      default:
        return null;
    }
  }

  static Route<dynamic> _fallbackRoute() {
    return MaterialPageRoute<void>(
      builder: (_) => const Scaffold(body: Center(child: Text('Route error'))),
    );
  }
}

class CategoryLessonsRouteArgs {
  const CategoryLessonsRouteArgs({
    required this.categoryId,
    required this.categoryTitle,
  });

  final String categoryId;
  final String categoryTitle;
}

class LessonDetailRouteArgs {
  const LessonDetailRouteArgs({required this.lessonId});

  final String lessonId;
}
