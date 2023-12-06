
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../components/plusButton.dart';
import 'Summery.dart';
import 'TextScanner.dart';
import 'goals.dart';
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
  String currencySymbol = '';
  CalendarController _calendarController = CalendarController();
  List<String> upcomingPlans = [];
  List<String>plandate=[];
  List<DateTime>unformated=[];
  List<double>valuein=[];
DateTime time=DateTime.now();
String text='text';
double value=0.0;
 void initState(){
   super.initState();
   fetchinfo();
   getDocIds();
 }
  void _handleSeeMore() {
    // Implement your "See More" logic here
    // You can show more information or navigate to another page.
  }
  int _calculateDaysRemaining(DateTime dateString) {

    DateTime startDate=DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
    DateTime enddate=DateTime(dateString.year,dateString.month,dateString.day);
    Duration difference = enddate.difference(startDate);
    return difference.inDays;
  }
  void addmessageToFirestore(String message,DateTime date,double value,DateTime time) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    String username = user!.uid;

    try {

      try {
        final FirebaseFirestore firestore = FirebaseFirestore.instance;

        final CollectionReference incomeCollection = firestore
            .collection('userDetails')
            .doc(username)
            .collection('Plans');

        final DocumentReference newDocument = await incomeCollection.add({
          'Message':message,
          'Date':date,
          'Amount':value,
          'Time':time,
          // Use the formatted time as a DateTime
        });

        final String newDocumentId = newDocument.id;
        print('New document created with ID: $newDocumentId');
      } catch (ex) {
        print('Notification adding failed: $ex');
        // Handle the error appropriately, e.g., show a message to the user
      }
      // }
    }
    catch (ex) {
      print('Error occurs: $ex');
      // Handle any unexpected errors here
    }
  }
  Future<void> fetchinfo() async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      User? user = _auth.currentUser;
      String username = user!.uid;

      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final incomeSnapshot = await firestore
          .collection('userDetails')
          .doc(username)
          .collection('Plans')
          .get();

      List<String> fetchedMessages = [];
      List<String>time=[];
      List<double>value=[];
      List<DateTime>d=[];
      incomeSnapshot.docs.forEach((dDoc) {
        fetchedMessages.insert(0, dDoc.get('Message'));
        DateTime date = dDoc.get('Date').toDate();
        String formattedDate = DateFormat('MMM dd ').format(date);
        time.insert(0, formattedDate);
        d.insert(0,date);
        value.insert(0,dDoc.get('Amount'));

      });

      setState(() {
        this.unformated=d;
        this.upcomingPlans = fetchedMessages;
        this.valuein=value;
        this.plandate=time;
        print('size of the list is  ${upcomingPlans.length}');
      });
    } catch (ex) {
      print('Getting the messages failed: $ex');
    }
  }
