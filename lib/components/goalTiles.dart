import 'package:flutter/material.dart';

class MyGoal extends StatefulWidget {
  final String? category;
  final int amount;
  final DateTime? startDate;
  final DateTime? endDate;
  //final String? currency;

  const MyGoal({
    super.key,
    required this.category,
    required this.amount,
    required this.startDate,
    required this.endDate,
    //required this.currency,
  });

  @override
  State<MyGoal> createState() => _MyGoalState();
}

class _MyGoalState extends State<MyGoal> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: Colors.grey[300],
          height: 100,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Row(
              children: [
                // text and amount
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.category!,
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      "${widget.amount}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 40,
                      ),
                    )
                  ],
                ),

                //circular indicator
              ],
            ),
          ),
        ),
      ),
    );
  }
}
