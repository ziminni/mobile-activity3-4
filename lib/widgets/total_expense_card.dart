import 'package:flutter/material.dart';

class TotalExpenseCard extends StatelessWidget {
  const TotalExpenseCard({required this.totalAmount, super.key});

  final double totalAmount;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: Colors.black,
        border: Border.all(color: Colors.green, width: 2.0),
        borderRadius: BorderRadius.circular(17),
      ),

      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Total expenses:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),

            Text(
              "₱${totalAmount.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ),
    );
  }
}
