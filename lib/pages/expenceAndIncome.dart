import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../components/plusButton.dart';
import '../components/tranaction.dart';
import 'Notification.dart';
import 'homePage.dart';

class Expence extends StatefulWidget {
  final List<NotificationData> notificationList;//initialize a list
  final int nume;

  final void Function(int index) onDeleteNotification;

  Expence({Key? key,required this.notificationList, required this.nume, required this.onDeleteNotification,}) : super(key: key);

  @override
  _ExpenceState createState() => _ExpenceState(
    notificationList: notificationList,
    nume: nume,
    onDeleteNotification: onDeleteNotification,
  );
// You need to replace this with the correct way to get the instance of the _ExpenceState class

}

class _ExpenceState extends State<Expence> {
  final List<NotificationData> notificationList;
  final int nume;
  final void Function(int index) onDeleteNotification;
  _ExpenceState({
    required this.notificationList,
    required this.nume,
    required this.onDeleteNotification,
  });
  double totalex=0.0;
  double totalin=0.0;

  List<MyTransaction> transactions = [];



  final TextEditingController transactionNameController =
  TextEditingController();
  final TextEditingController amountController = TextEditingController();
  bool is_income = false;
  final formKey = GlobalKey<FormState>();

  //Fetching user selected currency from firebase

  //variable to store user selected currency
  late String userSelecterCurrency = 'USD';

  //symbol user selected currency
  late String currencySymbol = '\$';

  //two variables to fetch the latest expence and income
  MyTransaction? lastIncomeTransaction;
  MyTransaction? lastExpenseTransaction;

  //total balance variable
  int totalBalance = 0;

  //variable to store the stream
  late Stream<DocumentSnapshot<Map<String, dynamic>>> balanceStream;
  bool isBalanceStreamInitialized = false;

  //get document Ids

