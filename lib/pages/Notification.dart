import 'package:budgettrack/pages/plans.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'Summery.dart';
import 'TextScanner.dart';
import 'goals.dart';
import 'homePage.dart';


class Holder extends StatefulWidget {
  final int totalBalance;

  Holder({
    required this.totalBalance,
  });


  @override
  State<Holder> createState() => _HolderState(
      Balance:totalBalance

  );
}

class _HolderState extends State<Holder> {
  int Balance;
  _HolderState({required this.Balance});

  List<DateTime> time = [];

  void onDeleteNotification(int index) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    String username = user!.uid;

    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Delete the notification from the local list


      // Retrieve the corresponding document ID from Firestore
      final CollectionReference incomeCollection = firestore
          .collection('userDetails')
          .doc(username)
          .collection('ReceivedNotifications');

      QuerySnapshot querySnapshot = await incomeCollection.get();
      final documents = querySnapshot.docs;

      if (index < documents.length) {
        final documentId = documents[index].id;

        // Delete the notification document from Firestore
        await incomeCollection.doc(documentId).delete();
      } else {
        print('Invalid index or document not found in Firestore');
      }
    } catch (ex) {
      print('Error deleting notification: $ex');
    }
  }
  Future<int> getDocumentCount() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    String username = user!.uid;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Replace 'receivedMessage' with the name of your collection
    final QuerySnapshot snapshot = await firestore.collection('userDetails').doc(username).collection('ReceivedNotifications').get();

    // The length property of QuerySnapshot gives you the document count
    final int documentCount = snapshot.size;

    return documentCount;
  }
  void getDocCount() async {

    count=await getDocumentCount();
    print(count);
  }


  List<String> messages = []; // Store messages here
  int count = 0;

  void initState() {
    super.initState();
    getDocCount();
    updateCount1();
    fetchMessages();
    fetchTime();// Fetch messages when the widget is initialized
  }
  Future<void> updateCount1() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    String username = user!.uid;
    try {
      final existingEntry = await  getCountExist();

      if (existingEntry != null) {
        final FirebaseFirestore firestore = FirebaseFirestore.instance;

        final DocumentReference documentReference = firestore
            .collection('userDetails')
            .doc(username)
            .collection('NotificationCount')
            .doc(existingEntry);

        // Use the update method to update the "Balance" field
        await documentReference.update({
          'Count':0,
        });

        print('Count updated successfully!');
      }
    } catch (ex) {
      print('Error updating noticount: $ex');
    }
    setState(() {});
  }

  Future<void> fetchMessages() async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      User? user = _auth.currentUser;
      String username = user!.uid;

      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final incomeSnapshot = await firestore
          .collection('userDetails')
          .doc(username)
          .collection('ReceivedNotifications')
          .orderBy('Time', descending:false)
          .get();

      List<String> fetchedMessages = [];

      incomeSnapshot.docs.forEach((dDoc) {
        fetchedMessages.insert(0, dDoc.get('message'));
      });

      setState(() {
        messages = fetchedMessages;
      });
    } catch (ex) {
      print('Getting the messages failed: $ex');
    }
  }

  Future<String?> getCountExist() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    String username = user!.uid;

    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      final QuerySnapshot querySnapshot = await firestore
          .collection('userDetails')
          .doc(username)
          .collection('NotificationCount')
          .where('Count', isEqualTo:await getcountfromdb() )
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Return the document ID of the existing entry
        return querySnapshot.docs.first.id;
      } else {
        // No entry found
        return null;
      }
    } catch (ex) {
      print('Error getting existing entry: $ex');
      return null;
    }
  }
  Future<void> fetchTime() async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      User? user = _auth.currentUser;
      String username = user!.uid;

      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final incomeSnapshot = await firestore
          .collection('userDetails')
          .doc(username)
          .collection('ReceivedNotifications')
          .orderBy('Time',descending: false)
          .get();

      List<DateTime> fetchedTime = []; // Change the type to List<DateTime>

      incomeSnapshot.docs.forEach((dDoc) {
        // Assuming 'Time' is a timestamp field in Firestore
        Timestamp timestamp = dDoc.get('Time');
        DateTime dateTime = timestamp.toDate();
        fetchedTime.insert(0, dateTime);
      });

      setState(() {
        time = fetchedTime;
      });
    } catch (ex) {
      print('Getting the messages failed: $ex');
    }
  }
  Future<int>getcountfromdb()async{
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    String username = user!.uid;

    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      final QuerySnapshot querySnapshot = await firestore
          .collection('userDetails')
          .doc(username)
          .collection('NotificationCount')
          .get();

      if (querySnapshot.docs.isNotEmpty) {

        int count = querySnapshot.docs.first['Count'];

        print(count);
        return  count;

      } else {
        // No entry found
        return 0;
      }
    } catch (ex) {
      print('Error getting existing entry: $ex');
      return 0;
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>HomePage(
                ),
              ),
            );
          },
        ),
        title: const Text('N O T I F I C A T I O N S',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20,
            )),
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
            color: const Color(0xFF85B6FF),
            activeColor: const Color.fromARGB(255, 31, 96, 192),
            tabBackgroundColor: Colors.grey.shade400,
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: messages.length, // Use the length of messages
                      itemBuilder: (context, index) {
                        if (index < messages.length && index < time.length) {
                          return Dismissible(
                            key: UniqueKey(),
                            background: Container(
                              color: Colors.blue,
                            ),
                            onDismissed: (direction) {
                              if (direction == DismissDirection.startToEnd) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('$index item deleted'),
                                  ),
                                );
                                onDeleteNotification(index);
                              }
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xffADE8F4),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        messages[index], // Use messages[index]
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xff181EAA),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              DateFormat('dd/MM/yyyy   h:mm a')
                                                  .format(time[index]),
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          // Handle the case where index is out of bounds
                          return SizedBox(); // Return an empty SizedBox or any other appropriate widget
                        }
                      },
                    )

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
