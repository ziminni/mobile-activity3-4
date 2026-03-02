import 'package:flutter/material.dart';
import 'package:why/widgets/categories_card.dart';
import 'package:why/widgets/expense_card.dart';
import 'package:why/widgets/total_expense_card.dart';

import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // try
  final List _expenses = [
    "expense 1",
    "expense 2",
    "expense 3",
    "expense 4",
    "expense 5",
    "expense 6",
    "expense 7",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: TotalExpenseCard(), // Total expense card
            ),

            SizedBox(height: 16),

            Expanded(
              // Category list
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _expenses.length,
                  itemBuilder: (context, index) {
                    return CategoriesCard();
                  },
                ),
              ),
            ),
            SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.only(right:8.0, left: 8.0, bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recent Expenses",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic
                    ),
                  ),
                  Text(
                    "6 items",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 175, 172, 172)),
                  ),
                ],
              ),
            ),

            Expanded(
              flex: 6,
              child: ListView.builder(
                itemCount: _expenses.length,
                itemBuilder: (context, index) {
                  return ExpenseCard(child: _expenses[index]);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("add expense");
      },
      child: Icon(Icons.add),
      tooltip: 'Add Expense',
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
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 18.0),
          // child: SvgPicture.asset(
          //   'assets/icons/two-dots.svg',
          //   height: 20,
          //   width: 20,
          // ),
          child: Icon(Icons.filter_list)
        ),
      ],
      elevation: 4.0,
      backgroundColor: Colors.green[400],
      toolbarHeight: 60,
    );
  }
}
