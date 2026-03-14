import 'package:flutter_test/flutter_test.dart';
import 'package:islam_edu_mobile/features/lessons/data/lessons_repository.dart';
import 'package:islam_edu_mobile/features/lessons/data/lessons_service.dart';
import 'package:mocktail/mocktail.dart';

class MockLessonsService extends Mock implements LessonsService {}

void main() {
  late MockLessonsService service;
  late LessonsRepository repository;

  setUp(() {
    service = MockLessonsService();
    repository = LessonsRepository(service);
  });

  test('parses paginated lessons response', () async {
    when(
      () => service.getLessons(
        lang: 'ru',
        categoryId: 'cat-1',
        page: 1,
        limit: 20,
      ),
    ).thenAnswer(
      (_) async => {
        'items': [
          {
            'id': 'lesson-1',
            'categoryId': 'cat-1',
            'title': 'Урок 1',
            'shortDescription': 'Описание',
            'categoryTitle': 'Категория',
            'isFeatured': false,
          },
        ],
        'page': 1,
        'limit': 20,
        'total': 1,
        'totalPages': 1,
      },
    );

    final result = await repository.fetchLessons(
      lang: 'ru',
      categoryId: 'cat-1',
    );

    expect(result.total, 1);
    expect(result.items.length, 1);
    expect(result.items.first.title, 'Урок 1');
  });
}
