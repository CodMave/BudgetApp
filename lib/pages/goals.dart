import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/plansTile.dart';
import 'package:intl/intl.dart';

class Goals extends StatefulWidget {
  const Goals({super.key});

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
                    children: [
                      // date
                      Text(
                        DateFormat.MMMd().format(DateTime.now()),
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 18,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      // Today text

                      const Text(
                        'Today',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  // Add plan button
                ],
              ),
            ),

            const SizedBox(height: 20),

            // paln starting date and ending date

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                children: [
                  // start date container

                  PlanTile(
                    firstText: 'Your current plan',
                    secondText: 'Stranting Date',
                    date: '01/01/2021',
                  ),

                  const SizedBox(width: 20),

                  // end date container
                  PlanTile(
                    firstText: 'Your current plan',
                    secondText: 'Ending Date',
                    date: '31/01/2021',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 5),

            //user adding plan button and the plans tiles
          ],
        ),
      ),
    );
  }
}
