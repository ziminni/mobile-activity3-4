import 'package:flutter/material.dart';

class ExpenseCard extends StatelessWidget {
  const ExpenseCard({required this.child, super.key});

  final String child;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        height: 80,
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
                      Icons.abc,
                      size: 40,
                    ),
                  ),
                  SizedBox(width: 10,),
              
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Transportation",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      SizedBox(height: 4,),
              
                      Text(
                        "09-08-2026",
                        style: TextStyle(
                          fontSize: 10
                        ),
                      )
                    ],
                  ),
                ]
              ),

              Text(
                "+ ₱30.0",
                style: TextStyle(
                  fontSize: 14,
                  color: const Color.fromARGB(255, 247, 74, 74)
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}
