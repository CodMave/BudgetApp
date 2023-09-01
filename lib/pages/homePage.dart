import 'package:budgettrack/pages/Profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = '';
  double finalTotalIncome = 0.0;
  double finalTotalExpense = 0.0;
  double percentage = 0.0;
  int totalBalance = 0;
  String userSelectedCurrency = '';
  String currencySymbol = '';

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

    return totalBalance;
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

  //method to get the percentage
  Future<double> getPercentage(String userId) async {
    try {
      int totalIncome = await calculateTotalIncome(userId);
      int totalExpence = await getTotalExpence(userId);

      double maxProgress = 1.0;
      double progress = maxProgress - (totalExpence / totalIncome);
      progress = progress.clamp(0.0, maxProgress);
      return progress;
    } catch (ex) {
      print('calculating percentage failed');
      return 0.0;
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
                    Icons.menu,
                    color: Colors.grey.shade300,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(top: 5),
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
              Container(
                height: 220,
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 25, 86, 143),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    )),
              ),
              SizedBox(
                height: 220,
                width: 380,
                //color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade100,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade400,
                          blurRadius: 10,
                          spreadRadius: 5,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 140,
                          width: 380,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 25, 86, 143),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '$currencySymbol $totalBalance',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Balance',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(
                                Icons.account_balance_wallet,
                                size: 35,
                              ),
                            ],
                          ),
                        )
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
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
                        child: Row(
                          children: [
                            Container(
                              height: 120,
                              width: 200,
                              decoration: BoxDecoration(
                                color: Colors.blueGrey.shade100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: 80,
                                    width: 200,
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 107, 149, 170),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            Container(
                              height: 120,
                              width: 165,
                              decoration: BoxDecoration(
                                color: Colors.blueGrey.shade100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: 80,
                                    width: 165,
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 107, 149, 170),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                  )
                                ],
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
        ));
  }
}
