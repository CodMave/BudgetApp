import 'package:budgettrack/pages/plans.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../components/bottomNav.dart';
import '../components/datePicker.dart';
import 'package:intl/intl.dart';
//import 'addPlanPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../components/goalTiles.dart';
import 'Summery.dart';
import 'TextScanner.dart';
import 'homePage.dart';

class Goals extends StatefulWidget {
  final Function()? onTap;
  const Goals({super.key, this.onTap});

  @override
  _GoalsState createState() => _GoalsState();
}

class _GoalsState extends State<Goals> {
  int amount = 0;
  String? categoty;
  DateTime? startDate;
  DateTime? endDate;
  final planTitleController = TextEditingController();
  final planAmountController = TextEditingController();
  String? userSelectedCurrency;
  late String currencySymbol = '';

  late Stream<DocumentSnapshot<Map<String, dynamic>>> _plansStream;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<MyGoal> myGoals = [];

  String? selectedCategory;
  List<String> expenceCategories = [
    'Food',
    'Shopping',
    'Bills',
    'Entertainment',
    'Health',
    'Education',
    'Donations',
    'Rental',
    'Fuel',
    'Transport',
    'Others',
  ];

  Future<String> getCurrentUser() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;

      return user!.uid;
    } catch (ex) {
      print('current user fetchimg failed in add paln page');
      return '';
    }
  }

  //Method add goals to the database

  Future<void> addGoalsToFirestore(
    String userId,
    String selectedCategory,
    int planAmountController,
    DateTime selectedStartDate,
    DateTime selectedEndDate,
  ) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      final CollectionReference goalsCollection =
          firestore.collection('userDetails').doc(userId).collection('goalsID');

      await goalsCollection.add({
        'amount': planAmountController,
        'category': selectedCategory,
        'endDate': selectedEndDate,
        'startDate': selectedStartDate,
        'timestamp': DateTime.now(),
      });
    } catch (e) {
      print('Goals adding to firestore failed');
    }
  }

  //Function to show the date picker for start date

  Future<void> _selectStartDate(BuildContext context) async {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
    ).then((value) {
      setState(() {
        startDate = value;
      });
    });
  }

  //Function to show the date picker for end date

  Future<void> _selectEndDate(BuildContext context) async {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
    ).then((value) {
      setState(() {
        endDate = value;
      });
    });
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
        currencySymbolAssign(userSelectedCurrency!);
        print('user selected currency is $userSelectedCurrency');
      }
    }

    print('user selected currency is $userSelectedCurrency');
    return userSelectedCurrency!;
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
    String? userId = auth.currentUser?.uid;

    _plansStream = firestore
        .collection('userDetails')
        .doc(userId)
        .collection('goalsID')
        .doc()
        .snapshots();

    _plansStream.listen((DocumentSnapshot<Map<String, dynamic>> snapshot) {
      if (snapshot.exists) {
        setState(() {
          amount = snapshot.data()!['amount'];
          categoty = snapshot.data()!['category'];
          startDate = snapshot.data()!['startDate'];
          endDate = snapshot.data()!['endDate'];
        });
      }
    });

    getUserSelectedCurrency();
  }

  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  void addNewPlan() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Center(
                child: Text(
                  'Create a Goal',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey, // Use the defined formKey here
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //Expence text
                      // const Align(
                      //   alignment: Alignment.centerLeft,
                      //   child: Text(
                      //     'Expence Category',
                      //     style: TextStyle(
                      //       fontSize: 18,
                      //       color: Colors.black,
                      //     ),
                      //   ),
                      // ),

                      const SizedBox(height: 10),

                      //Expence category dropdown

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButton<String>(
                              underline: const SizedBox(),
                              icon: const Icon(Icons.arrow_downward_sharp),
                              hint: const Text(
                                'Select category',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              value: selectedCategory,
                              onChanged: (value) {
                                setState(() {
                                  selectedCategory = value;
                                });
                              },
                              items: expenceCategories
                                  .map<DropdownMenuItem<String>>(
                                (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Row(
                                      // Wrap text and icon in a Row
                                      children: [
                                        Text(value),
                                        const SizedBox(width: 100),
                                        //sconst Icon(Icons.arrow_downward_sharp),
                                      ],
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                        ),
                      ),



                      const SizedBox(height: 10),

                      // plan amount text field

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: planAmountController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Enter Amount',
                                border: InputBorder.none,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter amount';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              readOnly: true,
                              onTap: () => _selectStartDate(context),
                              decoration: InputDecoration(
                                hintText: 'Select start date',
                                border: InputBorder.none,
                                suffixIcon: Icon(Icons.calendar_today),
                              ),
                              controller: TextEditingController(
                                text:startDate != null
                                    ? DateFormat('MMM dd, yyyy').format(startDate!)
                                    : '',
                              ),
                            ),
                          ),
                        ),
                      ),


                      const SizedBox(height: 10),



                      const SizedBox(height: 10),

                      //End Date picker
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              readOnly: true,
                              onTap: () => _selectEndDate(context),
                              decoration: InputDecoration(
                                hintText: 'Select end date',
                                border: InputBorder.none,
                                suffixIcon: Icon(Icons.calendar_today),
                              ),
                              controller: TextEditingController(
                                text: endDate != null
                                    ? DateFormat('MMM dd, yyyy').format(endDate!)
                                    : '',
                              ),
                            ),
                          ),
                        ),
                      ),




                      const SizedBox(height: 25),

                      // Enter and Cancel Buttons

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //Cancel button
                          Container(
                            height: 50,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.black),
                            ),
                            child: TextButton(
                              onPressed: () {
                                //clear user inputs
                                setState(() {
                                  //selectedCategory = '';
                                  planAmountController.clear();
                                  startDate = null;
                                  endDate = null;
                                });
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          //Enter button

                          Container(
                            height: 50,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.black),
                            ),
                            child: TextButton(
                              onPressed: () async {
                                if (selectedCategory == null ||
                                    planAmountController.text.isEmpty ||
                                    startDate == null ||
                                    endDate == null) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Error'),
                                        content: Text('Please fill in all fields.'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  return;
                                }

                                // Check if amount is a valid number
                                if (double.tryParse(planAmountController.text) == null) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Error'),
                                        content: Text('Please enter a valid number for the amount.'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  return;
                                }
                                String? userId = await getCurrentUser();

                                amount = int.parse(planAmountController.text);

                                setState(
                                  () {
                                    myGoals.add(MyGoal(
                                      userId: userId,
                                      category: selectedCategory,
                                      amount: amount,
                                      startDate: startDate,
                                      endDate: endDate,
                                      currencySymbol: currencySymbol,
                                    ));
                                  },
                                );

                                String? selectedCategoryCopy = selectedCategory;

                                Navigator.of(context).pop();

                                setState(() {});

                                //Add the goals to the database

                                print('goal amount is $amount');

                                await addGoalsToFirestore(
                                  userId,
                                  selectedCategoryCopy!,
                                  amount,
                                  startDate!,
                                  endDate!,
                                );

                                _plansStream = firestore
                                    .collection('userDetails')
                                    .doc(userId)
                                    .collection('goalsID')
                                    .doc()
                                    .snapshots();

                                _plansStream.listen(
                                    (DocumentSnapshot<Map<String, dynamic>>
                                        snapshot) {
                                  if (snapshot.exists) {
                                    setState(() {
                                      amount = snapshot.data()!['amount'];
                                      categoty = snapshot.data()!['category'];
                                      startDate = snapshot.data()!['startDate'];
                                      endDate = snapshot.data()!['endDate'];
                                    });
                                  }
                                });

                                //selectedCategory = '';
                                //planAmountController.clear();
                              },
                              child: const Text(
                                'Enter',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        leading: Padding(
          padding: const EdgeInsets.only(left:18),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            color:const Color(0xFF090950),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            },
          ),
        ),
        title:Padding(
          padding: const EdgeInsets.only(left:75.0),
          child: Row(
            children: [

              const Text(
                'G O A L S',
                style: TextStyle(
                  fontFamily: 'Lexend-VariableFont',
                  color: const Color(0xFF090950),
                ),
              ),
              SizedBox(width:100),
              Icon(Icons.track_changes_rounded, size: 30, color: const Color(0xFF090950),),
            ],
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      bottomNavigationBar:Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), bottomRight: Radius.circular(20),bottomLeft:Radius.circular(20) )),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 3,
          ),
          child: GNav(
            backgroundColor: Colors.transparent,
            color: const Color(0xFF090950),
            activeColor: const Color.fromARGB(255, 31, 96, 192),
            tabBackgroundColor: Colors.white,
            gap:6,
            onTabChange: (Index) {
              //if the user click on the bottom navigation bar then it will move to the following pages
              if (Index == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage()),
                );
              } else if (Index == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>Pro()),
                );
              } else if (Index == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>PlansApp()),
                );
              } else if (Index == 3) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Goals()),
                );
              } else if (Index ==4) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TextScanner(newBalance:newbalance)),
                );
              }
            },
            padding: const EdgeInsets.all(15),
            tabs: const [
              GButton(
                icon: Icons.home,
                //text: 'Home',
              ),
              GButton(
                icon: Icons.align_vertical_bottom_outlined,
                //text: 'Summary',
              ),
              GButton(
                icon: Icons.format_list_bulleted,
                //text: 'Savings',
              ),
              GButton(
                icon: Icons.track_changes_rounded,
                //text: 'Plans',
              ),
              GButton(
                icon: Icons.document_scanner_outlined,
                //text: 'Scan',
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left:25.0,top:10,bottom:10),
              child: Text(
                'Running',
                style: TextStyle(
                  fontSize: 23,
                  fontFamily: 'Lexend-VariableFont',
                  color: const Color(0xFF090950),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore
                  .collection('userDetails')
                  .doc(userId)
                  .collection('goalsID')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                final goals = snapshot.data?.docs ?? [];

                // Group goals by start and end dates
                final Map<String, List<DocumentSnapshot>> groupedGoals = {};

                for (var goalDoc in goals) {
                  final goalData = goalDoc.data() as Map<String, dynamic>;
                  final startDate = goalData['startDate'].toDate();
                  final endDate = goalData['endDate'].toDate();
                  final dateKey =
                      '${DateFormat.MMMd().format(startDate)} - ${DateFormat.MMMd().format(endDate)}';

                  if (groupedGoals.containsKey(dateKey)) {
                    groupedGoals[dateKey]!.add(goalDoc);
                  } else {
                    groupedGoals[dateKey] = [goalDoc];
                  }
                }

                // Build the UI for grouped goals
                return ListView.builder(
                  itemCount: groupedGoals.length,
                  itemBuilder: (context, index) {
                    final dateKey = groupedGoals.keys.elementAt(index);
                    final goalDocs = groupedGoals[dateKey]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 7),
                          child: Text(
                            dateKey,
                            style: const TextStyle(
                              fontFamily:
                              'Lexend-VariableFont',
                              fontSize: 18,
                              color: Color(0xFF5C6C84),
                            ),
                          ),
                        ),
                        Column(
                          children: goalDocs.map((goalDoc) {
                            final goalData =
                                goalDoc.data() as Map<String, dynamic>;
                            return MyGoal(
                              userId: userId!,
                              category: goalData['category'],
                              amount: goalData['amount'],
                              startDate: goalData['startDate'].toDate(),
                              endDate: goalData['endDate'].toDate(),
                              currencySymbol: currencySymbol,
                            );
                          }).toList(),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom:65),
        child: FloatingActionButton(
          onPressed: () {
            addNewPlan();
          },
          backgroundColor:  Color(0xFF85B6FF),
          child: const Icon(
              Icons.add,
          size: 30,),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
