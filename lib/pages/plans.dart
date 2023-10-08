import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'homePage.dart';



class PlansApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PlansPage(),
    );
  }
}

class PlansPage extends StatefulWidget {
  @override
  _PlansPageState createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {
  CalendarController _calendarController = CalendarController();
  List<String> upcomingPlans = [];

  void _handleSeeMore() {
    // Implement your "See More" logic here
    // You can show more information or navigate to another page.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>HomePage()),
            ); // Navigate back when the arrow button is pressed
          },
        ),
        title: const Text(
          'P L A N S',
          style: TextStyle(
            color: const Color(0xFF090950),
            fontSize: 20,
            fontFamily: 'Lexend',
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.note_add_outlined),
            color: Colors.black,
            onPressed: () {
              // Add your logic here for the notepad button
            },
          ),
        ],
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          // Calendar widget
          CalendarWidget(calendarController: _calendarController),
          const SizedBox(height: 10), // Add some spacing
          Align(
            alignment: Alignment.centerLeft, // Left-align the text
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Upcoming', // Title for the upcoming events
                style: TextStyle(
                  fontSize: 18,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10), // Add some spacing
          // Upcoming Plans List
          Expanded(
            child: ListView.builder(
              itemCount: upcomingPlans.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(upcomingPlans[index]),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RawMaterialButton(
            onPressed: _handleSeeMore,
            elevation: 2.0,
            fillColor: Colors.grey[200],
            padding: EdgeInsets.all(
                20.0), // Adjust the padding to change the button size
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),

            child: Text(
              "See More",
              style: TextStyle(color: Colors.black),
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              // Handle create button press to show a pop-up box
              showDialog(
                context: context,
                builder: (context) {
                  DateTime selectedDate = DateTime.now();
                  String category = "";
                  double amount = 0.0;
                  bool remind = false;

                  return StatefulBuilder(
                    builder: (context, setState) {
                      return AlertDialog(
                        title: Text("Create Plan"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Input field for Category
                            TextField(
                              decoration: InputDecoration(
                                labelText: "Enter Your Category",
                              ),
                              onChanged: (value) {
                                setState(() {
                                  category = value;
                                });
                              },
                            ),
                            SizedBox(height: 10),
                            // Calendar widget for selecting Date
                            InkWell(
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101),
                                );

                                if (pickedDate != null &&
                                    pickedDate != selectedDate) {
                                  setState(() {
                                    selectedDate = pickedDate;
                                  });
                                }
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_today),
                                  SizedBox(width: 10),
                                  Text(DateFormat('yyyy-MM-dd')
                                      .format(selectedDate)),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            // Input field for Amount
                            TextField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(labelText: "Amount"),
                              onChanged: (value) {
                                setState(() {
                                  amount = double.tryParse(value) ?? 0.0;
                                });
                              },
                            ),
                            SizedBox(height: 10),
                            // Checkbox for Remind
                            Row(
                              children: [
                                Checkbox(
                                  value: remind,
                                  onChanged: (value) {
                                    setState(() {
                                      remind = value ?? false;
                                    });
                                  },
                                ),
                                Text("Remind"),
                              ],
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                // Handle plan creation logic with the entered data
                                String planText =
                                    "Category: $category, Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}, Amount: $amount, Remind: $remind";
                                setState(() {
                                  upcomingPlans.add(planText);
                                });

                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: Text("Create"),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

class CalendarWidget extends StatelessWidget {
  final CalendarController calendarController;

  CalendarWidget({required this.calendarController});

  @override
  Widget build(BuildContext context) {
    var tableCalendar = TableCalendar(
      //calendarController: calendarController, // Add the calendar controller
      firstDay: DateTime(2000),
      lastDay: DateTime(2101),
      focusedDay: DateTime.now(),
    );
    return tableCalendar;
  }
}

class CalendarController {}

void buttonPressed() {
  // Implement your "See More" logic here
  // You can show more information or navigate to another page.
}
