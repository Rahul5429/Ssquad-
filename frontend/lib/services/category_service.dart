import '../core/api_client.dart';
import '../models/category.dart';

class CategoryService {
  CategoryService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<Category>> fetchCategories() async {
    final response = await _apiClient.get<Map<String, dynamic>>('/categories');
    final results = response.data?['data'] as List<dynamic>? ?? <dynamic>[];
    return results.map((value) => Category.fromJson(value as Map<String, dynamic>)).toList();
  }
}

