import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';

final categoriesServiceProvider = Provider<CategoriesService>((ref) {
  return CategoriesService(ref.watch(apiClientProvider));
});

class CategoriesService {
  const CategoriesService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<dynamic>> getCategories({required String lang}) async {
    final response = await _apiClient.get(
      '/categories',
      queryParameters: {'lang': lang},
      lang: lang,
    );

    if (response is! List<dynamic>) {
      return [];
    }
    return response;
  }
}
