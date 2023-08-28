import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/bottomNav.dart';
import 'homePage.dart';

class Savings extends StatefulWidget {
  int balance = 0;
  Savings({Key? key, required int balance}) : super(key: key) {
    this.balance = balance;
  }

  @override
  State<Savings> createState() => _SavingsState(
    savingbalance: balance,
  );
}

String documentId = '';

class _SavingsState extends State<Savings> {
  SharedPreferences? _prefs;
  String? selectedyear = "23";
  int savingbalance=0;

  DateTime now=DateTime.now();


  final items = [
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30',
    '32',
    '33',
    '34',
    '35',
    '36',
    '37',
    '38',
    '39',
    '40',
    '41',
    '42',
    '43',
    '44',
    '45',
    '46',
    '47',
    '48',
    '49',
    '50',
    // ADD MORE
  ];
  // Default time: 12:00

  _SavingsState({required this.savingbalance});

  DateTime lastDate = DateTime.now();
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  void initState() {
    super.initState();
    loadYear();
    loadLastMonth();
    updateBalance();
  }

  Future<List> getthebalancefromDB(String year) async {
    List<int> currentBalance = [];
    User? user = _auth
        .currentUser; //created an instance to the User of Firebase authorized
    username = user!.uid;

    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final incomeSnapshot = await firestore
          .collection('userDetails')
          .doc(username)
          .collection('Savings')
          .where('Year', isEqualTo: int.parse(year))
          .get();

      incomeSnapshot.docs.forEach((cDoc) {
        currentBalance.add(cDoc.get('Balance'));
      });

      return currentBalance;
    } catch (ex) {
      print('calculating total balance failed');
      return [];
    }
  }


  Future<DateTime> loadLastMonth() async {
    _prefs = await SharedPreferences.getInstance();
    final storedMonth = _prefs?.getString('lastMonth');

    if (storedMonth != null) {
      return DateFormat('MMMM').parse(storedMonth);
    } else {
      // No stored date, use the current date
      return DateTime(now.month);
    }
  }

  Future<void> saveLastMonth(DateTime Month) async {
    final formattedMonth = DateFormat('MMMM').format(Month);
    _prefs = await SharedPreferences.getInstance();
    _prefs?.setString('lastMonth', formattedMonth);
  }
  Future<void> updateBalance() async {

    final currentMonth = DateTime.now();


    // Update the balance for the current month
    try {
      final existingEntry = await getExistingEntry(
          DateFormat('MMMM').format(currentMonth), int.parse(selectedyear!));

      if (existingEntry != null) {
        final FirebaseFirestore firestore = FirebaseFirestore.instance;

        final DocumentReference documentReference = firestore
            .collection('userDetails')
            .doc(username)
            .collection('Savings')
            .doc(existingEntry);

        // Use the update method to update the "Balance" field
        await documentReference.update({
          'Balance': savingbalance,
        });

        print('Balance updated successfully!');
      } else {
        // No entry for the current month, add a new one
        documentId = await addSavingsToFireStore(
          savingbalance,
          // await loadbalance(),
          DateFormat('MMMM').format(currentMonth),
          int.parse(selectedyear!),
        ).toString();
      }
    } catch (ex) {
      print('Error updating balance: $ex');
    }
    await saveLastMonth(currentMonth);
    setState(() {});
  }


  Future<String?> getExistingEntry(String month, int year) async {
    User? user = _auth.currentUser;
    String username = user!.uid;

    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      final QuerySnapshot querySnapshot = await firestore
          .collection('userDetails')
          .doc(username)
          .collection('Savings')
          .where('Month', isEqualTo: month)
          .where('Year', isEqualTo: year)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Return the document ID of the existing entry
        return querySnapshot.docs.first.id;
      } else {
        // No entry found
        return null;
      }
    } catch (ex) {
      print('Error getting existing entry: $ex');
      return null;
    }
  }


  Future<int> loadYear() async {
    _prefs = await SharedPreferences.getInstance();
    final selectedYear = _prefs?.getString('selectedYear');
    if (selectedYear != null && items.contains(selectedYear)) {
      setState(() {
        selectedyear = selectedYear;
      });
    }

    return int.parse(selectedyear!);
  }

  Future<void> saveBalance() async {
    if (savingbalance != 0) {

      await saveLastMonth(DateTime.now());
    }
  }

  Future<String> addSavingsToFireStore(
      int balance,
      String Day,
      int year,
      ) async {
    User? user = _auth.currentUser;
    String username = user!.uid;

    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      final CollectionReference incomeCollection = firestore
          .collection('userDetails')
          .doc(username)
          .collection('Savings');

      final DocumentReference newDocument = await incomeCollection.add({
        'Balance': balance,
        'Month': Day,
        'Year': year,
      });

      final String newDocumentId = newDocument.id;
      print('New document created with ID: $newDocumentId');

      return newDocumentId;
    } catch (ex) {
      print('Income adding failed: $ex');
      return ''; // Return an empty string to indicate failure
    }
  }

  @override
  Widget build(BuildContext context) {
    DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
      value: item,
      child: Text(
        item,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 60),
      ),
    );
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.grey[100],
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            },
          ),
          title: const Text('S A V I N G S',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 20,
              )),
          centerTitle: true,
          elevation: 0,
        ),
        //bottomNavigationBar: BottomNavigation(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                //alignment: Alignment.center,
                margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                height: 700,
                width: 400,
                decoration: BoxDecoration(
                  color: const Color(0xff86D5FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 20, left: 80),
                          height: 80,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(
                            child: Text(
                              '20',
                              style: TextStyle(
                                fontSize: 60,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20, left: 5),
                          height: 80,
                          width: 115,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: DropdownButton<String>(
                              value: selectedyear,
                              onChanged: (String? newValue) async {
                                setState(() {
                                  selectedyear = newValue!;
                                });
                                _prefs?.setString(
                                    'selectedYear', selectedyear!);
                              },
                              underline: Container(),
                              //isExpanded: true, // Make the dropdown list take up the maximum available height
                              itemHeight: 70,

                              items: items.map(buildMenuItem).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      height: 580,
                      width: 320,
                      decoration: BoxDecoration(
                        color: Color(0xff90E0EF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: FutureBuilder<List>(
                        future: getthebalancefromDB(selectedyear!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text(
                              'Fetching balance...',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.white),
                            );
                          } else if (snapshot.hasError) {
                            return Text(
                              'Error: ${snapshot.error}',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.white),
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data?.isEmpty == true) {
                            return const Text(
                              'No data available.',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.white),
                            );
                          } else {
                            final balanceList = snapshot.data!;
                            return RefreshIndicator(
                              // Use RefreshIndicator to enable manual refresh
                              onRefresh: () async {
                                // Implement the refresh logic (e.g., fetch updated data)
                                await updateBalance();
                              },
                              child: ListView.builder(
                                itemCount: balanceList.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Container(
                                      margin:EdgeInsets.only(top:10),
                                      width: 100,
                                      height: 60,
                                      decoration: BoxDecoration(

                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: EdgeInsets.all(10.0),
                                      child: Row(
                                        children: [

                                          Text(
                                            '${DateFormat('MMMM').format(DateTime.now())}',

                                            style: TextStyle(fontSize:20, color: Colors.black,fontWeight:FontWeight.bold),
                                          ),
                                          Container(
                                            margin:EdgeInsets.only(left:50),
                                            width: 140,
                                            height:80,
                                            decoration: BoxDecoration(
                                              color: Colors.lightBlue,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: Text(

                                                '\$ ${balanceList[index]}',

                                                style: TextStyle(fontSize:20, color: Colors.black,fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
