import 'package:budgettrack/pages/plans.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'TextScanner.dart';
import 'goals.dart';
import 'homePage.dart';
import 'package:intl/intl.dart';

class Pro extends StatefulWidget {
  @override
  _ProState createState() => _ProState();
}

class _ProState extends State<Pro> {
  List<String>? items = [];
  List<String>? itemsformonth = [];
  List<String>? itemsforyear = [];
  String currencySymbol = '';
  int weekincome = 0;
  int weekexpense = 0;
  List<int>? uniqueexpenses = [];
  List<int>? uniqueexpensesformonth = [];
  List<int>? uniqueexpensesforyear = [];
  List<int>? savings = [0, 0, 0, 0, 0, 0, 0];
  List<int>? expense = [0, 0, 0, 0, 0, 0, 0];
  List<int>? yearly_expense = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  List<int>? yearly_savings = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  List<int>? yearly_income = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  String incomedayname = '', expensedayname = '';
  bool showContainer1 = false;
  bool showContainer2 = false;
  bool showContainer3 = false;
  bool showTitle = false;
  DateTime currentDate = DateTime.now();
  List<int>? monthlyincome = [];
  List<int>? monthlyexpense = [];
  List<int>? monthlysavings = [];
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  Color dailyButtonColor = const Color.fromARGB(255, 24, 30, 170);
  late DateTime startDate;
  late DateTime endDate;
  late DateTime startDateofMonth;
  late DateTime endDateofMonth;
  late DateTime startDateofyear;
  late DateTime endDateofyear;
  int totalincomeformonth = 0, totalexpenseformonth = 0;

  void _showContainer(int containerNumber) {
    setState(() {
      showContainer1 = containerNumber == 1;
      showContainer2 = containerNumber == 2;
      showContainer3 = containerNumber == 3;
    });
  }

  final dateFormat = DateFormat('dd-MM-yyyy');


  Future<List<String>?> getexpenseNameforweek() async {
    try {
      User? user = _auth.currentUser;
      username = user!.uid;
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      Set<String> items = Set<String>(); // Use a Set instead of List

      final expenceSnapshot = await firestore
          .collection('userDetails')
          .doc(username)
          .collection('expenceID')
          .get();

      expenceSnapshot.docs.forEach((expence1Doc) {
        final timestamp = expence1Doc.get('timestamp') as Timestamp;
        final timestampDate = timestamp.toDate();

        // Check if the timestampDate is within the startDate and endDate range
        if (timestampDate.isAfter(startDate) &&
            timestampDate.isBefore(endDate)) {
          // Store the expense name in the Set
          items.add(expence1Doc.get('transactionName'));
        } else if ((dateFormat.format(timestampDate) ==
                dateFormat.format(startDate)) ||
            (dateFormat.format(timestampDate) == dateFormat.format(endDate))) {
          print(dateFormat);
          items.add(expence1Doc.get('transactionName'));
        }
      });

      return items.toList(); // Convert the Set to a List if needed
    } catch (ex) {
      print('Calculating weekly expenses failed: $ex');
      return null;
    }
  }

  Future<List<String>?> getExpenseNamesForMonth() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return null;

      String username = user.uid;
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      Set<String> items = Set<String>(); // Using a Set to store unique expense names

      DateTime now = DateTime.now();
      int currentYear = now.year;
      int currentMonth = now.month;

      final expenseSnapshot = await firestore
          .collection('userDetails')
          .doc(username)
          .collection('expenceID')
          .get();

