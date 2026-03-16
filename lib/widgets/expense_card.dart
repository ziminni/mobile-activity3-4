import 'package:flutter/material.dart';
import 'package:why/models/expense.dart';
import 'package:why/widgets/expense_detail_dialog.dart';

class ExpenseCard extends StatelessWidget {
  const ExpenseCard({
    required this.expense,
    required this.onDelete,
    required this.onEdit,
    super.key,
  });

  final Expense expense;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

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
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => ExpenseDetailDialog(
            expense: expense,
            onDelete: onDelete,
            onEdit: onEdit,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
        height: 90,
        width: 400,
        decoration: BoxDecoration(
          // color: Colors.greenAccent,
          borderRadius: BorderRadius.circular(18),
          border: Border(bottom: BorderSide(
            color: Colors.black,
            width: 2.0
          ))
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // logo of the category
                  Container(
                    height: 75,
                    width:65,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Icon(
                      _getCategoryIcon(expense.category),
                      size: 40,
                    ),
                  ),
                  SizedBox(width: 10,),
              
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        expense.category,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      SizedBox(height: 4,),

                      Text(
                        "Me/ ${expense.title}",
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.grey[600]
                        ),
                      ),
                      SizedBox(height: 4,),
              
                      Text(
                        expense.date,
                        style: TextStyle(
                          fontSize: 12
                        ),
                      )
                    ],
                  ),
                ]
              ),

              Text(
                "+ ₱${expense.amount}",
                style: TextStyle(
                  fontSize: 16,
                  color: const Color.fromARGB(255, 247, 74, 74),
                  fontWeight: FontWeight.w600
                ),
              )
            ],
          ),
        )
      ),
      ),
    );
  }
}
