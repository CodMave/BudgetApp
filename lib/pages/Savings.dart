import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  int savingbalance = 0;
  String monthname = '';
  DateTime now = DateTime.now();
  List<dynamic> mon = [];
  String username = '';
  double percentage1 = 0.0;

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
    updateBalance();
    saveSelectedMonth('Last Month');
  }

  void saveSelectedMonth(String selectedMonth) {
    _prefs?.setString('selectedMonth', selectedMonth);
  }

  String getSelectedMonth() {
    return _prefs?.getString('selectedMonth') ?? 'Last Month';
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
        currentBalance.insert(0, cDoc.get('Balance'));
      });

      return currentBalance;
    } catch (ex) {
      print('calculating total balance failed');
      return [];
    }
  }

  Future<List> gettheMonthfromDB(String year) async {
    List<String> currentMonth = [];
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

      incomeSnapshot.docs.forEach((dDoc) {
        currentMonth.insert(0, dDoc.get('Month'));
      });

      return currentMonth;
    } catch (ex) {
      print('Getting the month failed');
      return [];
    }
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
          DateFormat('MMMM').format(currentMonth),
          int.parse(selectedyear!),
        ).toString();
      }
    } catch (ex) {
      print('Error updating balance: $ex');
    }
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
          actions: [
            Icon(
              CupertinoIcons.money_dollar_circle,
              size: 30,
              color: Color(0xFF3AC6D5),
            ),
          ],
          title: const Text('S A V I N G S',
              style: TextStyle(
                color: const Color(0xFF090950),
                fontSize: 20,
                fontFamily: 'Lexend-VariableFont',
              )),
          centerTitle: true,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Divider(
                // Add a Divider here
                height: 3, // You can adjust the height of the divider
                thickness: 1, // You can adjust the thickness of the divider
                color: Colors.grey, // You can set the color of the divider
              ),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: 20,
                    ),
                    height: 40,
                    width: 130,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween, // Adjust alignment as needed
                            children: [
                              Text(
                                '20',
                                style: TextStyle(
                                  fontFamily: 'Lexend-VariableFont',
                                  fontSize: 20,
                                  color: Colors.black,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                              VerticalDivider(
                                width: 10,
                                color: Colors.black,
                              ),
                              DropdownButton<String>(
                                value: selectedyear,
                                onChanged: (String? newValue) async {
                                  setState(() {
                                    selectedyear = newValue!;
                                  });
                                  _prefs?.setString(
                                      'selectedYear', selectedyear!);
                                },
                                underline: Container(),
                                itemHeight:
                                    70, // Adjust the item height as needed
                                items: items.map((String item) {
                                  return DropdownMenuItem<String>(
                                    value: item,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              0), // Adjust the padding as needed
                                      child: Text(
                                        item,
                                        style: TextStyle(
                                          fontFamily: 'Lexend-VariableFont',
                                          fontSize:
                                              20, // Adjust the font size as needed
                                          // Add more styling properties here if desired
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    height: 400,
                    width: 350,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.8),
                            spreadRadius: 5,
                            blurRadius: 10,
                            offset: Offset(0, 10),
                          ),
                        ]),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15.0, left: 10),
                            child: Text('$monthname',
                                style: TextStyle(
                                  fontFamily: 'Lexend-VariableFont',
                                  fontSize: 20,
                                  color: const Color(0xFF090950),
                                )),
                          ),
                        ),
                        Container(
                          // Container which carries the percentage indicator
                          height: 240,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 20),
                                width:
                                    200, // Adjust the width and height as needed
                                height: 206,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(
                                        0xFF090950), // Set the border color
                                    width: 3.0, // Set the border width
                                  ),
                                ),

                                child: CircularPercentIndicator(
                                  radius: 100,
                                  lineWidth: 30,
                                  percent: percentage1 + 0.06,
                                  circularStrokeCap: CircularStrokeCap.round,
                                  progressColor:
                                      Color(0xFF3AC6D5), // Progress color
                                  backgroundColor: const Color(0xFFC2DAFF),
                                  animation: true,
                                  animationDuration:
                                      1000, // Start from 12 o'clock
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  margin: EdgeInsets.only(left: 8, top: 50),
                                  width:
                                      10, // Adjust the width and height as needed
                                  height: 10,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF3AC6D5),
                                  ),
                                ),
                              ),
                              FractionallySizedBox(
                                // This is for displaying the current date and time
                                widthFactor: 1.0,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 50.0,
                                        left: 20), // Adjust top padding here
                                    child: Text(
                                      'Savings',
                                      style: const TextStyle(
                                        fontFamily: 'Lexend-VariableFont',
                                        fontSize: 10,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  margin: EdgeInsets.only(left: 8, top: 90),
                                  width:
                                      10, // Adjust the width and height as needed
                                  height: 10,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFFC2DAFF),
                                  ),
                                ),
                              ),
                              const FractionallySizedBox(
                                // This is for displaying 'Expenses' as a word
                                widthFactor: 1.0,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 90.0,
                                        left: 22), // Adjust top padding here
                                    child: Text(
                                      'Expenses',
                                      style: TextStyle(
                                        fontFamily: 'Lexend-VariableFont',
                                        fontSize: 10,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 60),
                          child: Row(
                            children: [
                              Text(
                                'Savings',
                                style: TextStyle(
                                  fontFamily: 'Lexend-VariableFont',
                                  color: const Color(0xFF090950),
                                  fontSize: 20,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 60.0), // Adjust left padding here
                                child: Row(
                                  children: [
                                    Text(
                                      'Rs.',
                                      style: TextStyle(
                                        fontFamily: 'Lexend-VariableFont',
                                        color: const Color(0xFF090950),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${savingbalance}',
                                      style: TextStyle(
                                        fontFamily: 'Lexend-VariableFont',
                                        color: const Color(0xFF090950),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: double.infinity,
                              height: 70,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                color: Color(0xffEEEEEE),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 165,
                                    height: double.infinity,
                                    color: Colors.transparent,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10.0, left: 30),
                                                  child: Icon(
                                                      Icons.add_card_rounded,
                                                      color: const Color(
                                                          0xFF090950)),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10.0, left: 10),
                                                  child: Text(
                                                    'Expense',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Lexend-VariableFont',
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5.0, left: 30.0),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        'Rs.', //curency of income
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Lexend-VariableFont',
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: const Color(
                                                                0xFF090950)),
                                                      ),
                                                      Text(
                                                        '35,000.00', //income value
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Lexend-VariableFont',
                                                            fontSize: 20,
                                                            color: const Color(
                                                                0xFF090950)),
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
                                  ),
                                  VerticalDivider(
                                    width: 10,
                                    color: Colors.black,
                                  ),
                                  Container(
                                    width: 175,
                                    height: double.infinity,
                                    color: Colors.transparent,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 10.0,
                                                    left: 20,
                                                  ),
                                                  child: Icon(
                                                    Icons.add_card_rounded,
                                                    color: Color(0xFF3AC6D5),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10.0, left: 10),
                                                  child: Text(
                                                    'Income',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Lexend-VariableFont',
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5.0, left: 20.0),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        'Rs.', //curency of expense
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Lexend-VariableFont',
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: const Color(
                                                                0xFF090950)),
                                                      ),
                                                      Text(
                                                        '35,000.00', //expense value
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Lexend-VariableFont',
                                                            fontSize: 20,
                                                            color: const Color(
                                                                0xFF090950)),
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
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Divider(
                    // Add a Divider here
                    height: 3, // You can adjust the height of the divider
                    thickness: 1, // You can adjust the thickness of the divider
                    color: Colors.grey, // You can set the color of the divider
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0, left: 30),
                      child: Text('All savings',
                          style: TextStyle(
                            fontFamily: 'Lexend-VariableFont',
                            fontSize: 20,
                            color: const Color(0xFF090950),
                          )),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    height: 320,
                    width: 350,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.8),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: FutureBuilder<List>(
                      future: getthebalancefromDB(selectedyear!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Text(
                            'Error: ${snapshot.error}',
                            style: TextStyle(
                                fontFamily: 'Lexend-VariableFont',
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data?.isEmpty == true) {
                          return Text(
                            'No data available.',
                            style: TextStyle(
                                fontFamily: 'Lexend-VariableFont',
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          );
                        } else {
                          final balanceList = snapshot.data!;
                          return Scrollbar(
                            child: RefreshIndicator(
                              onRefresh: () async {
                                await updateBalance();
                              },
                              child: ListView.builder(
                                itemCount: balanceList.length,
                                itemBuilder: (context, index) {
                                  // String uniqueValue = "Unique Value ${index + 1}";
                                  return Column(
                                    children: [
                                      ListTile(
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  children: [
                                                    FutureBuilder<List>(
                                                      future: gettheMonthfromDB(
                                                          selectedyear!),
                                                      builder:
                                                          (context, snapshot) {
                                                        final MonthList =
                                                            snapshot.data;
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 5.0),
                                                          child: Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              '${MonthList?[index]}',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Lexend-VariableFont',
                                                                color: const Color(
                                                                    0xFF090950),
                                                                fontSize: 15,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Text(
                                                      '\$ ${balanceList[index]}',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontFamily:
                                                            'Lexend-VariableFont',
                                                        color: const Color(
                                                            0xFF3AC6D5),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    // Update the selected month when "View" button is clicked
                                                    setState(() {
                                                      monthname = mon[index];
                                                    });
                                                    // Save the selected month to shared preferences
                                                    saveSelectedMonth(
                                                        monthname);
                                                    print(mon[index]);
                                                  },
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(Colors
                                                                .transparent),
                                                    shape: MaterialStateProperty
                                                        .all<OutlinedBorder>(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30.0),
                                                        side: BorderSide(
                                                            color: const Color(
                                                                0xFFAAB2BE)),
                                                      ),
                                                    ),
                                                    elevation:
                                                        MaterialStateProperty
                                                            .all<double>(0),
                                                  ),
                                                  child: Text(
                                                    'View',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Lexend-VariableFont',
                                                      color: const Color(
                                                          0xFFAAB2BE),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (index < balanceList.length - 1)
                                        Divider(
                                          height: 0,
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