void addnewplan(){
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
                    time=selectedDate;
                    text=category;
                    value=amount.toDouble();

                    String planText =
                        "Category: $category, Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}, Amount: $amount, Remind: $remind";
                    setState(() {
                      addmessageToFirestore(text,time,value,DateTime.now());
                      fetchinfo();
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
}
  Future<String> getDocIds() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    email = user!.email!;
    if (user != null) {
      QuerySnapshot qs = await FirebaseFirestore.instance.collection(
        //the query check wither the authentication email match with the email which is taken at the user details
          'userDetails').where('email', isEqualTo: email).limit(1).get();

      if (qs.docs.isNotEmpty) {
        // Loop through the documents to find the one with the matching email
        for (QueryDocumentSnapshot doc in qs.docs) {
          if (doc.get('email') == email) {
            // Get the 'username' field from the matching document
            currencySymbol = doc.get('currency');
            print(currencySymbol);
            if (currencySymbol == 'SLR') {
              currencySymbol = 'Rs.';
            } else if (currencySymbol == 'USD') {
              currencySymbol = '\$';
            } else if (currencySymbol == 'EUR') {
              currencySymbol = '€';
            } else if (currencySymbol == 'INR') {
              currencySymbol = '₹';
            } else if (currencySymbol == 'GBP') {
              currencySymbol = '£';
            } else if (currencySymbol == 'AUD') {
              currencySymbol = 'A\$';
            } else if (currencySymbol == 'CAD') {
              currencySymbol = 'C\$';
            }

            return currencySymbol; //return the currency
          }
        }
      }
      // Handle the case when no matching documents are found for the current user
      print('No matching document found for the current user.');
      return ''; // Return an empty string or null based on your requirements
    } else {
      // Handle the case when the user is not authenticated
      print('User not authenticated.');
      return ''; // Return an empty string or null based on your requirements
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
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
          padding: const EdgeInsets.only(left:90.0),
          child: Row(
            children: [

              const Text(
                'P L A N S',
                style: TextStyle(
                  fontFamily: 'Lexend-VariableFont',
                  color: const Color(0xFF090950),
                ),
              ),
              SizedBox(width:95),
              Icon(Icons.format_list_bulleted, size: 30, color: const Color(0xFF090950),),
            ],
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      bottomNavigationBar: Container(
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
                      builder: (context) => Controller(
                        balance: newbalance,
                      )),
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
                icon: Icons.account_balance_wallet_outlined,
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            // Calendar widget
            Container(
              width:320,
              height:392,
              decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.8),
                    spreadRadius:2,
                    blurRadius:3,
                    offset: Offset(0,2),
                  )
                ],
              ),
              child: CalendarWidget(
                  calendarController: _calendarController,
                    selectedPlanDates:unformated.toList(),

              ),
            ),
            const SizedBox(height:15), // Add some spacing
            Divider(
              // Add a Divider here
              height: 3, //  adjust the height of the divider
              thickness:
              0.5, //adjust the thickness of the divider
              color:
              Colors.grey, // set the color of the divider
            ),
            Align(
              alignment: Alignment.centerLeft, // Left-align the text
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal:45.0),
                child: Text(
                  'Upcoming', // Title for the upcoming events
                  style: TextStyle(
                    fontSize:18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lexend-VariableFont',
                    color: const Color(0xFF090950),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5), // Add some spacing

            // Upcoming Plans List
            Container(
              height:400,
              width:400,
              child: ListView.builder(
                itemCount: this. upcomingPlans?.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        title: Container(
                          height:65,
                          width: 330,
                          margin: EdgeInsets.only(top:15, left: 20, right: 20),
                          decoration: BoxDecoration(
                            color: Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.8),
                                spreadRadius:2,
                                blurRadius:3,
                                offset: Offset(0,2),
                              )
                            ],
                          ),
                          child: Row(
                            children: [
                              SizedBox(width:80,
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(
                                      left: 5.0),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      width:55,
                                  height:55,
                                  decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:Colors.white,
                                        ),
                                      child: Center(
                                        child: Text(
                                          this.plandate[index],
                                          style: TextStyle(
                                            fontFamily:
                                            'Lexend-VariableFont',
                                            color:const Color(0xFF3AC6D5),
                                            fontWeight: FontWeight.w400,
                                            fontSize:18,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width:130,
                                child: Padding(
                                  padding: const EdgeInsets.only(top:13.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${upcomingPlans[index]}',  // '$currencySymbol ${![index]}',
                                        style: TextStyle(
                                          fontSize:18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Lexend-VariableFont',
                                          color: const Color(0xFF090950),
                                        ),
                                      ),
                                      Text(
                                        ' ${_calculateDaysRemaining(unformated[index]) } days Remaininig ',  // '$currencySymbol ${![index]}',
                                        style: TextStyle(
                                          fontSize:12,
                                          fontFamily:
                                          'Lexend-VariableFont',
                                          color:const Color(0xFF5C6C84),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width:20),
                              Center(
                                child: Text(
                                '$currencySymbol${this.valuein[index]}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight:
                                    FontWeight.bold,
                                    fontFamily:
                                    'Lexend-VariableFont',
                                    color: Color(
                                        0xFF316F9B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Align(
             alignment: Alignment.bottomRight,
              child: PlusButton(
                function: addnewplan,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CalendarWidget extends StatelessWidget {
  final CalendarController calendarController;
  final List<DateTime> selectedPlanDates;
  CalendarWidget({required this.calendarController,required this.selectedPlanDates});

  @override
  Widget build(BuildContext context) {
    var tableCalendar = TableCalendar(
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle:  TextStyle(
          fontFamily:
          'Lexend-VariableFont',
          color:Color(0xFF5C6C84),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(
          fontFamily:
          'Lexend-VariableFont',
          color:Color(0xFF092D50),
          fontWeight: FontWeight.bold,
        ),
        weekendStyle: TextStyle(
          fontFamily:
          'Lexend-VariableFont',
          color:Color(0xFF092D50),
          fontWeight: FontWeight.bold,
        ),
      ),
      calendarStyle: CalendarStyle(
        todayTextStyle:TextStyle(
          fontFamily:
          'Lexend-VariableFont',
          color:Color(0xFF092D50),
          fontWeight: FontWeight.bold,
        ),
          defaultTextStyle: TextStyle(
            fontFamily:
            'Lexend-VariableFont',
         color:Color(0xFF092D50),
            fontWeight: FontWeight.bold,
          ),
        selectedTextStyle: TextStyle(
          fontFamily:
          'Lexend-VariableFont',
          color:Color(0xFF092D50),
          fontWeight: FontWeight.bold,
        ),
        weekendTextStyle: TextStyle(
          fontFamily:
          'Lexend-VariableFont',
            color:Color(0xFF092D50),
          fontWeight: FontWeight.bold,
        ),
        selectedDecoration: BoxDecoration(
          color: Color(0xFFC2DAFF),
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color:Color(0xFF85B6FF), // Set the color you want for the current day
          shape: BoxShape.circle,
        ),

      ),
      selectedDayPredicate: (day) {
        // Check if the selectedPlanDates list contains the date with the same day, month, and year
        return selectedPlanDates.any(
              (selectedDate) =>
          selectedDate.year == day.year &&
              selectedDate.month == day.month &&
              selectedDate.day == day.day,
        );
      },
      firstDay: DateTime(2000),
      lastDay: DateTime(2101),
      focusedDay: DateTime.now(),
    );
    return tableCalendar;
  }
}

class CalendarController {}

void buttonPressed() {
  // See More

}