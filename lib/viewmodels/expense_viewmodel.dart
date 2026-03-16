import 'package:flutter/foundation.dart';
import 'package:why/models/expense.dart';

class ExpenseViewModel extends ChangeNotifier {
  final List<Expense> _expenses = [];
  late Expense? _selectedExpense;

  List<Expense> get expenses => _expenses;
  Expense? get selectedExpense => _selectedExpense;

  double get totalExpenses {
    return _expenses.fold(0, (sum, expense) {
      return sum + (double.tryParse(expense.amount) ?? 0);
    });
  }

  int get expenseCount => _expenses.length;

  ExpenseViewModel() {
    _selectedExpense = null;
  }

  // Replace all expenses (used when syncing from Firestore)
  void setExpenses(List<Expense> expenses) {
    _expenses
      ..clear()
      ..addAll(expenses);
    _selectedExpense = null;
    notifyListeners();
  }

  // Add expense
  void addExpense(Expense expense) {
    _expenses.add(expense);
    notifyListeners();
  }

  // Remove expense
  void removeExpense(Expense expense) {
    _expenses.remove(expense);
    notifyListeners();
  }

  // Remove expense by index
  void removeExpenseAt(int index) {
    if (index >= 0 && index < _expenses.length) {
      _expenses.removeAt(index);
      notifyListeners();
    }
  }

  // Update expense
  void updateExpense(int index, Expense updatedExpense) {
    if (index >= 0 && index < _expenses.length) {
      _expenses[index] = updatedExpense;
      notifyListeners();
    }
  }

  // Get expenses by category
  List<Expense> getExpensesByCategory(String category) {
    return _expenses.where((expense) => expense.category == category).toList();
  }

  // Get expenses by date
  List<Expense> getExpensesByDate(String date) {
    return _expenses.where((expense) => expense.date == date).toList();
  }

  // Select expense
  void selectExpense(Expense expense) {
    _selectedExpense = expense;
    notifyListeners();
  }

  // Clear all expenses
  void clearAllExpenses() {
    _expenses.clear();
    _selectedExpense = null;
    notifyListeners();
  }
}
