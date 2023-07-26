import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/plansTile.dart';

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
      body: Column(
        children: [
          const SizedBox(height: 20),
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
          )
        ],
      ),
    );
  }
}
