import 'package:budgettrack/components/button.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/material.dart';
import '../components/datePicker.dart';
import '../components/planTextField.dart';
import 'package:intl/intl.dart';

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

  //Function to show the date picker for start date
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
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
      firstDate: DateTime.now(),
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
              const SizedBox(height: 20),

              // Add plan text

              const Text(
                'Add Plan',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // paln title

              const SizedBox(height: 25),

              const Text(
                'Title',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  //fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // plan text field
              PlanTextField(
                controller: planTitleController,
                hintText: 'Enter plan title',
              ),

              const SizedBox(height: 20),

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

              // plan anount text field
              PlanTextField(
                controller: planAmountController,
                hintText: 'Enter plan amount',
              ),

              const SizedBox(height: 20),

              // start date title
              const Text(
                'Start Date',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  //fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // start date text field
              InkWell(
                onTap: () => _selectStartDate(context),
                child: DatePick(
                  selectedDate: selectedStartDate,
                  hintText: 'Select start date',
                ),
              ),

              const SizedBox(height: 20),

              // end date title

              const Text(
                'End Date',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  //fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // end date text field

              InkWell(
                onTap: () => _selectEndDate(context),
                child: DatePick(
                  selectedDate: selectedEndDate,
                  hintText: 'Select end date',
                ),
              ),

              const SizedBox(height: 25),

              //add plan button

              MyButton(
                onTap: () => {},
                text: 'Add Plan',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
