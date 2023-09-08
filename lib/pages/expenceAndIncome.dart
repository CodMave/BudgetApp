import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../components/plusButton.dart';
import '../components/tranaction.dart';
import 'Notification.dart';

class Expence extends StatefulWidget {
  final List<NotificationData> notificationList; //initialize a list
  final int nume;
  //final void Function(int index) onDeleteNotification;

  Expence({
    Key? key,
    required this.notificationList,
    required this.nume,
    //required this.onDeleteNotification,
  }) : super(key: key);

  @override
  _ExpenceState createState() => _ExpenceState(
        notificationList: notificationList,
        nume: nume,
        //onDeleteNotification: onDeleteNotification,
      );
// You need to replace this with the correct way to get the instance of the _ExpenceState class
}

class _ExpenceState extends State<Expence> {
  final List<NotificationData> notificationList;
  final int nume;
  //final void Function(int index) onDeleteNotification;
  _ExpenceState({
    required this.notificationList,
    required this.nume,
    //required this.onDeleteNotification,
  });
  double totalex = 0.0;
  double totalin = 0.0;

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

  //variables to store the selected category
  String selectedCategory = 'Others';

  String? userSelectedCurrency;

  //list for toggle bar
  List<bool> _selections = [true, false, false];
  int selectedFilterIndex = 0;

  //list Expence categories
  List<String> expenceCategories = [
    'Food',
    'Shopping',
    'Bills',
    'Entertainment',
    'Health',
    'Education',
    'Donations',
    'Rental',
    'Fuel',
    'Transport',
    'Others',
  ];

  //list income categories
  List<String> incomeCategories = [
    'Salary',
    'Bonus',
    'Gifts',
    'Rental',
    'Others',
  ];

