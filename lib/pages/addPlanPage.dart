import 'package:budgettrack/components/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/material.dart';
import '../components/datePicker.dart';
import '../components/planTextField.dart';

class AddPlan extends StatefulWidget {
  const AddPlan({Key? key}) : super(key: key);

  @override
  State<AddPlan> createState() => _AddPlanState();
}

class _AddPlanState extends State<AddPlan> {
  final planTitleController = TextEditingController();
  final planAmountController = TextEditingController();
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  String? selectedCategory;
  List<String> expenceCategories = [
    'Food',
    'Shopping',
    'Travel',
    'Bills',
    'Entertainment',
    'Health',
    'Education',
    'Gifts',
    'Donations',
    'Rental',
    'Others',
  ];

  //Function to show the date picker for start date
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedStartDate) {
      setState(() {
        selectedStartDate = picked;
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

    if (picked != null && picked != selectedEndDate) {
      if (selectedStartDate != null && picked.isAfter(selectedStartDate!)) {
        setState(() {
          selectedEndDate = picked;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('End date should be after start date'),
          ),
        );
      }
    }
  }

  //Validation
  _validateFields() {
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
    } else if (selectedStartDate == null) {
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
    } else if (selectedEndDate == null) {
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
        //FirebaseAuth.instance.currentUser!.uid,
        selectedCategory!,
        planAmountController.text as int,
        selectedStartDate.toString(),
        selectedEndDate.toString(),
      );
      Navigator.pop(context);
    }
  }

  //Method add goals to the database
  Future<void> addGoalsToFirestore(
    //String userId,
    String selectedCategory,
    int planAmountController,
    String selectedStartDate,
    String selectedEndDate,
  ) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      await firestore.collection('goalsID').add({
        //'userId': userId,
        'category': selectedCategory,
        'amount': planAmountController.toString(),
        'startDate': selectedStartDate.toString(),
        'endDate': selectedEndDate,
      });
    } catch (e) {
      print('Goals adding to firestore failed');
    }
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
          'A D D  P L A N',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // paln title

              const SizedBox(height: 40),

              const Text(
                'Expence Category',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  //fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              // plan text field
              Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: DropdownButton<String>(
                      underline: const SizedBox(),
                      icon: const Padding(
                        padding: EdgeInsets.only(left: 205),
                        child: Icon(Icons.arrow_downward_sharp),
                      ),
                      hint: const Text('Select category'),
                      value: selectedCategory,
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                      items: expenceCategories
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          child: Text(value),
                          value: value,
                        );
                      }).toList()),
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

              const SizedBox(height: 15),

              // plan anount text field
              PlanTextField(
                controller: planAmountController,
                hintText: 'Enter plan amount',
              ),

              const SizedBox(height: 25),

              // start date title
              const Text(
                'Start Date',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  //fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              // start date text field
              InkWell(
                onTap: () => _selectStartDate(context),
                child: DatePick(
                  selectedDate: selectedStartDate,
                  hintText: 'Select start date',
                ),
              ),

              const SizedBox(height: 25),

              // end date title

              const Text(
                'End Date',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  //fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              // end date text field

              InkWell(
                onTap: () => _selectEndDate(context),
                child: DatePick(
                  selectedDate: selectedEndDate,
                  hintText: 'Select end date',
                ),
              ),

              const SizedBox(height: 30),

              //add plan button

              MyButton(
                onTap: () => _validateFields(),
                text: 'Add Plan',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
