import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:percent_indicator/percent_indicator.dart'; // Import Firestore

class MyGoal extends StatefulWidget {
  final String userId;
  final String? category;
  final int amount;
  final DateTime? startDate;
  final DateTime? endDate;
  final String currencySymbol;

  const MyGoal({
    Key? key,
    required this.userId,
    required this.category,
    required this.amount,
    required this.startDate,
    required this.endDate,
    required this.currencySymbol,
  }) : super(key: key);

  @override
  State<MyGoal> createState() => _MyGoalState();
}

class _MyGoalState extends State<MyGoal> {
  Map<String, double> categoryProgress = {}; // Store category progress values

  late int totalSpent = 0;

  //get toatl spent from firestore by categories
  Future<void> getTotalSpent() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('userDetails')
        .doc(widget.userId)
        .collection('expenceID')
        .where('transactionName', isEqualTo: widget.category)
        .where('timestamp', isGreaterThanOrEqualTo: widget.startDate)
        .where('timestamp', isLessThanOrEqualTo: widget.endDate)
        .get();

    double totalAmount = 0;
    querySnapshot.docs.forEach((expenseDoc) {
      int transactionAmount = expenseDoc['transactionAmount'];
      totalAmount += transactionAmount.toDouble();
    });

    setState(() {
      totalSpent = totalAmount.toInt();
    });
  }

  @override
  void initState() {
    super.initState();
    getTotalSpent();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 5,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            color: Color(0xFFEEEEEE),
            height: 100,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.category!,
                        style: const TextStyle(
                          fontFamily: 'Lexend-VariableFont',
                          color: Color(0xFF090950),
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        //remaining days
                        "${widget.endDate!.difference(DateTime.now()).inDays} days left",
                        style: const TextStyle(
                          fontFamily: 'Lexend-VariableFont',
                          color: Color.fromARGB(255, 4, 34, 59),
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 15),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        //amount with symbol
                        "${widget.currencySymbol} ${widget.amount}",
                        style: const TextStyle(
                          fontFamily: 'Lexend-VariableFont',
                          color: Color(0xFF316F9B),
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        //amount left
                        "${widget.currencySymbol} ${widget.amount - totalSpent} left",
                        style: const TextStyle(
                          fontFamily: 'Lexend-VariableFont',
                          color: Color(0xFF3AC6D5),
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
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
                              progressColor = Color(0xFF85B6FF);
                            } else if (progress >= 0.2) {
                              progressColor = Color(0xFF85B6FF);
                            } else {
                              progressColor = Color(0xFF85B6FF);
                            }

                            Color backgroundColor;
                            if (progress >= 0.5) {
                              backgroundColor = Colors.white54;
                            } else if (progress >= 0.2) {
                              backgroundColor = Colors.white54;
                            } else {
                              backgroundColor = Colors.white54;
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
                                  fontFamily: 'Lexend-VariableFont',
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}