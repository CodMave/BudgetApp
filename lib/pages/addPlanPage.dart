import 'package:flutter/material.dart';

import '../components/textfield.dart';

class AddPlan extends StatefulWidget {
  const AddPlan({Key? key}) : super(key: key);

  @override
  State<AddPlan> createState() => _AddPlanState();
}

class _AddPlanState extends State<AddPlan> {
  final planTitleController = TextEditingController();

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),

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

            const SizedBox(height: 15),

            const Text(
              'Title',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                //fontWeight: FontWeight.bold,
              ),
            ),

            // plan text field

            // plan amount title

            // plan anount text field

            // start date title

            // start date text field

            // end date title

            // end date text field
          ],
        ),
      ),
    );
  }
}
