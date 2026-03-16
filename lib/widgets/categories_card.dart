import 'package:flutter/material.dart';
import 'package:why/models/category.dart';
import 'package:why/models/expense.dart';

class CategoriesCard extends StatelessWidget {
  const CategoriesCard({
    required this.category,
    required this.expenses,
    super.key,
  });

  final Category category;
  final List<Expense> expenses;

  double _calculateCategoryTotal(String categoryName) {
    return expenses
        .where((expense) => expense.category == categoryName)
        .fold(0, (sum, expense) {
      return sum + (double.tryParse(expense.amount) ?? 0);
    });
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'transportation':
        return Icons.directions_car;
      case 'food':
        return Icons.restaurant;
      case 'entertainment':
        return Icons.movie;
      case 'utilities':
        return Icons.lightbulb;
      case 'shopping':
        return Icons.shopping_bag;
      case 'health':
        return Icons.health_and_safety;
      case 'other':
        return Icons.category;
      default:
        return Icons.receipt;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
      child: Container(
        width: 110,
        height: 110,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green, width: 2.0),
          borderRadius: BorderRadius.circular(16),
          color: Colors.green[50],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getCategoryIcon(category.category),
                color: Colors.green[600],
                size: 28,
              ),
              const SizedBox(height: 6),
              Text(
                category.category,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Container(
                height: 1,
                width: 25,
                color: Colors.green[300],
              ),
              const SizedBox(height: 4),
              Text(
                "₱${_calculateCategoryTotal(category.category).toStringAsFixed(2)}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
