import 'package:flutter/foundation.dart' hide Category;

import '../models/category.dart';
import '../services/category_service.dart';

class CategoryProvider extends ChangeNotifier {
  CategoryProvider(this._categoryService);

  final CategoryService _categoryService;

  List<Category> _categories = <Category>[];
  bool _isLoading = false;
  String? _errorMessage;

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadCategories() async {
    if (_isLoading) return;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _categories = await _categoryService.fetchCategories();
    } catch (error) {
      debugPrint('Failed to load categories: $error');
      _errorMessage = 'Unable to load categories';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

