import 'package:flutter/material.dart';

class CategoriesCard extends StatelessWidget {
  const CategoriesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          // color: Colors.black,
          border: Border.all(color: Colors.green, width: 2.0),
          borderRadius: BorderRadius.circular(17),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Transportation", style: TextStyle(fontSize: 11)),
            Text("__________"),
            Text("₱00.00"),
          ],
        ),
      ),
    );
  }
}
