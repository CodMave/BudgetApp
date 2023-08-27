import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:percent_indicator/percent_indicator.dart'; // Import Firestore

class MyGoal extends StatefulWidget {
  final String userId;
=======

class MyGoal extends StatelessWidget {
>>>>>>> main
  final String? category;
  final int amount;
  final DateTime? startDate;
  final DateTime? endDate;
<<<<<<< HEAD

  const MyGoal({
    Key? key,
    required this.userId,
=======
  //final String? currency;

  const MyGoal({
    super.key,
>>>>>>> main
    required this.category,
    required this.amount,
    required this.startDate,
    required this.endDate,
<<<<<<< HEAD
  }) : super(key: key);

  @override
  State<MyGoal> createState() => _MyGoalState();
}

class _MyGoalState extends State<MyGoal> {
  Map<String, double> categoryProgress = {}; // Store category progress values
=======
  });
>>>>>>> main

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
<<<<<<< HEAD
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.category!,
                      style: TextStyle(
                        color: Colors.grey[800],
=======
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  category!,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "\$",
                      style: const TextStyle(
                        color: Colors.black,
>>>>>>> main
                        fontSize: 20,
                      ),
                    ),
                    Text(
<<<<<<< HEAD
                      "${widget.amount}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 40,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 100),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 60,
                      height: 60,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('userDetails')
                            .doc(widget.userId)
                            .collection('expenceID')
                            .where('transactionName',
                                isEqualTo: widget.category)
                            .where('timestamp',
                                isGreaterThanOrEqualTo: widget.startDate)
                            .where('timestamp',
                                isLessThanOrEqualTo: widget.endDate)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }

                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }

                          double totalAmount = 0;
                          snapshot.data!.docs.forEach((expenseDoc) {
                            int transactionAmount =
                                expenseDoc['transactionAmount'];
                            totalAmount += transactionAmount.toDouble();
                          });

                          double maxProgress = 1.0;
                          double progress =
                              maxProgress - (totalAmount / widget.amount);
                          progress = progress.clamp(0.0, maxProgress);

                          Color progressColor;
                          if (progress >= 0.5) {
                            progressColor = Colors.green;
                          } else if (progress >= 0.2) {
                            progressColor = Colors.yellow;
                          } else {
                            progressColor = Colors.red;
                          }

                          Color backgroundColor;
                          if (progress >= 0.5) {
                            backgroundColor = Colors.green[100]!;
                          } else if (progress >= 0.2) {
                            backgroundColor = Colors.yellow[100]!;
                          } else {
                            backgroundColor = Colors.red[100]!;
                          }

                          return CircularPercentIndicator(
                            animation: true,
                            animationDuration: 1000,
                            radius: 30,
                            lineWidth: 6,
                            percent: progress,
                            progressColor: progressColor,
                            backgroundColor: backgroundColor,
                            circularStrokeCap: CircularStrokeCap.round,
                            center: Text(
                              "${(progress * 100).toInt()}%",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
=======
                      "$amount",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ],
                )
>>>>>>> main
              ],
            ),
          ),
        ),
      ),
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> main
