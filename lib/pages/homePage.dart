import 'package:budgettrack/pages/Profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.grey[100],
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
                color: Colors.grey[300],
                height: 280,
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        blurRadius: 10,
                        spreadRadius: 5,
                        offset: const Offset(5, 0),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(25),
                        child: FutureBuilder<double>(
                          future: getPercentage(
                              FirebaseAuth.instance.currentUser!.uid),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }

                            return CircularPercentIndicator(
                              radius: 100,
                              lineWidth: 15,
                              percent: snapshot.data!,
                              progressColor: Colors.blue,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
