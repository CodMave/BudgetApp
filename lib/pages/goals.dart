import 'package:budgettrack/components/planTextField.dart';
import 'package:flutter/material.dart';
import '../components/datePicker.dart';
import 'package:intl/intl.dart';
import 'addPlanPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  _validateFields() async {
    if (planAmountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Please Enter The Amount',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          backgroundColor: Colors.red[300],
        ),
      );
    } else if (selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Please Select a Category',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          backgroundColor: Colors.red[300],
        ),
      );
    } else if (startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Please Select a Start Date',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          backgroundColor: Colors.red[300],
        ),
      );
    } else if (endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Please Select an End Date',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          backgroundColor: Colors.red[300],
        ),
      );
    } else {
      addGoalsToFirestore(
        await getCurrentUser(),
        selectedCategory!,
        int.parse(planAmountController.text),
        startDate!,
        endDate!,
      );
      Navigator.pop(context);
    }
  }

  //Method to get current user

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

  //Dialog box to add new plan

  void addNewPlan() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text(
                'ADD NEW PLAN',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey, // Use the defined formKey here
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //Expence text
                      const Text(
                        'Expence Category',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 10),

                      //Expence category dropdown

                      Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.grey)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButton<String>(
                              underline: const SizedBox(),
                              icon: const Icon(Icons.arrow_downward_sharp),
                              hint: const Text(
                                'Select category',
                                style: TextStyle(
                                  fontSize: 18,
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
                                    child: Text(value),
                                  );
                                },
                              ).toList()),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // plan amount title

                      const Text(
                        'Amount',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // plan amount text field

                      PlanTextField(
                        controller: planAmountController,
                        hintText: 'Enter plan amount',
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
                                Navigator.pop(context);
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
                              onPressed: _validateFields(),
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
      body: SingleChildScrollView(
        child: Column(
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

                  const SizedBox(width: 115),

                  GestureDetector(
                    onTap: () {
                      addNewPlan();
                    },
                    child: Container(
                      height: 50,
                      width: 110,
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

            const SizedBox(height: 20),

            // plan starting date and ending date tiles

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                children: [
                  // start date container

                  GestureDetector(
                    child: Container(
                      height: 170,
                      width: 170,
                      decoration: BoxDecoration(
                        color: const Color(0xff90E0EF),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            offset: const Offset(4.0, 4.0),
                            blurRadius: 10.0,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(9.0),
                          child: Column(
                            children: [
                              Text(
                                'Your current plan',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Starting Date',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 25),
                              InkWell(
                                onTap: () => _selectStartDate(context),
                                child: DatePick(
                                  selectedDate: startDate,
                                  hintText: 'Select start date',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 20),

                  // end date container

                  GestureDetector(
                    child: Container(
                      height: 170,
                      width: 170,
                      decoration: BoxDecoration(
                        color: const Color(0xff90E0EF),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            offset: const Offset(4.0, 4.0),
                            blurRadius: 10.0,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(9.0),
                          child: Column(
                            children: [
                              Text(
                                'Your current plan',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Ending Date',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 25),
                              InkWell(
                                onTap: () => _selectEndDate(context),
                                child: DatePick(
                                  selectedDate: endDate,
                                  hintText: 'Select end date',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 5),

            //user plans tiles
          ],
        ),
      ),
    );
  }
}