      expenseSnapshot.docs.forEach((expense3Doc) {
        final timestamp = expense3Doc.get('timestamp') as Timestamp;
        final timestampDate = timestamp.toDate();

        if (timestampDate.year == currentYear &&
            timestampDate.month == currentMonth) {
          items.add(expense3Doc.get('transactionName'));
        }
      });
      print('Items lngth is ${items.length}');
      return items.toList(); // Convert the Set to a List if needed
    } catch (ex) {
      print('Calculating monthly expenses failed: $ex');
      return null;
    }
  }

  Future<List<String>?> getExpenseNamesForYear() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return null;

      String username = user.uid;
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      Set<String> items =
          Set<String>(); // Using a Set to store unique expense names

      DateTime now = DateTime.now();
      int currentYear = now.year;
      final expenseSnapshot = await firestore
          .collection('userDetails')
          .doc(username)
          .collection('expenceID')
          .get();

      expenseSnapshot.docs.forEach((expense6Doc) {
        final timestamp = expense6Doc.get('timestamp') as Timestamp;
        final timestampDate = timestamp.toDate();

        if (timestampDate.year == currentYear) {
          items.add(expense6Doc.get('transactionName'));
        }
      });
      print('Items lngth is ${items.length}');
      return items.toList(); // Convert the Set to a List if needed
    } catch (ex) {
      print('Calculating yearly expenses failed: $ex');
      return null;
    }
  }

  Future<List<int>?> getSumOfTransactionAmountsForUniqueExpenses() async {
    try {
      User? user = _auth.currentUser;
      username = user!.uid;
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      List<String> items = [];
      List<int> transactionAmounts = [];

      final expenceSnapshot = await firestore
          .collection('userDetails')
          .doc(username)
          .collection('expenceID')
          .get();

      expenceSnapshot.docs.forEach((expence2Doc) {
        final timestamp = expence2Doc.get('timestamp') as Timestamp;
        final timestampDate = timestamp.toDate();
        if (timestampDate.isAfter(startDate) &&
            timestampDate.isBefore(endDate)) {
          items.add(expence2Doc.get('transactionName'));
          transactionAmounts.add(expence2Doc.get('transactionAmount'));
        } else if ((dateFormat.format(timestampDate) ==
                dateFormat.format(startDate)) ||
            (dateFormat.format(timestampDate) == dateFormat.format(endDate))) {
          items.add(expence2Doc.get('transactionName'));
          transactionAmounts.add(expence2Doc.get('transactionAmount'));
        }
      });

      List<int> totalTransactionAmounts = [];
      Set<String> uniqueNames = items.toSet();

      for (String currentName in uniqueNames) {
        int sum = 0;

        for (int i = 0; i < items.length; i++) {
          if (items[i] == currentName) {
            sum += transactionAmounts[i];
          }
        }
        totalTransactionAmounts.add(sum);
      }

      return totalTransactionAmounts;
    } catch (ex) {
      print('Calculating weekly expenses failed: $ex');
      return null;
    }
  }

  Future<List<int>?>
      getSumOfTransactionAmountsForUniqueExpensesForMonth() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return null;

      String username = user.uid;
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      DateTime now = DateTime.now();
      int currentYear = now.year;
      int currentMonth = now.month;

      List<String> items = [];
      List<int> transactionAmounts = [];

      final expenseSnapshot = await firestore
          .collection('userDetails')
          .doc(username)
          .collection('expenceID')
          .get();

      expenseSnapshot.docs.forEach((expense4Doc) {
        final timestamp = expense4Doc.get('timestamp') as Timestamp;
        final timestampDate = timestamp.toDate();

        if (timestampDate.year == currentYear &&
            timestampDate.month == currentMonth) {
          items.add(expense4Doc.get('transactionName'));
          transactionAmounts.add(expense4Doc.get('transactionAmount'));
        }
      });

      List<int> totalTransactionAmounts = [];
      Set<String> uniqueNames = items.toSet();

      for (String currentName in uniqueNames) {
        int sum = 0;

        for (int i = 0; i < items.length; i++) {
          if (items[i] == currentName) {
            sum += transactionAmounts[i];
          }
        }
        totalTransactionAmounts.add(sum);
      }
      print('Transaction array size${totalTransactionAmounts.length}');
      return totalTransactionAmounts;
    } catch (ex) {
      print('Calculating monthly expenses failed: $ex');
      return null;
    }
  }

  Future<List<int>?>
      getSumOfTransactionAmountsForUniqueExpensesForYear() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return null;

      String username = user.uid;
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      DateTime now = DateTime.now();
      int currentYear = now.year;
      List<String> items = [];
      List<int> transactionAmounts = [];

      final expenseSnapshot = await firestore
          .collection('userDetails')
          .doc(username)
          .collection('expenceID')
          .get();

      expenseSnapshot.docs.forEach((expense7Doc) {
        final timestamp = expense7Doc.get('timestamp') as Timestamp;
        final timestampDate = timestamp.toDate();

        if (timestampDate.year == currentYear) {
          items.add(expense7Doc.get('transactionName'));
          transactionAmounts.add(expense7Doc.get('transactionAmount'));
        }
      });

      List<int> totalTransactionAmounts = [];
      Set<String> uniqueNames = items.toSet();

      for (String currentName in uniqueNames) {
        int sum = 0;

        for (int i = 0; i < items.length; i++) {
          if (items[i] == currentName) {
            sum += transactionAmounts[i];
          }
        }
        totalTransactionAmounts.add(sum);
      }
      print('Transaction array size${totalTransactionAmounts.length}');
      return totalTransactionAmounts;
    } catch (ex) {
      print('Calculating yearly expenses failed: $ex');
      return null;
    }
  }

  Future<List<int>?> getTotalExpensesForWeek() async {
    try {
      User? user = _auth
          .currentUser; // created an instance to the User of Firebase authorized
      username = user!.uid;
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      List<int> weeklyExpenses = [0, 0, 0, 0, 0, 0, 0]; // Initialize the array
      final expenceSnapshot = await firestore
          .collection('userDetails')
          .doc(username)
          .collection('expenceID')
          .get();

      expenceSnapshot.docs.forEach((expenceDoc) {
        final timestamp = expenceDoc.get('timestamp') as Timestamp;
        final timestampDate = timestamp.toDate();

        // Check if the timestampDate is within the startDate and endDate range
        if (timestampDate.isAfter(startDate) &&
            timestampDate.isBefore(endDate)) {
          // Get the day of the week (0 for Monday, 1 for Tuesday, etc.)
          int dayOfWeek = timestampDate.weekday - 1; // Adjust to 0-based index

          // Accumulate the expense in the corresponding day's index
          weeklyExpenses[dayOfWeek] +=
              (expenceDoc.get('transactionAmount') as num).toInt();
        } else if ((dateFormat.format(timestampDate) ==
                dateFormat.format(startDate)) ||
            (dateFormat.format(timestampDate) == dateFormat.format(endDate))) {
          int dayOfWeek = timestampDate.weekday - 1;
          weeklyExpenses[dayOfWeek] +=
              (expenceDoc.get('transactionAmount') as num).toInt();
        }
      });

      return weeklyExpenses;
    } catch (ex) {
      print('Calculating weekly expenses failed: $ex');
      return null;
    }
  }

  Future<List<int>?> getTotalExpenseForMonth() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return null;

      String username = user.uid;
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      DateTime now = DateTime.now();
      int currentYear = now.year;
      int currentMonth = now.month;
      int currentDay=now.day;
   List<int> monthlyExpense = List.filled(currentDay, 0);

      final expenseSnapshot = await firestore
          .collection('userDetails')
          .doc(username)
          .collection('expenceID')
          .get();

      expenseSnapshot.docs.forEach((expense2Doc) {
        final timestamp = expense2Doc.get('timestamp') as Timestamp;
        final timestampDate = timestamp.toDate();

        if (timestampDate.year == currentYear &&
            timestampDate.month == currentMonth) {
          int dayOfMonth = timestampDate.day - 1;
          monthlyExpense[dayOfMonth] +=
              (expense2Doc.get('transactionAmount') as num).toInt();
        }
      });

      return monthlyExpense;
    } catch (ex) {
      print('Calculating monthly income failed: $ex');
      return null;
    }
  }

  Future<List<int>?> getTotalExpenseForYear() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return null;

      String username = user.uid;
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      DateTime now = DateTime.now();
      int currentYear = now.year;

      List<int> yearlyExpenses = List.filled(12, 0);

      final expenseSnapshot = await firestore
          .collection('userDetails')
          .doc(username)
          .collection('expenceID')
          .get();

      expenseSnapshot.docs.forEach((expense20Doc) {
        final timestamp = expense20Doc.get('timestamp') as Timestamp;
        print(timestamp);
        final timestampDate = timestamp.toDate();
        int yearDifference = timestampDate.year - currentYear;

        if (yearDifference >= 0 && yearDifference < 12) {
          yearlyExpenses[yearDifference] +=
              (expense20Doc.get('transactionAmount') as num).toInt();
        }
      });

      return yearlyExpenses;
    } catch (ex) {
      print('Calculating yearly expenses failed: $ex');
      return null;
    }
  }

  void updateWeekDates() {
    DateTime now = DateTime.now();
    int currentDayOfWeek = now.weekday;
    int daysUntilMonday = (currentDayOfWeek - 1) % 7;

    DateTime weekStart = now.subtract(Duration(days: daysUntilMonday));
    DateTime weekEnd = weekStart.add(Duration(days: 6));

    setState(() {
      startDate = weekStart;
      endDate = weekEnd;
    });
  }

  void updateMonthDates() {
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    setState(() {
      startDateofMonth = firstDayOfMonth;
      endDateofMonth = lastDayOfMonth;
    });
  }

  void updateYearDates() {
    DateTime now = DateTime.now();
    DateTime firstDayOfYear = DateTime(now.year, 1, 1);
    DateTime lastDayOfYear = DateTime(now.year, 12, 31);

    setState(() {
      startDateofyear = firstDayOfYear;
      endDateofyear = lastDayOfYear;
    });
  }

  Future<List<int>?> getTotalIncomeForWeek() async {
    try {
      User? user = _auth
          .currentUser; // created an instance to the User of Firebase authorized
      username = user!.uid;
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      List<int> weeklyIncome = [0, 0, 0, 0, 0, 0, 0]; // Initialize the array

      final expenceSnapshot = await firestore
          .collection('userDetails')
          .doc(username)
          .collection('incomeID')
          .get();

      expenceSnapshot.docs.forEach((incomeDoc) {
        final timestamp = incomeDoc.get('timestamp') as Timestamp;
        final timestampDate = timestamp.toDate();

        // Check if the timestampDate is within the startDate and endDate range
        if (timestampDate.isAfter(startDate) &&
            timestampDate.isBefore(endDate)) {
          // Get the day of the week (0 for Monday, 1 for Tuesday, etc.)
          int dayOfWeek = timestampDate.weekday - 1; // Adjust to 0-based index

          // Accumulate the expense in the corresponding day's index
          weeklyIncome[dayOfWeek] +=
              (incomeDoc.get('transactionAmount') as num).toInt();
        } else if ((dateFormat.format(timestampDate) ==
                dateFormat.format(startDate)) ||
            (dateFormat.format(timestampDate) == dateFormat.format(endDate))) {
          int dayOfWeek = timestampDate.weekday - 1;
          weeklyIncome[dayOfWeek] +=
              (incomeDoc.get('transactionAmount') as num).toInt();
        }
      });

      return weeklyIncome;
    } catch (ex) {
      print('Calculating weekly income failed: $ex');
      return null;
    }
  }

  Future<List<int>?> getTotalIncomeForMonth() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return null;

      String username = user.uid;
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      DateTime now = DateTime.now();
      int currentYear = now.year;

      int currentMonth = now.month;
      int currentDay=now.day;

      List<int> monthlyIncome = List.filled(currentDay, 0);

      final expenseSnapshot = await firestore
          .collection('userDetails')
          .doc(username)
          .collection('incomeID')
          .get();

      expenseSnapshot.docs.forEach((income2Doc) {
        final timestamp = income2Doc.get('timestamp') as Timestamp;
        final timestampDate = timestamp.toDate();

        if (timestampDate.year == currentYear &&
            timestampDate.month == currentMonth) {
          int dayOfMonth = timestampDate.day - 1;
          monthlyIncome[dayOfMonth] +=
              (income2Doc.get('transactionAmount') as num).toInt();
        }
      });

      return monthlyIncome;
    } catch (ex) {
      print('Calculating monthly income failed: $ex');
      return null;
    }
  }

  Future<List<int>?> getTotalIncomeForYear() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return null;

      String username = user.uid;
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      DateTime now = DateTime.now();

      int currentYear = now.year;

      List<int> yearlyIncome = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

      final expenseSnapshot = await firestore
          .collection('userDetails')
          .doc(username)
          .collection('incomeID')
          .get();

      expenseSnapshot.docs.forEach((income20Doc) {
        final timestamp = income20Doc.get('timestamp') as Timestamp;
        print(timestamp);
        final timestampDate = timestamp.toDate();
        int yearDifference = timestampDate.year - currentYear;

        if (yearDifference >= 0 && yearDifference < 12) {
          yearlyIncome[yearDifference] +=
              (income20Doc.get('transactionAmount') as num).toInt();
        }
      });

      return yearlyIncome;
    } catch (ex) {
      print('Calculating yearly income failed: $ex');
      return null;
    }
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

  int getLastTwoDigitsOfCurrentYear() {
    DateTime now = DateTime.now();
    int currentYear = now.year;

    // Get the last two digits of the current year
    int lastTwoDigits = currentYear % 100;

    return lastTwoDigits;
  }

  Future<void> _fetchTotalExpensesAndIncome() async {
    try {
      final totalincomeforyear = await getTotalIncomeForYear();
      final totincomeformonth = await getTotalIncomeForMonth();
      final totexpenseformonth = await getTotalExpenseForMonth();
      final totalexpenseforyear = await getTotalExpenseForYear();
      final totalExpenses = await getTotalExpensesForWeek();
      final totalIncome = await getTotalIncomeForWeek();
      final expenseNames = await getexpenseNameforweek();
      final expenseNamesformonth = await getExpenseNamesForMonth();
      final expenseNamesforyear = await getExpenseNamesForYear();
      final amount = await getSumOfTransactionAmountsForUniqueExpenses();
      final amountformonth =
          await getSumOfTransactionAmountsForUniqueExpensesForMonth();
      final amountforyear =
          await getSumOfTransactionAmountsForUniqueExpensesForYear();


      setState(() {
        this.yearly_expense = totalexpenseforyear;
        this.uniqueexpensesformonth = amountformonth;
        this.uniqueexpensesforyear = amountforyear;
        this.monthlyexpense = totexpenseformonth;
        this.monthlyincome = totincomeformonth;
        this.uniqueexpenses = amount;
        items = expenseNames;
        this.itemsformonth = expenseNamesformonth;
        this.itemsforyear = expenseNamesforyear;
        expense = totalExpenses;
        savings = totalIncome;
        this.yearly_income = totalincomeforyear;
        for (int i = 0; i < 7; i++) {
          this.weekexpense = weekexpense + totalExpenses![i];
          this.weekincome = weekincome + totalIncome![i];
          savings![i] = totalIncome![i] - totalExpenses![i];
          if (savings![i] < 0) {
            savings![i] = 0;
          }
        }

        for(int i=0;i<monthlyexpense!.length;i++){
          this.totalexpenseformonth=this.totalexpenseformonth+monthlyexpense![i];
        }
        for(int i=0;i<monthlyincome!.length;i++){
          this.totalincomeformonth=this.totalincomeformonth+monthlyincome![i];
        }
        for (int i = 0; i < this.yearly_savings!.length; i++) {
          yearly_savings![i] = totalincomeforyear![i] - this.yearly_expense![i];
          if (yearly_savings![i] < 0) {
            yearly_savings![i] = 0;
          }
        }

      });

    } catch (ex) {
      print('Fetching expenses and income failed: $ex');
    }
    for (int i = 0; i < 7; i++) {
      print(expense![i]);
    }
  }

  void initState() {
    super.initState();
    getDocIds();
    updateWeekDates();
    updateMonthDates();
    updateYearDates();
    _showContainer(1);
    _fetchTotalExpensesAndIncome();

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
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Icon(
            Icons.align_vertical_bottom_outlined,
            size: 30,
            color: Color(0xFF3AC6D5),
          ),
        ],
        title: const Text('S U M M E R Y',
            style: TextStyle(
              color: const Color(0xFF090950),
              fontSize: 20,
              fontFamily: 'Lexend-VariableFont',
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
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 1,
                width: double.infinity,
                color: Colors.grey,
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _showContainer(1);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
                          side: BorderSide(
                            color:Colors.grey, // Set the border color
                            width: 2, // Set the border width
                          ),
                        ),
                        onSurface: Color.fromARGB(255, 113, 120, 222),
                      ),
                      child: Text(
                        'Weekly',
                        style: TextStyle(
                          fontFamily: 'Lexend-VariableFont',
                          fontSize: 15,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _showContainer(2);
                      },
                      style: ElevatedButton.styleFrom(

                        primary: Colors.white,
                        onPrimary: Colors.grey,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color:Colors.grey, // Set the border color
                            width: 2, // Set the border width
                          ),
                        ),
                        onSurface: Color.fromARGB(255, 113, 120, 222),
                      ),
                      child: Text(
                        'Monthly',
                        style: TextStyle(
                          fontFamily: 'Lexend-VariableFont',
                          fontSize: 15,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _showContainer(3);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20)),
                          side: BorderSide(
                            color:Colors.grey, // Set the border color
                            width: 2, // Set the border width
                          ),
                        ),
                        onSurface: Color.fromARGB(255, 113, 120, 222),
                      ),
                      child: Text(
                        'Yearly',
                        style: TextStyle(
                          fontFamily: 'Lexend-VariableFont',
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: showContainer1,
                child: Column(
                  children: [
                    SizedBox(height: 15),
                    Container(
                      height: 30,
                      width:250,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${DateFormat('MMM dd, yyyy').format(startDate)} - ${DateFormat('MMM dd, yyyy').format(endDate)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Lexend-VariableFont',
                                  color: Color.fromARGB(255, 92, 118, 140),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 400,
                      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 238, 238, 238),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                ),
                                child: Container(

                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:Colors.white,
                                  ),
                                  child:      Icon(Icons.add_card_rounded,
                                      color: const Color(0xFF3AC6D5),),
                                ),
                              ),

                              Text(
                                'Income',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                '$currencySymbol ${this.weekincome.toStringAsFixed(2)}', // Display the income here
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF3AC6D5),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 50,
                      width: 400,
                      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 238, 238, 238),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                ),
                                child: Container(

                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:Colors.white,
                                  ),
                                  child: Icon(Icons.add_card_rounded,
                                      color: const Color(0xFF090950)),
                                ),
                              ),


                              Text(
                                'Expense',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                '$currencySymbol ${this.weekexpense.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF090950),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Divider(
                      // Add a Divider here
                      height: 3, // You can adjust the height of the divider
                      thickness:
                          1, // You can adjust the thickness of the divider
                      color:
                          Colors.grey, // You can set the color of the divider
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0, left: 30),
                        child: Text('Over View',
                            style: TextStyle(
                              fontFamily: 'Lexend-VariableFont',
                              fontSize: 15,
                              color: const Color(0xFF090950),
                            )),
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          height: 200,
                          width: 400,
                          margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: BarChart(
                            BarChartData(
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: false,
                                  ),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: false,
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    reservedSize: 30,
                                    showTitles: true,
                                  ),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: false,
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              gridData: FlGridData(show: false),
                              barGroups: [
                                for(int i=0;i<savings!.length;i++)
                                BarChartGroupData(
                                  x: i+1,
                                  barRods: [
                                    BarChartRodData(
                                        toY: this.savings![i].toDouble(),
                                        width: 15,
                                        color:  Color.fromARGB(255, 134, 209, 249),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(6),
                                            topRight: Radius.circular(6),
                                          ),
                                        ),
                                    BarChartRodData(
                                        toY: expense![i].toDouble(),
                                        width: 15,
                                        color:const Color(0xFF090950),

                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(6),
                                          topRight: Radius.circular(6),
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width:
                                      10, // Adjust the width and height as needed
                                  height: 10,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromARGB(255, 134, 209, 249),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5), // Adjust top padding here
                                  child: Text(
                                    'Savings',
                                    style: const TextStyle(
                                      fontFamily: 'Lexend-VariableFont',
                                      fontSize: 10,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10, top: 0),
                                  width:
                                      10, // Adjust the width and height as needed
                                  height: 10,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFF090950),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 0.0,
                                      left: 5), // Adjust top padding here
                                  child: Text(
                                    'Expenses',
                                    style: TextStyle(
                                      fontFamily: 'Lexend-VariableFont',
                                      fontSize: 10,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          height: 150,
                          width: 400,
                          child: Scrollbar(
                            child: RefreshIndicator(
                              onRefresh: () async {
                                //  await updateBalance();
                              },
                              child: ListView.builder(
                                itemCount: this.items?.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      ListTile(
                                        title:Row(

                                          children: [
                                            SizedBox(
                                              width:130,
                                              child: Align(
                                                alignment:
                                                    Alignment.center,
                                                child: Text(
                                                  items![index],
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'Lexend-VariableFont',
                                                    color: const Color(
                                                        0xFF090950),
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            SizedBox(
                                              width:120,
                                              child: Text(
                                                '$currencySymbol ${uniqueexpenses![index].toStringAsFixed(2)}',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  fontFamily:
                                                  'Lexend-VariableFont',
                                                  color: Color.fromARGB(
                                                      236, 97, 183, 226),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Container(
                                              height: 20,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                color: Color.fromARGB(
                                                    255, 183, 203, 250),
                                                borderRadius:
                                                BorderRadius
                                                    .circular(10),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '${((uniqueexpenses![index] / weekexpense) * 100).toInt()}%',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    fontFamily:
                                                    'Lexend-VariableFont',
                                                    color: Color(
                                                        0xFC0095F2),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (index < items!.length - 1)
                                        Divider(
                                          height: 0,
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: showContainer2,
                child: Column(
                  children: [
                    SizedBox(height: 15),
                    Container(
                      height: 30,
                      width:250,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${DateFormat('MMM dd, yyyy').format(this.startDateofMonth)} - ${DateFormat('MMM dd, yyyy').format(this.endDateofMonth)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Lexend-VariableFont',
                                  color: Color.fromARGB(255, 92, 118, 140),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 400,
                      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 238, 238, 238),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                ),
                                child: Container(

                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:Colors.white,
                                  ),
                                  child:      Icon(Icons.add_card_rounded,
                                    color: const Color(0xFF3AC6D5),),
                                ),
                              ),
                              Text(
                                'Income',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                '$currencySymbol ${this.totalincomeformonth.toDouble()}', // Display the income here
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF090950),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 50,
                      width: 400,
                      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 238, 238, 238),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                ),
                                child: Container(

                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:Colors.white,
                                  ),
                                  child:      Icon(Icons.add_card_rounded,
                                    color: Color(0xFF090950),),
                                ),
                              ),
                              Text(
                                'Expense',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                '$currencySymbol ${this.totalexpenseformonth.toDouble()}',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF090950),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Divider(
                      // Add a Divider here
                      height: 3, // You can adjust the height of the divider
                      thickness:
                          1, // You can adjust the thickness of the divider
                      color:
                          Colors.grey, // You can set the color of the divider
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0, left: 30),
                        child: Text('Over View',
                            style: TextStyle(
                              fontFamily: 'Lexend-VariableFont',
                              fontSize: 15,
                              color: const Color(0xFF090950),
                            )),
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          height: 200,
                          width: 450,
                          margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: LineChart(
                            LineChartData(
                              gridData: FlGridData(show: true),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    reservedSize: 30,
                                    showTitles: true,
                                  ),
                                ),
                          leftTitles:  AxisTitles(
                            sideTitles: SideTitles(
                              reservedSize: 30,
                              showTitles: false,
                            ),
                          ),
                                rightTitles:  AxisTitles(
                                  sideTitles: SideTitles(
                                    reservedSize: 30,
                                    showTitles: false,
                                  ),
                                ),
                                topTitles:  AxisTitles(
                                  sideTitles: SideTitles(
                                    reservedSize: 30,
                                    showTitles: false,
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(
                                show: false,
                                border: Border.all(
                                  color: const Color(0xff37434d),
                                  width: 1,
                                ),
                              ),
                              minX: 1,
                              maxX: 31, // Adjust the maximum X value for the number of months
                              minY: 0,
                              maxY:
                                  100000, // Adjust the maximum Y value as needed
                              lineBarsData: [
                                LineChartBarData(
                                  spots: [
                                    for (int i = 0;i < this.monthlyexpense!.length; i++)
                                      monthlyincome![i].toDouble()-monthlyexpense![i].toDouble()<0?
                                      FlSpot(i+1.toDouble(), 0):
                                      FlSpot(i+1.toDouble(), monthlyincome![i].toDouble()-monthlyexpense![i].toDouble()),
                                  ],
                                  isCurved: true,
                                  color: const  Color.fromARGB(255, 134, 209, 249),
                                  dotData: FlDotData(show: true),
                                  belowBarData: BarAreaData(show: false),
                                ),
                                LineChartBarData(
                                  spots: [
                                    for (int i = 0;i < this.monthlyexpense!.length; i++)
                                      FlSpot(i+1.toDouble(), monthlyexpense![i].toDouble()),
                                  ],
                                  isCurved:true,
                                  color: const Color(0xFF090950),
                                  dotData: FlDotData(show:true),
                                  belowBarData: BarAreaData(show: false),
                                ),

                              ],

                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width:
                                      10, // Adjust the width and height as needed
                                  height: 10,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:Color.fromARGB(255, 134, 209, 249),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5), // Adjust top padding here
                                  child: Text(
                                    'Savings',
                                    style: const TextStyle(
                                      fontFamily: 'Lexend-VariableFont',
                                      fontSize: 10,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10, top: 0),
                                  width:
                                      10, // Adjust the width and height as needed
                                  height: 10,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:const Color(0xFF090950),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 0.0,
                                      left: 5), // Adjust top padding here
                                  child: Text(
                                    'Expenses',
                                    style: TextStyle(
                                      fontFamily: 'Lexend-VariableFont',
                                      fontSize: 10,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          height: 150,
                          width: 400,
                          child: Scrollbar(
                            child: RefreshIndicator(
                              onRefresh: () async {
                                //  await updateBalance();
                              },
                              child: ListView.builder(
                                itemCount: this.itemsformonth?.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      ListTile(
                                        title: Row(
                                          children: [
                                            SizedBox(
                                              width:130,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.only(
                                                        left: 5.0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.center,
                                                  child: Text(
                                                    itemsformonth![index],
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Lexend-VariableFont',
                                                      color: const Color(
                                                          0xFF090950),
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width:20),
                                            SizedBox(
                                              width:100,
                                              child: Text(
                                                '$currencySymbol ${uniqueexpensesformonth![index]}',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight:
                                                      FontWeight.bold,
                                                  fontFamily:
                                                      'Lexend-VariableFont',
                                                  color: Color.fromARGB(
                                                      236, 97, 183, 226),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width:20),
                                            Container(
                                              height: 20,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                color: Color.fromARGB(
                                                    255, 183, 203, 250),
                                                borderRadius:
                                                    BorderRadius
                                                        .circular(10),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '${((uniqueexpensesformonth![index] / totalexpenseformonth) * 100).toInt()}%',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    fontFamily:
                                                        'Lexend-VariableFont',
                                                    color: Color(
                                                        0xFC0095F2),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (index < itemsformonth!.length - 1)
                                        Divider(
                                          height: 0,
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: showContainer3,
                child: Column(
                  children: [
                    SizedBox(height: 15),
                    Container(
                      height: 30,
                      width:250,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${DateFormat('MMM dd, yyyy').format(this.startDateofyear)} - ${DateFormat('MMM dd, yyyy').format(this.endDateofyear)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Lexend-VariableFont',
                                  color: Color.fromARGB(255, 92, 118, 140),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 400,
                      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 238, 238, 238),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                ),
                                child: Container(

                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:Colors.white,
                                  ),
                                  child:      Icon(Icons.add_card_rounded,
                                    color: const Color(0xFF3AC6D5),),
                                ),
                              ),

                              Text(
                                'Income',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                '$currencySymbol ${this.yearly_income![2023 % 100 - (currentDate.year.toInt() % 100)].toDouble()}',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF090950),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 50,
                      width: 400,
                      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 238, 238, 238),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                ),
                                child: Container(

                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:Colors.white,
                                  ),
                                  child:      Icon(Icons.add_card_rounded,
                                    color: const  Color(0xFF090950)),
                                ),
                              ),
                              Text(
                                'Expense',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                '$currencySymbol ${this.yearly_expense![2023 % 100 - (currentDate.year.toInt() % 100)].toDouble()}',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF090950),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Divider(
                      // Add a Divider here
                      height: 3, // You can adjust the height of the divider
                      thickness:
                          1, // You can adjust the thickness of the divider
                      color:
                          Colors.grey, // You can set the color of the divider
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0, left: 30),
                        child: Text('Over View',
                            style: TextStyle(
                              fontFamily: 'Lexend-VariableFont',
                              fontSize: 15,
                              color: const Color(0xFF090950),
                            )),
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          height: 200,
                          width: 500,
                          margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: BarChart(
                            BarChartData(
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    reservedSize:30,
                                    showTitles: true,
                                  ),
                                ),
                                leftTitles:  AxisTitles(
                                  sideTitles: SideTitles(
                                    reservedSize: 30,
                                    showTitles: false,
                                  ),
                                ),
                                rightTitles:  AxisTitles(
                                  sideTitles: SideTitles(
                                    reservedSize: 30,
                                    showTitles: false,
                                  ),
                                ),
                                topTitles:  AxisTitles(
                                  sideTitles: SideTitles(
                                    reservedSize: 30,
                                    showTitles: false,
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              gridData: FlGridData(show: false),
                              barGroups: [
                                for(int i=0;i<yearly_savings!.length;i++)
                                BarChartGroupData(
                                  x: i+22,
                                  barRods: [
                                    BarChartRodData(
                                        toY:
                                            this.yearly_savings![i].toDouble(),
                                        width: 15,
                                        color:  Color.fromARGB(255, 134, 209, 249),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(0),
                                        )),

                                    BarChartRodData(
                                        toY:
                                            this.yearly_expense![i].toDouble(),
                                        width: 15,
                                        color:
                                        const Color(0xFF090950),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(0),
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width:
                                      10, // Adjust the width and height as needed
                                  height: 10,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromARGB(255, 134, 209, 249),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5), // Adjust top padding here
                                  child: Text(
                                    'Savings',
                                    style: const TextStyle(
                                      fontFamily: 'Lexend-VariableFont',
                                      fontSize: 10,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10, top: 0),
                                  width:
                                      10, // Adjust the width and height as needed
                                  height: 10,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFF090950),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 0.0,
                                      left: 5), // Adjust top padding here
                                  child: Text(
                                    'Expenses',
                                    style: TextStyle(
                                      fontFamily: 'Lexend-VariableFont',
                                      fontSize: 10,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          height: 150,
                          width: 400,
                          child: Scrollbar(
                            child: RefreshIndicator(
                              onRefresh: () async {
                                //  await updateBalance();
                              },
                              child: ListView.builder(
                                itemCount: this.itemsforyear?.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      ListTile(
                                        title: Row(
                                          children: [
                                            SizedBox(
                                              width:130,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.only(
                                                        left: 5.0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.center,
                                                  child: Text(
                                                    itemsforyear![index],
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Lexend-VariableFont',
                                                      color: const Color(
                                                          0xFF090950),
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width:100,
                                              child: Text(
                                                '$currencySymbol ${uniqueexpensesforyear![index]}',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight:
                                                      FontWeight.bold,
                                                  fontFamily:
                                                      'Lexend-VariableFont',
                                                  color: Color.fromARGB(
                                                      236, 97, 183, 226),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width:20),
                                            Container(
                                              height: 20,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                color: Color.fromARGB(
                                                    255, 183, 203, 250),
                                                borderRadius:
                                                    BorderRadius
                                                        .circular(10),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '${((uniqueexpensesforyear![index] / this.yearly_expense![2023 % 100 - (currentDate.year.toInt() % 100)]) * 100).toInt()}%',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    fontFamily:
                                                        'Lexend-VariableFont',
                                                    color: Color(
                                                        0xFC0095F2),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (index < itemsforyear!.length - 1)
                                        Divider(
                                          height: 0,
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
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
