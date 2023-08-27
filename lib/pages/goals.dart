import 'package:flutter/material.dart';
import '../components/datePicker.dart';
import 'package:intl/intl.dart';
//import 'addPlanPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../components/goalTiles.dart';

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
      });
    } catch (e) {
      print('Goals adding to firestore failed');
    }
  }

  //Function to show the date picker for start date

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
      });
    }
  }

  //Function to show the date picker for end date

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != endDate) {
      if (startDate != null && picked.isAfter(startDate!)) {
        setState(() {
          endDate = picked;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'End date should be after start date',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            backgroundColor: Colors.red[300],
          ),
        );
      }
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
                  'ADD NEW PLAN',
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
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Expence Category',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),

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

                      // plan amount title

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Amount',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            //fontWeight: FontWeight.bold,
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

                      //Start Date picker

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Start Date',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            //fontWeight: FontWeight.bold,
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
                            child: InkWell(
                              onTap: () => _selectStartDate(context),
                              child: DatePick(
                                selectedDate: startDate,
                                hintText: 'Select start date',
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'End Date',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

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
                            child: InkWell(
                              onTap: () => _selectEndDate(context),
                              child: DatePick(
                                selectedDate: endDate,
                                hintText: 'Select end date',
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
                                      //currency: currencySymbol,
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
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
        ),
        title: const Text(
          'P L A N S',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 5),
          //showing today date

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              children: [
                // Date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // date

                    const Text(
                      'Today',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        //fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    // Today text

                    Text(
                      DateFormat.yMMMMd().format(DateTime.now()),
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 20,
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                // Add plan button

                const SizedBox(width: 105),

                GestureDetector(
                  onTap: () {
                    addNewPlan();
                  },
                  child: Container(
                    height: 50,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.blue[300],
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.8),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Add Plan',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          // underline

          Container(
            height: 1,
            width: double.infinity,
            color: Colors.grey[500],
          ),

          const SizedBox(height: 10),

          //user plans tiles

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
                              fontSize: 18,
                              color: Colors.black,
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
    );
  }
}