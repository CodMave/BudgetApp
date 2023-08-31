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
  int totalBalance = 0;
  Future<double> getPercentage(String userId) async {
    try {
      int totalIncome = await calculateTotalIncome(userId);
      int totalExpence = await getTotalExpence(userId);

      totalBalance = totalIncome - totalExpence;

      double maxProgress = 1.0;
      double progress = maxProgress - (totalExpence / totalIncome);
      progress = progress.clamp(0.0, maxProgress);
      return progress;
    } catch (ex) {
      print('calculating percentage failed');
      return 0.0;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.grey[200],
          title: FutureBuilder(
            future: getUsername(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Text(
                  'Hi, $username',
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                );
              } else {
                return const Text(
                  'Welcome',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                );
              }
            },
          ),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Check()),
              );
            },
            icon: const Icon(
              Icons.menu,
              color: Colors.black,
              size: 35,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              //circular indicator
              Container(
                color: Colors.grey[200],
                height: 300,
                width: 420,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade200,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 10,
                        spreadRadius: 5,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: FutureBuilder<double>(
                      future:
                          getPercentage(FirebaseAuth.instance.currentUser!.uid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        Color progressColor;
                        if (snapshot.data! >= 0.5) {
                          progressColor = Colors.green;
                        } else if (snapshot.data! >= 0.2) {
                          progressColor = Colors.yellow;
                        } else {
                          progressColor = Colors.red;
                        }

                        Color backgroundColor;
                        if (snapshot.data! >= 0.5) {
                          backgroundColor = Colors.green[100]!;
                        } else if (snapshot.data! >= 0.2) {
                          backgroundColor = Colors.yellow[100]!;
                        } else {
                          backgroundColor = Colors.red[100]!;
                        }

                        return CircularPercentIndicator(
                          radius: 115,
                          lineWidth: 15,
                          percent: snapshot.data!,
                          progressColor: progressColor,
                          backgroundColor: backgroundColor,
                          circularStrokeCap: CircularStrokeCap.round,
                          center: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(50),
                              child: Column(
                                children: [
                                  Text(
                                    DateFormat('MMMM dd')
                                        .format(DateTime.now()),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  // remaining percentage
                                  Text(
                                    '${(snapshot.data! * 100).toInt()}%',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 65,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Text(
                                    'Remaining',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              //Blance card

              Container(
                height: 220,
                width: 380,
                //color: Colors.black,
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.all(10),
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
                              color: Color.fromARGB(255, 107, 149, 170),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Rs. $totalBalance',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
