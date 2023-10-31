import 'dart:convert';
import 'dart:typed_data';

import 'package:budgettrack/pages/plans.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:budgettrack/pages/Notification.dart';
import 'package:badges/badges.dart' as badges;
import 'package:shared_preferences/shared_preferences.dart';
import '../components/tranaction.dart';
import 'Profile.dart';
import 'Savings.dart';
import 'expenceAndIncome.dart';
import 'goals.dart';
import 'TextScanner.dart';
import 'Summery.dart';

int expensevalue=0;
int incomevalue=0;
double percentage1=0.0;
class HomePage extends StatelessWidget {
  const HomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(325, 812),
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        //remove the debug label
        home: MyWork(), //call to the class work
      ),
    );
  }
}

String username = '';
String email = '';
int count = 0;
double percent = 0.0;
String name='';



class Controller extends StatefulWidget {
  int newbalance=0;
  Controller({Key? key, required int balance }) : super(key: key) //one of the constructor to get the following values from Menu,Notification files
  {
    newbalance=balance;
  }

  @override
  _ControllerState createState() => _ControllerState(
    newbalance: newbalance,

    //pass the values to the _ControllerState private class
  );
}

class _ControllerState extends State<Controller> {
  Uint8List? minpic;
  bool isContainerVisible = false;
  int newbalance = 0;
  String currency='';
  MyTransaction? latestincome;
  MyTransaction? latestexpense;
  _ControllerState(
      {required this.newbalance});

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  SharedPreferences? _prefs; //initialized the sharedpreferances
  static Future<String> getUserName() async {
    //get the username from Profile file
    User? user = _auth.currentUser; //created an instance to the User of Firebase authorized
    email = user!.email!; //get the user's email
    if (user != null) {
      QuerySnapshot qs = await FirebaseFirestore.instance
          .collection('userDetails')
          .where('email', isEqualTo: email)
          .limit(1)
          .get(); //need to filter the current user's name by matching with the users male at the authentication and the username

      if (qs.docs.isNotEmpty) {
        // Loop through the documents to find the one with the matching email
        for (QueryDocumentSnapshot doc in qs.docs) {
          if (doc.get('email') == email) {
            // Get the 'username' field from the matching document
            String username = doc.get('username');
            return username;
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

  Future<void> fetchLatestTransactions() async {// This method is for get the recent expense and income name
    User? user = _auth.currentUser;
    String username = user!.uid;
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      //fetch the latest income
      final incomeSnapshot = await firestore
          .collection('userDetails')
          .doc(username)
          .collection('incomeID')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (incomeSnapshot.docs.isNotEmpty) {
        final income = incomeSnapshot.docs[0];
        setState(() {
          this.latestincome= MyTransaction(
            transactionName: income.get('transactionName'),
            transactionAmount: income.get('transactionAmount'),
            transactionType: 'Income',
            timestamp: income.get('timestamp').toDate(),
            currencySymbol:currency,
          );
        });
      }

      //fetch the latest expenses according to the transaction page
      final expenceSnapshot = await firestore
          .collection('userDetails')
          .doc(username)
          .collection('expenceID')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (expenceSnapshot.docs.isNotEmpty) {
        final expence = expenceSnapshot.docs[0];
        setState(() {
          this.latestexpense = MyTransaction(
            transactionName: expence.get('transactionName'),
            transactionAmount: expence.get('transactionAmount'),
            transactionType: 'Expence',
            timestamp: expence.get('timestamp').toDate(),
            currencySymbol: currency,
          );
        });
      }
    } catch (ex) {
      print('fetching latest transactions failed');
    }
    print(  latestexpense?.transactionName);
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
  Future<String> getCurrency() async {

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
            currency = doc.get('currency');
            print(currency);
            if(currency=='SLR'){
              currency='Rs.';
            }
            else if(currency=='USD'){
              currency='\$';
            }
            else if(currency=='EUR'){
              currency='€';
            }
            else if(currency=='INR'){
              currency='₹';
            }
            else if(currency=='GBP'){
              currency='£';
            }
            else if(currency== 'AUD'){
              currency='A\$';
            }
            else if(currency=='CAD'){
              currency='C\$';
            }

            return currency; //return the currency
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
  Future<int> getBalance() async {
    int totalIncome = await  getIncome();
    int totalExpence = await  getExpence();


    int difference = (totalIncome - totalExpence).toInt();

    if(difference<0) {
      setState(() {
        newbalance = 0;
      });
      return newbalance;
    }
    else {
      setState(() {
        newbalance =difference;
      });
      return newbalance;
    }

  }
  Future<int> getIncome() async {
    User? user = _auth.currentUser;
    String username = user!.uid;
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      final QuerySnapshot querySnapshot = await firestore
          .collection('userDetails')
          .doc(username)
          .collection('Balance')
          .get();

      if (querySnapshot.docs.isNotEmpty) {

        incomevalue = querySnapshot.docs.first['Income'];
        return  incomevalue;
      } else {
        // No entry found
        return 0;
      }
    } catch (ex) {
      print('Error getting existing entry: $ex');
      return 0;
    }
  }
  Future<int> getExpence() async {
    User? user = _auth.currentUser;
    String username = user!.uid;
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      final QuerySnapshot querySnapshot = await firestore
          .collection('userDetails')
          .doc(username)
          .collection('Balance')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Assuming 'Balance' is a field in your Firestore document
        expensevalue = querySnapshot.docs.first['Expences'];
        return expensevalue;
      } else {
        // No entry found
        return 0;
      }
    } catch (ex) {
      print('Error getting existing entry: $ex');
      return 0;
    }
  }
  void initState() {
    super.initState();
    getCurrency();
    loadStoredImage();
    fetchLatestTransactions();
    getBalance();
    getIncome();
    getExpence();
    countPercenntage();
    updatePercentage();//call to the countpercentage method
  }

  Future<void> updatePercentage() async {
    double percentage = await countPercenntage();
    setState(() {
      percentage1 = percentage;
    });
  }

  Future<double> countPercenntage() async {
    //count the percentage by subtracting expense from income and divide it from the income value
    double difference = (await getIncome() - await getExpence()).toDouble();
    percent = difference /(await getIncome()).toDouble();
    if (percent >= 0 && percent <= 1) {

      return percent;
    }
    else {
      percent = 0.0;
      return percent;
    }

  }


  void ContainerVisibility() {

    showDialog(context: context,
        builder: (BuildContext context){
          return Stack(
            children: [
              AlertDialog(
                content: Container(
                  alignment: Alignment.center,
                  height:100,
                  width:400,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Row(

                        children: [

                          Text(
                            'Total Income:',
                            style: TextStyle(
                              fontSize:15,
                              color: Colors.black,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left:15.0),
                            child: FutureBuilder<int>(
                                future:getIncome(),
                                builder: (context, snapshot) {

                                  return Text(
                                    '${snapshot.data}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                  );
                                }
                            ),

                          ),
                          Icon(
                            Icons.arrow_upward,
                            color: Colors.green,
                            size: 28,
                          ),
                        ],
                      ),
                      SizedBox(height:5),
                      Row(
                        children: [
                          Text(
                            'Total Expense:',
                            style: TextStyle(
                              fontSize:15,
                              color: Colors.black,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left:8.0),
                            child:FutureBuilder<int>(
                                future: getExpence(),
                                builder: (context, snapshot) {
                                  return Text(
                                    '${snapshot.data}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                  );
                                }

                            ),

                          ),
                          Icon(
                            Icons.arrow_downward,
                            color: Colors.red,
                            size: 28,
                          ),
                        ],
                      )

                    ],
                  ),
                ),
              ),
            ],

          );
        }
    );

  }
  Future<Uint8List?> getImageFromFirestore() async {
    try {
      User? user = _auth.currentUser;
      String username = user!.uid;

      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      final CollectionReference profileImageCollection = firestore
          .collection('userDetails')
          .doc(username)
          .collection('ProfileImage');

      QuerySnapshot imageDocuments = await profileImageCollection.get();

      if (imageDocuments.docs.isNotEmpty) {
        // If there are image documents, retrieve the first one (assuming only one exists)
        String base64Image = imageDocuments.docs.first['Userimage'];

        // Decode the base64-encoded image data and return it as Uint8List
        Uint8List imageBytes = base64Decode(base64Image);
        return imageBytes;
      } else {
        return null; // Return null if no image documents are found
      }
    } catch (ex) {
      print('Image retrieval from Firestore failed: $ex');
      return null; // Return null to indicate failure
    }
  }


  void loadStoredImage() async {

    Uint8List? profileImage = await getImageFromFirestore();

    if (profileImage != null) {
      setState(() {
        minpic= profileImage;
      });
    } else {
      minpic=null;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
          size: 30,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Check()), //if the user click on the menu icon then move
            );
          },
          icon: const Icon(Icons.menu),
        ),
        titleSpacing: 5.0,
        title:   Row(
          children: [
            Container(
              width:40,
              height:40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:const Color(0xFF090950),
                  width: 3.0,
                ),
              ),
              margin: EdgeInsets.only(left:0,top:5,right:5),
              child:minpic != null
                  ? CircleAvatar(
                  radius:40,
                  backgroundImage: MemoryImage(minpic!))
                  : CircleAvatar(
                radius:40,
                backgroundColor: Colors.transparent,),
            ),
            FutureBuilder<String>(
                future: getUserName(),
                builder: (context, snapshot) {
                  return Center(
                    child: Text(
                      "Welcome,${snapshot.data}",
                      textAlign: TextAlign.left,
                      //print the user name who are currently using with
                      style: TextStyle(

                        fontFamily:'Lexend-VariableFont',
                        color: Colors.black,
                        fontSize:25,

                      ),
                    ),
                  );
                }),

          ],
        ),
        actions: [

          Icon(
              Icons.waving_hand,
              size:20,
              color: Color(0xFF3AC6D5)
          ),
          FutureBuilder<int>(
            future: getcountfromdb(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // While the future is still loading, you can show a loading indicator or placeholder
                return CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.transparent),
                );
              } else if (snapshot.hasError) {
                // If there's an error, you can handle it here
                return Text('Error: ${snapshot.error}');
              } else {
                // If the future has completed successfully, display the data
                return snapshot.data==0 ? IconButton(
                  //if the count value is 0 then badge won't show otherwise it dissplays the unseen notification count
                  onPressed: () {
                    Navigator.push(
                      context,

                      MaterialPageRoute(
                          builder: (context) => Holder(
                            totalBalance: newbalance,
                          )), //create a constructor to the Holder class to display the notification list
                    );
                  },
                  icon: Icon(
                    Icons.notifications_active_outlined,
                    size: 40,
                  ),

                )
                    : badges.Badge(
                  badgeContent: Text('${snapshot.data}'),
                  position: badges.BadgePosition.topEnd(top: 2, end: 0),
                  badgeAnimation: badges.BadgeAnimation.slide(),
                  badgeStyle: badges.BadgeStyle(
                    shape: badges.BadgeShape.circle,
                    padding: EdgeInsets.all(8.0),
                    badgeColor: Colors.red,
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Holder(
                              totalBalance: newbalance,
                            )),
                      );
                    },
                    icon: Icon(
                      Icons.notifications_active_outlined,
                      size: 40,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),

      //bottom navigation bar
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
      body: SingleChildScrollView(

        child: Container(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width:double.infinity,
                height:300,
                color:Color(0xFF85B6FF),
                child: Container(
                  //container which carries the percentage indicator
                  height: 270,
                  width: 450,
                  decoration: BoxDecoration(
                    color:Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.8),
                        spreadRadius: 5,
                        blurRadius: 10,
                        offset: Offset(0,3),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [

                      CircularPercentIndicator(
                        radius: 130,
                        lineWidth:30,
                        percent:percentage1,
                        animation: true,
                        animationDuration: 1000,
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Color(0xFF3AC6D5), // Progress color
                        backgroundColor: const Color(0xFFC2DAFF),
                        center: TextButton(
                          onPressed: () {
                            ContainerVisibility();
                          },
                          child:FutureBuilder<double>(
                            future: countPercenntage(),
                            builder: (context, snapshot) {  if (snapshot.connectionState == ConnectionState.waiting) {
                              // Handle the case where the Future is still running
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              // Handle any errors that occurred during the Future execution
                              return Text('Error: ${snapshot.error}');
                            } else {
                              // Perform a null check before using snapshot.data
                              if (snapshot.data != null) {

                                final percentage = (snapshot.data!*100).toStringAsFixed(0);

                                return Text(
                                  '${percentage}%',
                                  style: TextStyle(
                                    fontFamily:'Lexend-VariableFont',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 60,
                                    color: Colors.black,
                                  ),
                                );
                              } else {
                                // Handle the case where snapshot.data is null
                                return Text('Data is null');
                              }
                            }
                            },
                          ),
                        ),

                      ),
                      FractionallySizedBox(
                        //this is for display the current date and time
                        widthFactor: 1.0,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 60.0),
                            child: Text(
                              DateFormat('MMM dd').format(DateTime.now()),
                              //time and date format
                              style: const TextStyle(
                                fontFamily:'Lexend-VariableFont',
                                fontSize:30,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const FractionallySizedBox(
                        //this is for display 'Remaining' as a word
                        widthFactor: 1.0,
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.only(top: 90.0),
                            child: Text(
                              'Remaining',
                              style: TextStyle(
                                fontFamily:'Lexend-VariableFont',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height:10),
              Container(
                  width:375,
                  height:220,

                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('lib/images/mastercard NEW.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),


                  child:Column(
                    children: [
                      Align(
                        alignment:Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top:5,left:5),
                          child: Text(
                              'Balance',
                              style:TextStyle(
                                fontFamily:'Lexend-VariableFont',
                                fontSize: 20,
                                color:const Color(0xFF090950),
                              )
                          ),
                        ),
                      ),
                      Align(
                        alignment:Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top:130,left:5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${currency}${newbalance}',
                                style: TextStyle(
                                  fontFamily:'Lexend-VariableFont',
                                  fontSize: 40,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '${DateFormat('dd/MM').format(DateTime.now())}',
                                style:TextStyle(
                                  fontFamily:'Lexend-VariableFont',
                                  fontSize:20,
                                  color:Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),


                    ],
                  )

              ),
              const SizedBox(height: 10),

              Container(
                width:double.infinity,
                height:140,
                color:Color(0xFF85B6FF),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 120,
                      width: 220,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.8),
                            spreadRadius: 0,
                            blurRadius:8,
                            offset: Offset(0,3),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(children: [
                        const Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: EdgeInsets.only(top: 5, left: 5),
                            child: Text(
                              'TRANSACTION', //print the text as 'Recent'
                              style: TextStyle(
                                fontFamily:'Lexend-VariableFont',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color:Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              //this container is for the recent transactions
                              width: 60.0,
                              height: 60.0,
                              margin:
                              const EdgeInsets.only(top: 35, left: 10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:const Color(0xFF090950),
                                  width: 3.0,
                                ),
                              ),
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: this.latestexpense?.transactionName=='Transport'? Icon(
                                    FontAwesomeIcons.car,
                                    size: 40,
                                    color:const Color(0xFF090950)
                                )
                                    :this.latestexpense?.transactionName=='Food'?Icon(
                                    FontAwesomeIcons.burger,
                                    size: 40,
                                    color:const Color(0xFF090950)
                                )
                                    :this.latestexpense?.transactionName=='Health'?Icon(
                                    FontAwesomeIcons.heartPulse,
                                    size: 40,
                                    color:const Color(0xFF090950)
                                )
                                    :this.latestexpense?.transactionName=='Education'?Icon(
                                    FontAwesomeIcons.book,
                                    size: 40,
                                    color:const Color(0xFF090950)
                                )
                                    :this.latestexpense?.transactionName=='Fuel'?Icon(
                                    FontAwesomeIcons.oilCan,
                                    size: 40,
                                    color:const Color(0xFF090950)
                                )
                                    :this.latestexpense?.transactionName=='Donations'?Icon(
                                    FontAwesomeIcons.donate,
                                    size: 40,
                                    color:const Color(0xFF090950)
                                )
                                    :this.latestexpense?.transactionName=='Bills'?Icon(
                                    FontAwesomeIcons.prescription,
                                    size: 40,
                                    color:const Color(0xFF090950)
                                )
                                    :this.latestexpense?.transactionName=='Entertainment'?Icon(
                                    FontAwesomeIcons.microphone,
                                    size: 40,
                                    color:const Color(0xFF090950)
                                )
                                    :this.latestexpense?.transactionName=='Others'?Icon(
                                    FontAwesomeIcons.handsAslInterpreting,
                                    size: 40,
                                    color:const Color(0xFF090950)
                                )
                                    :this.latestexpense?.transactionName=='Shopping'?Icon(
                                    FontAwesomeIcons.shoppingCart,
                                    size: 40,
                                    color:const Color(0xFF090950)
                                )
                                    :this.latestexpense?.transactionName=='Rental'?Icon(
                                    FontAwesomeIcons.house,
                                    size: 40,
                                    color:const Color(0xFF090950)
                                )
                                    :Container(
                                ),
                              ),
                            ),
                            Container(
                              width: 60.0,
                              height: 60.0,
                              margin:
                              const EdgeInsets.only(top: 35, left: 10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:Color(0xFF3AC6D5),
                                  width: 3.0,
                                ),
                              ),
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: this.latestincome?.transactionName=='Salary'? Icon(
                                  FontAwesomeIcons.wallet,
                                  size: 40,
                                  color:Color(0xFF3AC6D5),
                                )
                                    :this.latestincome?.transactionName=='Bonus'?Icon(
                                  FontAwesomeIcons.clockRotateLeft,
                                  size: 40,
                                  color:Color(0xFF3AC6D5),
                                )
                                    :this.latestincome?.transactionName=='Gifts'?Icon(
                                  FontAwesomeIcons.gift,
                                  size: 40,
                                  color:Color(0xFF3AC6D5),
                                )
                                    :this.latestincome?.transactionName=='Rental'?Icon(
                                  Icons.add_card_rounded,
                                  size: 40,
                                  color:Color(0xFF3AC6D5),
                                )
                                    :this.latestincome?.transactionName=='Others'?Icon(
                                  FontAwesomeIcons.handsClapping,
                                  size: 40,
                                  color:Color(0xFF3AC6D5),
                                )
                                    :Container(),
                              ),
                            ),
                            Container(
                              width: 50.0,
                              height: 50.0,
                              margin:
                              const EdgeInsets.only(top: 35, left: 20),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:const Color(0xFFC2DAFF),
                                  width: 3.0,
                                ),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  FontAwesomeIcons.plus,
                                  size: 30,
                                  color:Colors.blue,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Expence(
                                          nume: count,
                                        )),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ]),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Savings(balance: newbalance, income:incomevalue, expense:expensevalue,),
                          ),
                        );
                        //user can move to the Savings file
                      },
                      child: Container(
                        //this container is for the bottom buttons for the Svaings,Summery profile and scanner
                        height: 120,
                        width: 140,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.8),
                              spreadRadius: 0,
                              blurRadius:8,
                              offset: Offset(0,3),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Stack(
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                'SAVINGS',
                                style: TextStyle(
                                  fontFamily:'Lexend-VariableFont',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color:Colors.black,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child:Stack(
                                children: [
                                  Icon(
                                    Icons.wallet,
                                    size: 55,
                                    color: Colors.blue,
                                  ),
                                  Positioned(
                                    top:25,
                                    child: Icon(
                                      Icons.currency_bitcoin,
                                      size:35,
                                      color:const Color(0xFFC2DAFF),
                                    ),
                                  ),
                                ],
                              ),
                            )

                          ],
                        ),
                      ),
                    ),
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