import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:why/models/category.dart';
import 'package:why/models/expense.dart';
import 'package:why/viewmodels/category_viewmodel.dart';
import 'package:why/viewmodels/expense_viewmodel.dart';

class HomePageViewModel extends ChangeNotifier {
  HomePageViewModel({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance {
    _expenseViewModel.addListener(_onViewModelChanged);
    _categoryViewModel.addListener(_onViewModelChanged);
  }

  final FirebaseFirestore _firestore;
  final ExpenseViewModel _expenseViewModel = ExpenseViewModel();
  final CategoryViewModel _categoryViewModel = CategoryViewModel();

  static const List<String> _defaultCategories = [
    'Transportation',
    'Food',
    'Entertainment',
    'Utilities',
    'Shopping',
    'Health',
  ];

  Future<void> initialize() async {
    await Future.wait([
      _loadCategories(),
      _loadExpenses(),
    ]);
  }

  // Getters
  ExpenseViewModel get expenseViewModel => _expenseViewModel;
  CategoryViewModel get categoryViewModel => _categoryViewModel;

  List<Expense> get expenses => _expenseViewModel.expenses;
  List<Category> get categories => _categoryViewModel.categories;
  double get totalExpenses => _expenseViewModel.totalExpenses;
  int get expenseCount => _expenseViewModel.expenseCount;
  int get categoryCount => _categoryViewModel.categoryCount;

  void _onViewModelChanged() {
    notifyListeners();
  }

  bool _isDefaultCategory(String category) {
    return _defaultCategories
        .any((value) => value.toLowerCase() == category.toLowerCase());
  }

  Future<void> _loadCategories() async {
    try {
      final snapshot = await _firestore.collection('categories').get();
      final categories = snapshot.docs
          .map((doc) => Category.fromMap(doc.id, doc.data()))
          .toList();
      _categoryViewModel.setCategories(categories);
    } catch (e) {
      debugPrint('Failed to load categories: $e');
    }
  }

  Future<void> _loadExpenses() async {
    try {
      final snapshot = await _firestore
          .collection('expenses')
          .orderBy('date', descending: true)
          .get();
      final expenses = snapshot.docs
          .map((doc) => Expense.fromMap(doc.id, doc.data()))
          .toList();
      _expenseViewModel.setExpenses(expenses);
      await _syncCategoriesFromExpenses(expenses);
    } catch (e) {
      debugPrint('Failed to load expenses: $e');
    }
  }

  // ===== EXPENSE OPERATIONS =====

  Future<void> addExpense(Expense expense) async {
    try {
      final doc = await _firestore.collection('expenses').add(expense.toMap());
      final savedExpense = expense.copyWith(id: doc.id);
      _expenseViewModel.addExpense(savedExpense);
      await _ensureCategoryForExpense(savedExpense);
    } catch (e) {
      debugPrint('Failed to add expense: $e');
    }
  }

  Future<void> removeExpense(Expense expense) async {
    try {
      if (expense.id != null) {
        await _firestore.collection('expenses').doc(expense.id).delete();
      }
      _expenseViewModel.removeExpense(expense);
    } catch (e) {
      debugPrint('Failed to delete expense: $e');
    }
  }

  Future<void> removeExpenseAt(int index) async {
    if (index < 0 || index >= _expenseViewModel.expenses.length) {
      return;
    }
    final expense = _expenseViewModel.expenses[index];
    await removeExpense(expense);
  }

  Future<void> updateExpense(int index, Expense updatedExpense) async {
    if (index < 0 || index >= _expenseViewModel.expenses.length) {
      return;
    }
    final current = _expenseViewModel.expenses[index];
    final docId = updatedExpense.id ?? current.id;

    if (docId == null) {
      _expenseViewModel.updateExpense(index, updatedExpense);
      return;
    }

    try {
      await _firestore
          .collection('expenses')
          .doc(docId)
          .update(updatedExpense.toMap());
      _expenseViewModel
          .updateExpense(index, updatedExpense.copyWith(id: docId));
      await _ensureCategoryForExpense(updatedExpense);
    } catch (e) {
      debugPrint('Failed to update expense: $e');
    }
  }

  List<Expense> getExpensesByCategory(String category) {
    return _expenseViewModel.getExpensesByCategory(category);
  }

  void selectExpense(Expense expense) {
    _expenseViewModel.selectExpense(expense);
  }

  // ===== CATEGORY OPERATIONS =====

  Future<void> addCategory(Category category) async {
    if (_categoryViewModel.getCategoryByName(category.category) != null) {
      return;
    }

    if (category.isDefault) {
      _categoryViewModel.addCategory(category);
      return;
    }

    try {
      final doc = await _firestore.collection('categories').add(
            category.toMap(),
          );
      _categoryViewModel.addCategory(category.copyWith(id: doc.id));
    } catch (e) {
      debugPrint('Failed to add category: $e');
    }
  }

  Future<void> removeCategory(Category category) async {
    try {
      if (category.id != null && !category.isDefault) {
        await _firestore.collection('categories').doc(category.id).delete();
      }
      _categoryViewModel.removeCategory(category);
    } catch (e) {
      debugPrint('Failed to delete category: $e');
    }
  }

  Future<void> removeCategoryAt(int index) async {
    if (index < 0 || index >= _categoryViewModel.categories.length) {
      return;
    }
    final category = _categoryViewModel.categories[index];
    await removeCategory(category);
  }

  Future<void> updateCategory(int index, Category updatedCategory) async {
    if (index < 0 || index >= _categoryViewModel.categories.length) {
      return;
    }
    final current = _categoryViewModel.categories[index];
    final docId = updatedCategory.id ?? current.id;

    if (docId == null || updatedCategory.isDefault) {
      _categoryViewModel
          .updateCategory(index, updatedCategory.copyWith(id: docId));
      return;
    }

    try {
      await _firestore
          .collection('categories')
          .doc(docId)
          .update(updatedCategory.toMap());
      _categoryViewModel
          .updateCategory(index, updatedCategory.copyWith(id: docId));
    } catch (e) {
      debugPrint('Failed to update category: $e');
    }
  }

  Category? getCategoryById(int categoryId) {
    return _categoryViewModel.getCategoryById(categoryId);
  }

  void selectCategory(Category category) {
    _categoryViewModel.selectCategory(category);
  }

  Future<void> _ensureCategoryForExpense(Expense expense) async {
    final existing = _categoryViewModel.getCategoryByName(expense.category);
    if (existing != null) {
      return;
    }

    final category = Category(
      categoryId: DateTime.now().millisecondsSinceEpoch,
      category: expense.category,
      note: expense.note,
      date: expense.date,
      isDefault: _isDefaultCategory(expense.category),
    );
    await addCategory(category);
  }

  Future<void> _syncCategoriesFromExpenses(List<Expense> expenses) async {
    for (final expense in expenses) {
      final existing = _categoryViewModel.getCategoryByName(expense.category);
      if (existing != null) {
        continue;
      }
      final category = Category(
        categoryId: DateTime.now().millisecondsSinceEpoch,
        category: expense.category,
        note: '',
        date: expense.date,
        isDefault: _isDefaultCategory(expense.category),
      );
      _categoryViewModel.addCategory(category);
    }
  }

  // ===== UTILITY =====

  void clearAll() {
    _expenseViewModel.clearAllExpenses();
    _categoryViewModel.clearAllCategories();
  }

  @override
  void dispose() {
    _expenseViewModel.removeListener(_onViewModelChanged);
    _categoryViewModel.removeListener(_onViewModelChanged);
    _expenseViewModel.dispose();
    _categoryViewModel.dispose();
    super.dispose();
  }
}