  Future getDocIds() async {
    await FirebaseFirestore.instance
        .collection('userDatails')
        .get()
        .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          userSelecterCurrency = snapshot.docs[0].get('currency');
        });
        currencySymbolAssign();
      }
    });
  }

  void currencySymbolAssign() {
    if (userSelecterCurrency == 'USD') {
      currencySymbol = '\$';
    } else if (userSelecterCurrency == 'EUR') {
      currencySymbol = '€';
    } else if (userSelecterCurrency == 'INR') {
      currencySymbol = '₹';
    } else if (userSelecterCurrency == 'SLR') {
      currencySymbol = 'Rs';
    } else if (userSelecterCurrency == 'GBP') {
      currencySymbol = '£';
    } else if (userSelecterCurrency == 'AUD') {
      currencySymbol = 'A\$';
    } else if (userSelecterCurrency == 'CAD') {
      currencySymbol = 'C\$';
    }
  }

  //method to get currently signed in user's uid

  Future<String> getCurrentUserId() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;

      return user!.uid;
    } catch (ex) {
      print('current user fetchimg failed');
      return '';
    }
  }

  //method to add new expence to the expenceID collection

  Future<void> addExpenceToFireStore(
      String userId,
      String transactionName,
      int transactionAmount,
      ) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      final CollectionReference expenceCollection = firestore
          .collection('userDetails')
          .doc(userId)
          .collection('expenceID');

      await expenceCollection.add({
        'transactionName': transactionName,
        'transactionAmount': transactionAmount,
        'timestamp': DateTime.now(),
      });

      fetchLatestTransactions(userId);
    } catch (ex) {
      print('expence adding failed');
    }
  }

  //method to add new income to the incomeID collection

  Future<void> addIncomeToFireStore(
      String userId,
      String transactionName,
      int transactionAmount,
      ) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      final CollectionReference incomeCollection = firestore
          .collection('userDetails')
          .doc(userId)
          .collection('incomeID');
      ;

      await incomeCollection.add({
        'transactionName': transactionName,
        'transactionAmount': transactionAmount,
        'timestamp': DateTime.now(),
      });

      fetchLatestTransactions(userId);
    } catch (ex) {
      print('income adding failed');
    }
  }

  //fettching latest exoence and income from firestore

  Future<void> fetchLatestTransactions(String userId) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      //fetch the latest income
      final incomeSnapshot = await firestore
          .collection('userDetails')
          .doc(userId)
          .collection('incomeID')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (incomeSnapshot.docs.isNotEmpty) {
        final income = incomeSnapshot.docs[0];
        setState(() {
          lastIncomeTransaction = MyTransaction(
            transactionName: income.get('transactionName'),
            transactionAmount: income.get('transactionAmount'),
            transactionType: 'Income',
            timestamp: income.get('timestamp').toDate(),
          );
        });
      }

      //fetch the latest expence
      final expenceSnapshot = await firestore
          .collection('userDetails')
          .doc(userId)
          .collection('expenceID')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (expenceSnapshot.docs.isNotEmpty) {
        final expence = expenceSnapshot.docs[0];
        setState(() {
          lastExpenseTransaction = MyTransaction(
            transactionName: expence.get('transactionName'),
            transactionAmount: expence.get('transactionAmount'),
            transactionType: 'Expence',
            timestamp: expence.get('timestamp').toDate(),
          );
        });
      }

      //update the total balance
      getTotalBalance(userId).then((balance) {
        setState(() {
          totalBalance = balance;
        });
      });
    } catch (ex) {
      print('fetching latest transactions failed');
    }
  }

  //method to calculate total income from firestore

  Future<int> calculateTotalIncome(String userId) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final incomeSnapshot = await firestore
          .collection('userDetails')
          .doc(userId)
          .collection('incomeID')
          .get();

      int totalIncome = 0;
      incomeSnapshot.docs.forEach((incomeDoc) {
        totalIncome += (incomeDoc.get('transactionAmount') as num).toInt();
      });

      return totalIncome;
    } catch (ex) {
      print('calculating total income failed');
      return 0;
    }
  }

  //method to calculate total expence from firestore

  Future<int> getTotalExpence(String userId) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final expenceSnapshot = await firestore
          .collection('userDetails')
          .doc(userId)
          .collection('expenceID')
          .get();

      int totalExpence = 0;
      expenceSnapshot.docs.forEach((expenceDoc) {
        totalExpence += (expenceDoc.get('transactionAmount') as num).toInt();
      });

      return totalExpence;
    } catch (ex) {
      print('calculating total expence failed');
      return 0;
    }
  }

  //method to calculate the total balance

  Future<int> getTotalBalance(String userId) async {
    double totalIncome = (await calculateTotalIncome(userId)).toDouble();
    double totalExpence = (await getTotalExpence(userId)).toDouble();
    totalex=totalExpence;
    totalin=totalIncome;

    int balance = (totalIncome - totalExpence).toInt();

    setState(() {
      totalBalance = balance;
    });

    return totalBalance;
  }

  //method to get the updates in realtime

  Stream<DocumentSnapshot<Map<String, dynamic>>> getBalanceStream(
      String userID) {
    return FirebaseFirestore.instance
        .collection('userDetails')
        .doc(userID)
        .snapshots();
  }

  // fetch expence in real time

  Stream<QuerySnapshot<Map<String, dynamic>>> getExpenceStream(String userID) {
    return FirebaseFirestore.instance
        .collection('userDetails')
        .doc(userID)
        .collection('expenceID')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // fetch income in real time

  Stream<QuerySnapshot<Map<String, dynamic>>> getIncomeStream(String userID) {
    return FirebaseFirestore.instance
        .collection('userDetails')
        .doc(userID)
        .collection('incomeID')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  //Feth transactions for the current day
  Future<List<MyTransaction>> fetchTransactionsForCurrentDay(
      String userId) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      DateTime now = DateTime.now();
      DateTime startOfDay = DateTime(now.year, now.month, now.day);
      DateTime endOfDay = startOfDay.add(const Duration(days: 1));

      final QuerySnapshot expenceSnapshot = await firestore
          .collection('userDetails')
          .doc(userId)
          .collection('expenceID')
          .where('timestamp',
          isGreaterThanOrEqualTo: startOfDay, isLessThan: endOfDay)
          .orderBy('timestamp', descending: true)
          .get();

      final QuerySnapshot incomeSnapshot = await firestore
          .collection('userDetails')
          .doc(userId)
          .collection('incomeID')
          .where('timestamp',
          isGreaterThanOrEqualTo: startOfDay, isLessThan: endOfDay)
          .orderBy('timestamp', descending: true)
          .get();

      List<MyTransaction> transactions = [];

      //Add expence transactions
      expenceSnapshot.docs.forEach((expenceDoc) {
        transactions.add(
          MyTransaction(
            transactionName: expenceDoc.get('transactionName'),
            transactionAmount: expenceDoc.get('transactionAmount'),
            transactionType: 'Expence',
            timestamp: expenceDoc.get('timestamp').toDate(),
          ),
        );
      });

      //Add income transactions
      incomeSnapshot.docs.forEach((incomeDoc) {
        transactions.add(
          MyTransaction(
            transactionName: incomeDoc.get('transactionName'),
            transactionAmount: incomeDoc.get('transactionAmount'),
            transactionType: 'Income',
            timestamp: incomeDoc.get('timestamp').toDate(),
          ),
        );
      });

      //Sort the transactions
      transactions.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      return transactions;
    } catch (ex) {
      print('fetching transactions for current day failed');
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    getDocIds();

    //fetch and set the total balance
    getCurrentUserId().then((userId) {
      getTotalBalance(userId).then((Balance) {
        setState(() {
          totalBalance = Balance;
        });
      });

      // Fetch and set the latest transactions
      fetchLatestTransactions(userId);

      //Fetch and set the transactions for the current day
      fetchTransactionsForCurrentDay(userId).then((currentDayTransactions) {
        setState(() {
          transactions = currentDayTransactions;
        });
      });

      // Listen for real-time changes to balance, income, and expense
      balanceStream = getBalanceStream(userId);
      balanceStream?.listen((sanpshot) {
        if (isBalanceStreamInitialized) {
          getTotalBalance(userId).then((balance) {
            setState(() {
              totalBalance = balance;
            });
          });
        } else {
          setState(() {
            isBalanceStreamInitialized = true;
          });
        }
      });

      getExpenceStream(userId).listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          final expence = snapshot.docs[0];
          setState(() {
            lastExpenseTransaction = MyTransaction(
              transactionName: expence.get('transactionName'),
              transactionAmount: expence.get('transactionAmount'),
              transactionType: 'Expence',
              timestamp: expence.get('timestamp').toDate(),
            );
          });
        } else {
          setState(() {
            lastExpenseTransaction = null;
          });
        }
      });
    });
  }

  //new transaction dialog box

  void newTransaction() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return AlertDialog(
                title: const Text("N E W   T R A N S A C T I O N"),
                content: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(
                              "Expence",
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 18,
                              ),
                            ),

                            //toggle button

                            Switch(
                              value: is_income,
                              onChanged: (newValue) {
                                setState(() {
                                  is_income = newValue;
                                });
                              },
                            ),

                            const Text(
                              "Income",
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Enter the Amount",
                                ),
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return "Please enter the amount";
                                  }
                                  return null;
                                },
                                controller: amountController,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Enter the Transaction Name",
                                ),
                                controller: transactionNameController,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                actions: <Widget>[
                  MaterialButton(
                    color: Colors.grey[600],
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  MaterialButton(
                    color: Colors.grey[600],
                    child: const Text(
                      'Enter',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        String transactionType =
                        is_income ? "Income" : "Expence";
                        int transactionAmount =
                            int.parse(amountController.text) ?? 0;

                        String transactionName = transactionNameController.text;
                        print(transactionName);

                        //get the user id
                        String? userId = await getCurrentUserId();

                        //add transaction to the list
                        setState(() {
                          transactions.add(
                            MyTransaction(
                              transactionName: transactionName,
                              transactionAmount: transactionAmount,
                              transactionType: transactionType,
                              timestamp: DateTime.now(),
                            ),
                          );
                        });

                        transactionNameController.clear();
                        amountController.clear();
                        Navigator.of(context).pop();

                        if (is_income) {
                          addIncomeToFireStore(
                            userId,
                            transactionName,
                            transactionAmount,
                          );
                        } else {
                          addExpenceToFireStore(
                            userId,
                            transactionName,
                            transactionAmount,
                          );
                        }
                      }
                    },
                  ),
                ],
              );
            },
          );
        });
  }
  void updateTotalBalance(int newBalance) {
    setState(() {
      totalBalance = newBalance;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor:
        Colors.grey[100], // Set the background color of the App Bar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black, // Set the color of the back arrow
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>Controller(balance:totalBalance,expense:totalex,income:totalin,notificationList:notificationList,num:nume,onDeleteNotification:onDeleteNotification,),
              ),
            );
          },
        ),
        title: const Text(
          'T R A N S A C T I O N S',
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
        centerTitle: true, // Center the title
        elevation: 0.0, // Removes the shadow
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          // Show balance

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              //color: Colors.grey[100],
              height: 190,
              // ignore: sort_child_properties_last
              child: Column(
                children: [
                  // Balance text

                  const SizedBox(height: 20),

                  Text(
                    "B A L A N C E",
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Balance amount

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // currency symbol
                      Text(
                        currencySymbol,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 34,
                        ),
                      ),

                      const SizedBox(width: 3),

                      // amount

                      Text(
                        totalBalance.toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 34,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Show expence and income

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 70),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //income

                        Row(
                          children: [
                            // up icon
                            const Icon(
                              Icons.arrow_upward,
                              color: Colors.green,
                              size: 28,
                            ),

                            const SizedBox(width: 5),

                            // income
                            Column(
                              children: [
                                //income text
                                Text(
                                  "Income",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 18,
                                  ),
                                ),

                                //income amount
                                Row(
                                  children: [
                                    //currency symbol
                                    Text(
                                      currencySymbol,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                    ),

                                    // amount
                                    Text(
                                      "${lastIncomeTransaction?.transactionAmount ?? '0'}",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),

                        //expence

                        Row(
                          children: [
                            // down icon
                            const Icon(
                              Icons.arrow_downward,
                              color: Colors.red,
                              size: 28,
                            ),

                            // expence
                            Column(
                              children: [
                                //expence text
                                Text(
                                  "Expence",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 18,
                                  ),
                                ),

                                //expence amount
                                Row(
                                  children: [
                                    //currency symbol
                                    Text(
                                      currencySymbol,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                    ),

                                    // amount
                                    Text(
                                      "${lastExpenseTransaction?.transactionAmount ?? '0'}",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xff90E0EF),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    offset: const Offset(4.0, 4.0),
                    blurRadius: 10.0,
                    spreadRadius: 1,
                  ),
                  const BoxShadow(
                    color: Colors.white,
                    offset: Offset(-4.0, -4.0),
                    blurRadius: 10.0,
                    spreadRadius: 0.25,
                  ),
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.7),
                    offset: const Offset(4.0, -4.0),
                    blurRadius: 10.0,
                    spreadRadius: 0.25,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 5),

          // Show recent transactions

          Expanded(
            // to show the list and button to overlay the list
            child: Stack(
              children: [
                ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    //int reverseIndex = transactions.length - 1 - index;
                    return MyTransaction(
                      transactionName: transactions[index].transactionName,
                      transactionAmount: transactions[index].transactionAmount,
                      transactionType: transactions[index].transactionType,
                      timestamp: transactions[index].timestamp,
                    );
                  },
                  //reverse: true,
                ),
                // Positioned widget for the button
                Positioned(
                  bottom: 20.0,
                  right: 20.0,
                  child: PlusButton(
                    function: newTransaction,
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }

}

