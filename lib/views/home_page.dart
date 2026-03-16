import 'dart:async';

import 'package:flutter/material.dart';
import 'package:why/models/category.dart';
import 'package:why/models/expense.dart';
import 'package:why/viewmodels/homepage_viewmodel.dart';
import 'package:why/widgets/add_category_dialog.dart';
import 'package:why/widgets/add_expense_dialog.dart';
import 'package:why/widgets/categories_card.dart';
import 'package:why/widgets/category_filter.dart';
import 'package:why/widgets/edit_expense_dialog.dart';
import 'package:why/widgets/expense_card.dart';
import 'package:why/widgets/total_expense_card.dart';

// import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomePageViewModel _viewModel = HomePageViewModel();
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(() {
      setState(() {});
    });
    unawaited(_viewModel.initialize());
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _showAddExpenseDialog() async {
    // Get list of category names from ViewModel
    final List<String>? categoryNames = _viewModel.categories.isNotEmpty
        ? _viewModel.categories.map((category) => category.category).toList()
        : null;

    final result = await showDialog<Expense>(
      context: context,
      builder: (BuildContext context) => AddExpenseDialog(
        categories: categoryNames,
      ),
    );
    if (result != null) {
      await _viewModel.addExpense(result);
    }
  }

  Future<void> _showAddCategoryDialog() async {
    final result = await showDialog<Category>(
      context: context,
      builder: (BuildContext context) => const AddCategoryDialog(),
    );
    if (result != null) {
      await _viewModel.addCategory(result);
    }
  }

  Future<void> _deleteExpense(Expense expense) async {
    await _viewModel.removeExpense(expense);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Expense deleted'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _editExpense(Expense expense) async {
    // Get list of category names from ViewModel
    final List<String>? categoryNames = _viewModel.categories.isNotEmpty
        ? _viewModel.categories.map((category) => category.category).toList()
        : null;

    final result = await showDialog<Expense>(
      context: context,
      builder: (BuildContext context) => EditExpenseDialog(
        expense: expense,
        categories: categoryNames,
      ),
    );
    
    if (result != null) {
      // Find the index of the original expense
      final index = _viewModel.expenses.indexOf(expense);
      if (index != -1) {
        final updatedExpense = result.copyWith(id: expense.id);
        await _viewModel.updateExpense(index, updatedExpense);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Expense updated'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  List<String> _getFilterCategories() {
    final categories = {'All'};
    for (var expense in _viewModel.expenses) {
      categories.add(expense.category);
    }
    return categories.toList();
  }

  List<Expense> _getFilteredExpenses() {
    if (_selectedFilter == 'All') {
      return _viewModel.expenses;
    }
    return _viewModel.expenses
        .where((expense) => expense.category == _selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 100,
                child: TotalExpenseCard(totalAmount: _viewModel.totalExpenses),
              ),

              SizedBox(height: 16),

              SizedBox(
                // Category list
                height: 120,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _viewModel.categories.isEmpty ? 1 : _viewModel.categories.length,
                    itemBuilder: (context, index) {
                      if (_viewModel.categories.isEmpty) {
                        return CategoriesCard(
                          category: Category(
                            categoryId: 0,
                            category: 'No Categories',
                            note: '0',
                            date: DateTime.now().toString().split(' ')[0],
                          ),
                          expenses: _viewModel.expenses,
                        );
                      }
                      return CategoriesCard(
                        category: _viewModel.categories[index],
                        expenses: _viewModel.expenses,
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.only(right:8.0, left: 8.0, bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Recent Expenses",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic
                      ),
                    ),
                    Text(
                      "${_getFilteredExpenses().length} items",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 175, 172, 172)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              // Filter buttons
              CategoryFilter(
                categories: _getFilterCategories(),
                selectedFilter: _selectedFilter,
                onFilterChanged: (String category) {
                  setState(() {
                    _selectedFilter = category;
                  });
                },
              ),
              SizedBox(height: 12),

              _getFilteredExpenses().isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: Text(
                        'No expenses yet',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _getFilteredExpenses().length,
                      itemBuilder: (context, index) {
                        final expense = _getFilteredExpenses()[index];
                        return ExpenseCard(
                          expense: expense,
                          onDelete: () => _deleteExpense(expense),
                          onEdit: () => _editExpense(expense),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddExpenseDialog,
        tooltip: 'Add Expense',
        child: Icon(Icons.add),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Row(
        children: [
          Icon(Icons.monetization_on),
          SizedBox(width: 8),
          Text(
            "Expense Tracker",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (String value) {
              if (value == 'add_category') {
                _showAddCategoryDialog();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'add_category',
                child: Row(
                  children: [
                    Icon(Icons.add, size: 20),
                    SizedBox(width: 8),
                    Text('Add Category'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
      elevation: 4.0,
      backgroundColor: Colors.green[400],
      toolbarHeight: 60,
    );
  }
}