  void currencySymbolAssign(String userSelecterCurrency) {
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

  //get the user selected currency from firestore
  Future<String> getUserSelectedCurrency() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      var email = user.email!;

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('userDetails')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        userSelectedCurrency = doc.get('currency');
        currencySymbolAssign(userSelectedCurrency!);
        print('user selected currency is $userSelectedCurrency');
      }
    }

    print('user selected currency is $userSelectedCurrency');
    return userSelectedCurrency!;
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
  Future<void> addBalanceToFireStore(
    String userId,
    int balance,
    int income,
    int expence,
  ) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      final CollectionReference expenceCollection =
          firestore.collection('userDetails').doc(userId).collection('Balance');

      await expenceCollection.add({
        'Balance': balance,
        'timestamp': DateTime.now(),
        'Income': income,
        'Expences': expence,
      });
    } catch (ex) {
      print('Balance adding failed');
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
        'transactionName': selectedCategory,
        'transactionAmount': transactionAmount,
        'timestamp': DateTime.now(),
      });

      fetchLatestTransactions(userId);
    } catch (ex) {
      print('expence adding failed');
    }
  }

  Future<String?> getBalance(String userId) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      final QuerySnapshot querySnapshot = await firestore
          .collection('userDetails')
          .doc(userId)
          .collection('Balance')
          .where('Balance')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
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

  Future<void> updateBalance(
    String userId,
    int balance,
    int income,
    int expence,
  ) async {
    // Define the 'username' variable

    // Update the balance for the current month
    try {
      final existingEntry = await getBalance(userId);

      if (existingEntry != null) {
        final FirebaseFirestore firestore = FirebaseFirestore.instance;

        final DocumentReference documentReference = firestore
            .collection('userDetails')
            .doc(userId) // Use the 'username' variable
            .collection('Balance')
            .doc(existingEntry);

        // Use the update method to update the "Balance" field
        await documentReference.update({
          'Balance': balance,
          'Income': income,
          'Expences': expence,
        });

        print('Balance updated successfully!');
      } else {
        // No entry for the current month, add a new one
        addBalanceToFireStore(userId, balance, income, expence);
      }
    } catch (ex) {
      print('Error updating balance: $ex');
    }
    setState(() {});
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
        'transactionName': selectedCategory,
        'transactionAmount': transactionAmount,
        'timestamp': DateTime.now(),
      });

      fetchLatestTransactions(userId);
    } catch (ex) {
      print('income adding failed');
    }
  }

  //fettching latest expence and income from firestore

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
            currencySymbol: currencySymbol,
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
            currencySymbol: currencySymbol,
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
    totalex = totalExpence;
    totalin = totalIncome;

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
            currencySymbol: currencySymbol,
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
            currencySymbol: currencySymbol,
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
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    String username = user!.uid;
    print(username);
    super.initState();

    //fetch and set the total balance
    getCurrentUserId().then((userId) {
      getTotalBalance(userId).then((Balance) async {
        setState(() {
          totalBalance = Balance;
        });

        // Fetch and set the latest transactions
        fetchLatestTransactions(userId);

        // Fetch and set the transactions for the current day
        fetchTransactionsForCurrentDay(userId).then((currentDayTransactions) {
          setState(() {
            transactions = currentDayTransactions;
          });
        });

        // Listen for real-time changes to balance, income, and expense
        balanceStream = getBalanceStream(userId);
        balanceStream.listen((sanpshot) {
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
                transactionType: 'Expense',
                timestamp: expence.get('timestamp').toDate(),
                currencySymbol: currencySymbol,
              );
            });
          } else {
            setState(() {
              lastExpenseTransaction = null;
            });
          }
          // Print totalBalance here after all asynchronous operations are done.
          print(totalBalance);
        });

        // Move the updateBalance call inside this callback if it depends on the updated totalBalance.
        updateBalance(
          username,
          totalBalance,
          await calculateTotalIncome(userId),
          await getTotalExpence(userId),
        );
      });
    });

    //assign user selected currency
    getUserSelectedCurrency();
  }

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
                              child: DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Select the Category",
                                ),
                                value: selectedCategory,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedCategory = newValue!;
                                    transactionNameController.text = newValue;
                                  });
                                },
                                items: is_income
                                    ? incomeCategories
                                        .map<DropdownMenuItem<String>>(
                                          (String category) =>
                                              DropdownMenuItem<String>(
                                            value: category,
                                            child: Text(category),
                                          ),
                                        )
                                        .toList()
                                    : expenceCategories
                                        .map<DropdownMenuItem<String>>(
                                          (String category) =>
                                              DropdownMenuItem<String>(
                                            value: category,
                                            child: Text(category),
                                          ),
                                        )
                                        .toList(),
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
                            int.parse(amountController.text);

                        String transactionName = transactionNameController.text;
                        print(transactionName);

                        //get the user id
                        String? userId = await getCurrentUserId();

                        transactions
                            .sort((a, b) => b.timestamp.compareTo(a.timestamp));

                        //Navigator.of(context).pop();

                        //add transaction to the list
                        setState(() {
                          transactions.add(
                            MyTransaction(
                              transactionName: transactionName,
                              transactionAmount: transactionAmount,
                              transactionType: transactionType,
                              timestamp: DateTime.now(),
                              currencySymbol: currencySymbol,
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
                        updateBalance(
                          userId,
                          await getTotalBalance(userId),
                          await calculateTotalIncome(userId),
                          await getTotalExpence(userId),
                        );
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
        title: const Text(
          'T R A N S A C T I O N S',
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
        centerTitle: true, // Center the title
        elevation: 0.0, // Removes the shadow
      ),
      //bottomNavigationBar: BottomNavigation(),
      body: Column(
        children: [
          const SizedBox(height: 10),

          // Show balance

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 222,
              width: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xff90E0EF),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(1),
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
                ],
              ),
              // ignore: sort_child_properties_last
              child: Column(
                children: [
                  // Balance text
                  Container(
                    height: 70,
                    width: 400,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 25, 86, 143),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 75),
                      child: Row(
                        children: [
                          Text(
                            "B A L A N C E",
                            style: TextStyle(
                              color: Colors.grey[100],
                              fontSize: 30,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Icon(
                            Icons.account_balance_wallet_outlined,
                            size: 35,
                            color: Colors.grey[100],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 1,
                    width: 400,
                    color: Colors.grey[500],
                  ),

                  // Balance amount
                  Container(
                    height: 70,
                    width: 400,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 71, 148, 221),
                    ),
                    child: Center(
                      child: Text(
                        "$currencySymbol$totalBalance",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 50,
                        ),
                      ),
                    ),
                  ),

                  Container(
                    height: 1,
                    width: 400,
                    color: Colors.grey[500],
                  ),

                  // Show expence and income
                  Container(
                    height: 80,
                    width: 400,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[100],
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //Income
                          Column(
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Icons.add_card_rounded,
                                    size: 22,
                                    color: Colors.green,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Income',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 22,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 7),
                              Row(
                                children: [
                                  Text(
                                    currencySymbol,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 25,
                                    ),
                                  ),
                                  Text(
                                    "${lastIncomeTransaction?.transactionAmount ?? '0'}",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 25,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2, bottom: 8),
                            child: Container(
                              height: 70,
                              width: 1,
                              color: Colors.grey[800],
                            ),
                          ),
                          //expence
                          Column(
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Icons.add_card_rounded,
                                    size: 22,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Expence',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 22,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 7),
                              Row(
                                children: [
                                  Text(
                                    currencySymbol,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 25,
                                    ),
                                  ),
                                  Text(
                                    "${lastExpenseTransaction?.transactionAmount ?? '0'}",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 25,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          Container(
            height: 1,
            width: double.infinity,
            color: Colors.grey[300],
          ),

          const SizedBox(height: 10),

          //Toggle bar
          ToggleButtons(
            isSelected: _selections,
            onPressed: (int newIndex) {
              setState(() {
                for (int index = 0; index < _selections.length; index++) {
                  if (index == newIndex) {
                    _selections[index] = true;
                  } else {
                    _selections[index] = false;
                  }
                }
                selectedFilterIndex = newIndex;
              });
            },
            borderRadius: BorderRadius.circular(20),
            selectedColor: const Color.fromARGB(255, 25, 86, 143),
            color: Colors.grey.shade600,
            fillColor: Colors.grey[100],
            selectedBorderColor: const Color.fromARGB(255, 25, 86, 143),
            children: const [
              Padding(
                padding: EdgeInsets.only(left: 50, right: 50),
                child: Text(
                  'All',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 25, right: 25),
                child: Text(
                  'Income',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  'Expence',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Show recent transactions
          Expanded(
            // to show the list and button to overlay the list
            child: Stack(
              children: [
                ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    if (selectedFilterIndex ==
                            0 || // Show all when 'All' is selected
                        (selectedFilterIndex == 1 &&
                            transactions[index].transactionType ==
                                'Income') || // Show income when 'Income' is selected
                        (selectedFilterIndex == 2 &&
                            transactions[index].transactionType == 'Expence')) {
                      // Show expense when 'Expence' is selected
                      return MyTransaction(
                        transactionName: transactions[index].transactionName,
                        transactionAmount:
                            transactions[index].transactionAmount,
                        transactionType: transactions[index].transactionType,
                        timestamp: transactions[index].timestamp,
                        currencySymbol: currencySymbol,
                      );
                    } else {
                      return Container(); // Return an empty container for other cases
                    }
                  },
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
