import 'package:budgettrack/pages/homePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  //variable to store the user selected currency
  String currencySymbol = '';

  //get the user selected currency from firestore
  Future<String> getCurrncySymbol() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    email = user!.email!;
    if (user != null) {
      QuerySnapshot qs = await FirebaseFirestore.instance.collection(
          //the query check wither the authentication email match with the email which is taken at the user details
          'userDetails').where('email', isEqualTo: email).limit(1).get();

      if (qs.docs.isNotEmpty) {
        // Loop through the documents to find the one with the matching email
        for (QueryDocumentSnapshot doc in qs.docs) {
          if (doc.get('email') == email) {
            // Get the 'username' field from the matching document
            currencySymbol = doc.get('currency');
            print(currencySymbol);
            if (currencySymbol == 'SLR') {
              currencySymbol = 'Rs.';
            } else if (currencySymbol == 'USD') {
              currencySymbol = '\$';
            } else if (currencySymbol == 'EUR') {
              currencySymbol = '€';
            } else if (currencySymbol == 'INR') {
              currencySymbol = '₹';
            } else if (currencySymbol == 'GBP') {
              currencySymbol = '£';
            } else if (currencySymbol == 'AUD') {
              currencySymbol = 'A\$';
            } else if (currencySymbol == 'CAD') {
              currencySymbol = 'C\$';
            }

            return currencySymbol; //return the currency
          }
        }
      }
      // Handle the case when no matching documents are found for the current user
      print('No matching document found for the current user.');
      return ''; // Return an empty string or null based on your requirements
    } else {
      // Handle the case when the user is not authenticated
      print('User not authenticated.');
      return ''; // Return an empty string or null based on your requirements
    }
  }

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
void staterecon()async{
    final currency=await getCurrncySymbol();
    setState(() {
      currencySymbol=currency;
    });

}
  @override
  void initState() {
    super.initState();
    getTotalSpent();
    staterecon();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      child: Container(
        width:400,
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
            width:400,
            color: Color(0xFFEEEEEE),
            height: 100,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width:120,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.category!,
                              style: const TextStyle(
                                fontFamily:
                                'Lexend-VariableFont',
                                color: Color(0xFF090950),
                                fontSize:20,
                              ),
                            ),

                            Text(
                              //remaining days
                              widget.endDate!.isBefore(DateTime.now())
                                  ? '0 days left'
                                  : '${widget.endDate!.difference(DateTime.now()).inDays} days left',
                              style: const TextStyle(
                                fontFamily:
                                'Lexend-VariableFont',
                                color:Color(0xFF5C6C84),
                                fontSize:16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width:5),
                    SizedBox(
                      width: 140,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            //amount with symbol
                            "$currencySymbol${widget.amount.toStringAsFixed(2)}",
                            style: const TextStyle(
                              color: Color(0xFF316F9B),
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 5),
                          (widget.amount - totalSpent)<=0?Text(

                            "You reach target value",
                            style: const TextStyle(
                              color:Color(0xFF090950),
                              fontSize:12,
                            ),
                          )
                              :Text(

                            "$currencySymbol${widget.amount - totalSpent}",
                            style: const TextStyle(
                              fontFamily:
                              'Lexend-VariableFont',
                              color: Color(0xFF3AC6D5),
                              fontSize:16,
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:20.0),
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
                              double progress = maxProgress - (totalAmount / widget.amount);
                              progress = progress.clamp(0.0, maxProgress);

                              Color progressColor;
                              if (progress >= 0.5) {
                                progressColor = Color(0xFF090950);
                              } else if (progress >= 0.2) {
                                progressColor = Color(0xFF090950);
                              } else {
                                progressColor = Color(0xFF090950);
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
                                    fontFamily:
                                    'Lexend-VariableFont',
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
      ),
    );
  }
}
