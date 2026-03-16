import 'package:flutter/foundation.dart' hide Category;
import 'package:why/models/category.dart';

class CategoryViewModel extends ChangeNotifier {
  final List<Category> _categories = [];
  late Category? _selectedCategory;

  List<Category> get categories => _categories;
  Category? get selectedCategory => _selectedCategory;
  int get categoryCount => _categories.length;

  CategoryViewModel() {
    _selectedCategory = null;
  }

  // Replace all categories (used when syncing from Firestore)
  void setCategories(List<Category> categories) {
    _categories
      ..clear()
      ..addAll(categories);
    _selectedCategory = null;
    notifyListeners();
  }

  // Add category
  void addCategory(Category category) {
    _categories.add(category);
    notifyListeners();
  }

  // Remove category
  void removeCategory(Category category) {
    _categories.remove(category);
    notifyListeners();
  }

  // Remove category by index
  void removeCategoryAt(int index) {
    if (index >= 0 && index < _categories.length) {
      _categories.removeAt(index);
      notifyListeners();
    }
  }

  // Update category
  void updateCategory(int index, Category updatedCategory) {
    if (index >= 0 && index < _categories.length) {
      _categories[index] = updatedCategory;
      notifyListeners();
    }
  }

  // Get category by id
  Category? getCategoryById(int categoryId) {
    try {
      return _categories.firstWhere((cat) => cat.categoryId == categoryId);
    } catch (e) {
      return null;
    }
  }

  // Get category by name
  Category? getCategoryByName(String categoryName) {
    try {
      return _categories.firstWhere((cat) => cat.category == categoryName);
    } catch (e) {
      return null;
    }
  }

  // Select category
  void selectCategory(Category category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Clear all categories
  void clearAllCategories() {
    _categories.clear();
    _selectedCategory = null;
    notifyListeners();
  }
}
