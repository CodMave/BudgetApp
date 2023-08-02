import 'package:flutter/material.dart';
import '../components/plansTile.dart';
import 'package:intl/intl.dart';
import 'addPlanPage.dart';

class Goals extends StatefulWidget {
  final Function()? onTap;
  const Goals({super.key, this.onTap});

  @override
  _GoalsState createState() => _GoalsState();
}

class _GoalsState extends State<Goals> {
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddPlan(),
                        ),
                      );
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

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                children: [
                  // start date container

                  PlanTile(
                    firstText: 'Your current plan',
                    secondText: 'Stranting Date',
                    date: '31/01/2021', //SHOULD BE USER INPUT
                  ),

                  SizedBox(width: 20),

                  // end date container
                  PlanTile(
                    firstText: 'Your current plan',
                    secondText: 'Ending Date',
                    date: '31/01/2021', //SHOULD BE USER INPUT
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
