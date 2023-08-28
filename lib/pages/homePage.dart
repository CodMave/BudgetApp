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
import '../components/bottomNav.dart';
import 'Profile.dart';
import 'Savings.dart';
import 'Summery.dart';
import 'expenceAndIncome.dart';
import 'goals.dart';

double expensevalue = 0.0;
double incomevalue = 0.0;

class HomePage extends StatelessWidget {
  const HomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(325, 812),
      builder: (context, child) => MaterialApp(
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
List<NotificationData> Listn = [];

class Controller extends StatefulWidget {
  int newbalance = 0;

  final List<NotificationData> notificationList;
  final int num;
  final void Function(int index) onDeleteNotification;

  Controller({
    Key? key,
    required int balance,
    required double expense,
    required double income,
    required this.notificationList,
    required this.num,
    required this.onDeleteNotification,
  }) : super(
            key:
                key) //one of the constructor to get the following values from Menu,Notification files
  {
    newbalance = balance;
    expensevalue = expense;
    incomevalue = income;
    count = num;
    Listn = notificationList;
  }

  @override
  _ControllerState createState() => _ControllerState(
        newbalance: newbalance,
        onDeleteNotification:
            onDeleteNotification, //pass the values to the _ControllerState private class
      );
}

class _ControllerState extends State<Controller> {
  bool isContainerVisible = false;
  final void Function(int index) onDeleteNotification;
  int newbalance = 0;

  _ControllerState(
      {required this.newbalance, required this.onDeleteNotification});

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  SharedPreferences? _prefs; //initialized the sharedpreferances
  static Future<String> getUserName() async {
    //get the username from Profile file
    User? user = _auth
        .currentUser; //created an instance to the User of Firebase authorized
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

  void initState() {
    super.initState();
    saveBalance();
    countPercenntage(); //call to the countpercentage method
    savePercent(); //call to the savethe percentage method
    saveExpenses(); //call to the save the expense method
    saveIncome(); //call to the countIncome method

    loadPercent().then((pqr) {
      //excutes when load the app and keep same percent value otherwise it set to 0.0
      setState(() {
        percent = pqr.toDouble();
      });
    });
    loadexpence().then((qwe) {
      //excutes when load the app and keep same expence value otherwise it set to 0.0
      setState(() {
        expensevalue = qwe.toDouble();
      });
    });
    loadIncome().then((lms) {
      //excutes when load the app and keep same income value otherwise it set to 0.0
      setState(() {
        incomevalue = lms.toDouble();
      });
    });
    loadBalance().then((val) {
      //excutes when load the app and keep same balance value otherwise it set to 0.0
      setState(() {
        newbalance = val;
      });
    });
  }

  Future<void> savePercent() async {
    if (percent != 0.0) {
      final newCount = percent;
      _prefs = await SharedPreferences.getInstance();
      _prefs?.setDouble('newPercent', newCount);
      setState(() {
        percent = newCount;
      });
    }
    if (expensevalue > incomevalue) {
      _prefs = await SharedPreferences.getInstance();
      _prefs?.setDouble('newPercent', 0.0);
      setState(() {
        percent = 0.0;
      });
    }
  }

  Future<void> saveBalance() async {
    if (newbalance != 0) {
      final newCount = newbalance;
      _prefs = await SharedPreferences.getInstance();
      _prefs?.setInt('newBalance', newCount);
      setState(() {
        newbalance = newCount;
      });
    }
  }

  Future<void> saveExpenses() async {
    if (expensevalue != 0.0) {
      final newCount = expensevalue;
      _prefs = await SharedPreferences.getInstance();
      _prefs?.setDouble('newExpense', newCount);
      setState(() {
        expensevalue = newCount;
      });
    }
  }

  Future<void> saveIncome() async {
    if (incomevalue != 0.0) {
      final newCount = incomevalue;
      _prefs = await SharedPreferences.getInstance();
      _prefs?.setDouble('newIncome', newCount);
      setState(() {
        incomevalue = newCount;
      });
    }
  }

  Future<double> loadIncome() async {
    _prefs = await SharedPreferences.getInstance();
    print(_prefs?.getDouble('newIncome'));
    return _prefs?.getDouble('newIncome') ?? 0.0;
  }

  Future<double> loadPercent() async {
    _prefs = await SharedPreferences.getInstance();

    return _prefs?.getDouble('newPercent') ?? 0.0;
  }

  Future<int> loadBalance() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs?.getInt('newBalance') ?? 0;
  }

  Future<double> loadexpence() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs?.getDouble('newExpense') ?? 0.0;
  }

  double countPercenntage() {
    //count the percentage by subtracting expense from income and divide it from the income value
    double difference = incomevalue - expensevalue;
    percent = difference / incomevalue;
    if (percent >= 0 && percent <= 100) {
      return percent;
    } else {
      percent = 0.0;
      return percent;
    }
  }

  void ContainerVisibility() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Stack(
            children: [
              AlertDialog(
                content: Container(
                  alignment: Alignment.center,
                  height: 100,
                  width: 400,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Total Income:',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: FutureBuilder<double>(
                                future: loadIncome(),
                                builder: (context, snapshot) {
                                  return Text(
                                    '${snapshot.data}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                  );
                                }),
                          ),
                          Icon(
                            Icons.arrow_upward,
                            color: Colors.green,
                            size: 28,
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            'Total Expense:',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: FutureBuilder<double>(
                                future: loadexpence(),
                                builder: (context, snapshot) {
                                  return Text(
                                    '${snapshot.data}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                  );
                                }),
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
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.grey[100],
          title: FutureBuilder<String>(
              future: getUserName(),
              builder: (context, snapshot) {
                return Text(
                  "Hello,${snapshot.data}!",
                  //print the user name who are currently using with
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                  ),
                );
              }),
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.black,
            size: 40,
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
          actions: [
            count == 0
                ? IconButton(
                    //if the count value is 0 then badge won't show otherwise it dissplays the unseen notification count
                    onPressed: () {
                      Navigator.push(
                        context,

                        MaterialPageRoute(
                            builder: (context) => Holder(
                                  totalBalance: newbalance,
                                  totalex: expensevalue,
                                  totalin: incomevalue,
                                  notificationList: Listn,
                                  onDeleteNotification: onDeleteNotification,
                                )), //create a constructor to the Holder class to display the notification list
                      );
                    },
                    icon: Icon(
                      Icons.notifications_active_outlined,
                      size: 40,
                    ),
                  )
                : badges.Badge(
                    badgeContent: Text('${count}'),
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
                                    totalex: expensevalue,
                                    totalin: incomevalue,
                                    notificationList: Listn,
                                    onDeleteNotification: onDeleteNotification,
                                  )),
                        );
                      },
                      icon: Icon(
                        Icons.notifications_active_outlined,
                        size: 40,
                      ),
                    ),
                  ),
          ],
          elevation: 0,
        ),

        //bottom navigation bar
        //bottomNavigationBar: BottomNavigation(),
        body: SingleChildScrollView(
          //user allows to scrolldown
          child: Container(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  //container which carries the percentage indicator
                  height: 270,
                  width: 450,
                  decoration: BoxDecoration(
                    color: const Color(0xffEDF2FB),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularPercentIndicator(
                        radius: 120,
                        lineWidth: 30,
                        percent: percent,
                        progressColor: const Color(0xff039EF0),
                        backgroundColor: const Color(0xff181EAA),
                        center: TextButton(
                          onPressed: () {
                            ContainerVisibility();
                          },
                          child: Text(
                            '${(percent * 100).toStringAsFixed(0)}%',
                            //display the percentage
                            style: const TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
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
                              DateFormat('MMMM dd').format(DateTime.now()),
                              //time and date format
                              style: const TextStyle(
                                fontSize: 25,
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
                Container(
                  //this container is for display the balance
                  height: 150,
                  width: 450,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xff90E0EF),
                  ),
                  child: Stack(
                    children: [
                      const Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text(
                            'Balance', //display the text as 'Balance'
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 30,
                        right: 30,
                        child: Container(
                          //this container shows the balance as value
                          height: 90,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                            ),
                            color: Color(0xff86D5FF),
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                '\$ ${newbalance.toString()}',
                                //display the balance as String
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 22),
                    child: Text(
                      'Activity',
                      //display the text As Activity bellow the balance Container
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  //this shows the recent transactions with the balance
                  child: Row(
                    children: [
                      Container(
                        height: 120,
                        width: 220,
                        margin: const EdgeInsets.only(top: 5, left: 20),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color(0xff86D5FF),
                        ),
                        child: Stack(children: [
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.only(top: 5, left: 5),
                              child: Text(
                                'Recent', //print the text as 'Recent'
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
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
                                    color: const Color(0xff181EAA),
                                    width: 3.0,
                                  ),
                                ),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      FontAwesomeIcons.car,
                                      size: 40,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      print('clicked');
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Expence(
                                            nume: count,
                                            notificationList: Listn,
                                            onDeleteNotification:
                                                onDeleteNotification,
                                          ),
                                        ),
                                      );
                                    },
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
                                    color: const Color(0xff181EAA),
                                    width: 3.0,
                                  ),
                                ),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      FontAwesomeIcons.burger,
                                      size: 40,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      print('clicked');
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Expence(
                                                nume: count,
                                                notificationList: Listn,
                                                onDeleteNotification:
                                                    onDeleteNotification)),
                                      );
                                    },
                                  ),
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
                                    color: Colors.grey,
                                    width: 3.0,
                                  ),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    FontAwesomeIcons.plus,
                                    size: 30,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Expence(
                                              nume: count,
                                              notificationList: Listn,
                                              onDeleteNotification:
                                                  onDeleteNotification)),
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
                                  Savings(balance: newbalance),
                            ),
                          );
                          //user can move to the Savings file
                        },
                        child: Container(
                          //this container is for the bottom buttons for the Svaings,Summery profile and scanner
                          height: 120,
                          width: 140,
                          margin: const EdgeInsets.only(
                            top: 5,
                            left: 10,
                          ),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Color(0xff86D5FF),
                          ),
                          child: const Stack(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: 0,
                                    left: 5,
                                  ),
                                  child: Text(
                                    'Savings',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Image(
                                  width: 80,
                                  height: 80,
                                  image: AssetImage(
                                      'lib/images/Savings.png'), //savings image
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Pro()),
                        );
                      },
                      child: Container(
                        height: 80,
                        width: 80,
                        margin: const EdgeInsets.only(top: 15, left: 5),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color(0xff86D5FF),
                        ),
                        child: const Align(
                          alignment: Alignment.center,
                          child: Image(
                            width: 60,
                            height: 60,
                            image: AssetImage(
                                'lib/images/Income.png'), //income image
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        print("Summary");
                      },
                      child: Container(
                        height: 80,
                        width: 80,
                        margin: const EdgeInsets.only(top: 15),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color(0xff86D5FF),
                        ),
                        child: const Align(
                          alignment: Alignment.center,
                          child: Image(
                            width: 80,
                            height: 80,
                            image: AssetImage(
                                'lib/images/Summery.png'), //summery image
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // on click to goals
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Goals()),
                        );
                      },
                      child: Container(
                        height: 80,
                        width: 80,
                        margin: const EdgeInsets.only(top: 15),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color(0xff86D5FF),
                        ),
                        child: const Align(
                          alignment: Alignment.center,
                          child: Image(
                            width: 60,
                            height: 60,
                            image: AssetImage(
                                'lib/images/Profile.png'), //profile image
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        print("Novelty");
                      },
                      child: Container(
                        height: 80,
                        width: 80,
                        margin: const EdgeInsets.only(top: 15),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color(0xff86D5FF),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
