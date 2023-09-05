import 'package:budgettrack/pages/Profile.dart';
import 'package:budgettrack/pages/goals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'Savings.dart';
import 'expenceAndIncome.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = '';
  int? totalBalance;
  String userSelectedCurrency = '';
  String currencySymbol = '';
  double? goalPercentage;

  //get username from the firestore
  Future<String> getUsername() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      var email = user.email!;

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('userDetails')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        username = doc.get('username');
      }
    }

    return username;
  }

  //get the user selected currency from firestore
  Future<String> getUserSelectedCurrency() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      var email = user.email!;

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('userDetails')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        userSelectedCurrency = doc.get('currency');
        currencySymbolAssign(userSelectedCurrency);
        print('user selected currency is $userSelectedCurrency');
      }
    }

    print('user selected currency is $userSelectedCurrency');
    return userSelectedCurrency;
  }

  //method to calculate the total balance
  Future<int> getTotalBalance(String userId) async {
    double totalIncome = (await calculateTotalIncome(userId)).toDouble();
    double totalExpence = (await getTotalExpence(userId)).toDouble();

    int balance = (totalIncome - totalExpence).toInt();

    setState(() {
      totalBalance = balance;
    });

    return totalBalance!;
  }

  //method to calculate the total remaining goals percentage for the month
  Future<double> getTotalGoalsPercent(String userId) async {
    //var date = DateTime.now();
    DateTime now = DateTime.now();
    int currentYear = now.year;
    int currentMonth = now.month;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    final goalsQuery = await firestore
        .collection('userDetails')
        .doc(userId)
        .collection('goalsID')
        .where('timestamp',
            isGreaterThanOrEqualTo:
                Timestamp.fromDate(DateTime(currentYear, currentMonth, 1)),
            isLessThan:
                Timestamp.fromDate(DateTime(currentYear, currentMonth + 1, 1)))
        .get();

    int totalGoalsAmount = 0;
    goalsQuery.docs.forEach((goalsDoc) {
      totalGoalsAmount += (goalsDoc.get('amount') as num).toInt();
    });

    final monthExpenceSnapshot = await firestore
        .collection('userDetails')
        .doc(userId)
        .collection('expenceID')
        .where('timestamp',
            isGreaterThanOrEqualTo:
                Timestamp.fromDate(DateTime(currentYear, currentMonth, 1)),
            isLessThan:
                Timestamp.fromDate(DateTime(currentYear, currentMonth + 1, 1)))
        .get();

    int totalMonthExpence = 0;
    monthExpenceSnapshot.docs.forEach((expenceDoc) {
      totalMonthExpence += (expenceDoc.get('transactionAmount') as num).toInt();
    });

    int totalGoalsAmountLeft = totalGoalsAmount - totalMonthExpence;
    print('total goals amount left is $totalGoalsAmountLeft');
    //double maxProgress = 1.0;
    double percentage = (totalGoalsAmountLeft / totalGoalsAmount);
    //percentage = percentage.clamp(0.0, maxProgress);
    print('percentage before passing is $percentage');

    return percentage;
  }

  //method to get the total remaing goals amount from firestore
  Future<int> getTotalGoalsAmountLeft(String userId) async {
    DateTime now = DateTime.now();
    int currentYear = now.year;
    int currentMonth = now.month;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    final goalsQuery = await firestore
        .collection('userDetails')
        .doc(userId)
        .collection('goalsID')
        .where('timestamp',
            isGreaterThanOrEqualTo:
                Timestamp.fromDate(DateTime(currentYear, currentMonth, 1)),
            isLessThan:
                Timestamp.fromDate(DateTime(currentYear, currentMonth + 1, 1)))
        .get();

    int totalGoalsAmount = 0;
    goalsQuery.docs.forEach((goalsDoc) {
      totalGoalsAmount += (goalsDoc.get('amount') as num).toInt();
    });

    final monthExpenceSnapshot = await firestore
        .collection('userDetails')
        .doc(userId)
        .collection('expenceID')
        .where('timestamp',
            isGreaterThanOrEqualTo:
                Timestamp.fromDate(DateTime(currentYear, currentMonth, 1)),
            isLessThan:
                Timestamp.fromDate(DateTime(currentYear, currentMonth + 1, 1)))
        .get();

    int totalMonthExpence = 0;
    monthExpenceSnapshot.docs.forEach((expenceDoc) {
      totalMonthExpence += (expenceDoc.get('transactionAmount') as num).toInt();
    });

    int totalGoalsAmountLeft = totalGoalsAmount - totalMonthExpence;

    return totalGoalsAmountLeft;
  }

  //method to get the total income from firestore
  Future<int> calculateTotalIncome(String userId) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final incomeSnapshot = await firestore
          .collection('userDetails')
          .doc(userId)
          .collection('incomeID')
          .get();

      int totalIncome = 0;
      incomeSnapshot.docs.forEach((incomeDoc) {
        totalIncome += (incomeDoc.get('transactionAmount') as num).toInt();
      });

      return totalIncome;
    } catch (ex) {
      print('calculating total income failed');
      return 0;
    }
  }

  //method to get total expense from firestore
  Future<int> getTotalExpence(String userId) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final expenceSnapshot = await firestore
          .collection('userDetails')
          .doc(userId)
          .collection('expenceID')
          .get();

      int totalExpence = 0;
      expenceSnapshot.docs.forEach((expenceDoc) {
        totalExpence += (expenceDoc.get('transactionAmount') as num).toInt();
      });

      return totalExpence;
    } catch (ex) {
      print('calculating total expence failed');
      return 0;
    }
  }

  void currencySymbolAssign(String userSelecterCurrency) {
    if (userSelecterCurrency == 'USD') {
      currencySymbol = '\$';
    } else if (userSelecterCurrency == 'EUR') {
      currencySymbol = '€';
    } else if (userSelecterCurrency == 'INR') {
      currencySymbol = '₹';
    } else if (userSelecterCurrency == 'SLR') {
      currencySymbol = 'Rs';
    } else if (userSelecterCurrency == 'GBP') {
      currencySymbol = '£';
    } else if (userSelecterCurrency == 'AUD') {
      currencySymbol = 'A\$';
    } else if (userSelecterCurrency == 'CAD') {
      currencySymbol = 'C\$';
    }
  }

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print('completed');
      setState(() {});
    });

    //get the username
    getUsername();

    //get the user selected currency
    getUserSelectedCurrency();

    //get the total balance
    getTotalBalance(FirebaseAuth.instance.currentUser!.uid);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 25, 86, 143),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 0),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Check()),
                    );
                  },
                  icon: Icon(
                    Icons.account_circle_outlined,
                    color: Colors.grey.shade300,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: FutureBuilder(
                  future: getUsername(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Text(
                        'Hi, $username',
                        style: TextStyle(
                          color: Colors.grey.shade300,
                          fontSize: 30,
                        ),
                      );
                    } else {
                      return Text(
                        'Welcome',
                        style: TextStyle(
                          color: Colors.grey.shade300,
                          fontSize: 30,
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          //centerTitle: true,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              //card to show the total balance
              Container(
                height: 220,
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 25, 86, 143),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    )),
                child: Padding(
                  padding: const EdgeInsets.only(top: 60, left: 27),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Current Balace',
                        style: TextStyle(
                          color: Colors.grey.shade300,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        '$currencySymbol$totalBalance',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 70,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              //card to show the remaining goals amout
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  height: 180,
                  width: 400,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Monthly Plan Remaining',
                              style: TextStyle(
                                color: Colors.grey.shade800,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Goals()),
                                );
                              },
                              child: Icon(
                                Icons.arrow_forward,
                                color: Colors.grey.shade800,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        //remaining goals amount
                        FutureBuilder(
                          future: getTotalGoalsAmountLeft(
                              FirebaseAuth.instance.currentUser!.uid),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return Text(
                                '$currencySymbol${snapshot.data}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                        ),

                        const SizedBox(height: 15),

                        FutureBuilder(
                          future: getTotalGoalsPercent(
                              FirebaseAuth.instance.currentUser!.uid),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              Color progressColor;

                              goalPercentage = snapshot.data;

                              print('goal percentage is $goalPercentage');
                              if (goalPercentage! >= 0.5) {
                                progressColor = Colors.green;
                              } else if (goalPercentage! >= 0.2) {
                                progressColor = Colors.yellow;
                              } else {
                                progressColor = Colors.red;
                              }

                              Color progressBackgroundColor;
                              if (goalPercentage! >= 0.5) {
                                progressBackgroundColor = Colors.green.shade100;
                              } else if (goalPercentage! >= 0.2) {
                                progressBackgroundColor =
                                    Colors.yellow.shade100;
                              } else {
                                progressBackgroundColor = Colors.red.shade100;
                              }

                              return LinearPercentIndicator(
                                animation: true,
                                animationDuration: 800,
                                width: 360,
                                lineHeight: 35,
                                percent: goalPercentage!,
                                backgroundColor: progressBackgroundColor,
                                progressColor: progressColor,
                                center: Text(
                                  '${(snapshot.data! * 100).toInt()}%',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                barRadius: const Radius.circular(20),
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              //card to move to expnece and savings page
              Container(
                //color: Colors.grey.shade100,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Featured',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 120,
                                  width: 210,
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey.shade100,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              'Add New',
                                              style: TextStyle(
                                                color: Colors.grey.shade800,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Expence(
                                                            notificationList: [],
                                                            nume: 0,
                                                            //onDeleteNotification:
                                                            //onDeleteNotification
                                                          )),
                                                );
                                              },
                                              child: Icon(
                                                Icons.arrow_forward,
                                                color: Colors.grey.shade800,
                                                size: 30,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 50,
                                              height: 50,
                                              margin: const EdgeInsets.only(
                                                  left: 20, top: 10),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors.grey.shade800,
                                                  width: 1,
                                                ),
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.grey.shade100,
                                                ),
                                                child: IconButton(
                                                  icon: const Icon(
                                                    FontAwesomeIcons.car,
                                                    size: 30,
                                                    color: Colors.black,
                                                  ),
                                                  onPressed: () {},
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Container(
                                              width: 50,
                                              height: 50,
                                              margin: const EdgeInsets.only(
                                                  left: 3, top: 10),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors.grey.shade800,
                                                  width: 1,
                                                ),
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.grey.shade100,
                                                ),
                                                child: IconButton(
                                                  icon: const Icon(
                                                    FontAwesomeIcons.burger,
                                                    size: 30,
                                                    color: Colors.black,
                                                  ),
                                                  onPressed: () {},
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Container(
                                              width: 50,
                                              height: 50,
                                              margin: const EdgeInsets.only(
                                                  left: 3, top: 10),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors.grey.shade800,
                                                  width: 1,
                                                ),
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.grey.shade100,
                                                ),
                                                child: IconButton(
                                                  icon: const Icon(
                                                    FontAwesomeIcons.plus,
                                                    size: 30,
                                                    color: Colors.black,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Expence(
                                                                notificationList: [],
                                                                nume: 0,
                                                                //onDeleteNotification:
                                                                //onDeleteNotification,
                                                              )),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  height: 120,
                                  width: 170,
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey.shade100,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              'Savings',
                                              style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.grey.shade800,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        Savings(
                                                            balance:
                                                                totalBalance!),
                                                  ),
                                                );
                                              },
                                              child: Icon(
                                                Icons.arrow_forward,
                                                size: 30,
                                                color: Colors.grey.shade800,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 22, top: 3),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 50,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: Colors.grey.shade800,
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.grey.shade100,
                                                  ),
                                                  child: IconButton(
                                                    icon: const Icon(
                                                      FontAwesomeIcons.wallet,
                                                      size: 30,
                                                      color: Colors.black,
                                                    ),
                                                    onPressed: () {},
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Container(
                                                height: 50,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: Colors.grey.shade800,
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.grey.shade100,
                                                  ),
                                                  child: IconButton(
                                                    icon: const Icon(
                                                      FontAwesomeIcons.plus,
                                                      size: 30,
                                                      color: Colors.black,
                                                    ),
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              Savings(
                                                                  balance:
                                                                      totalBalance!),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
