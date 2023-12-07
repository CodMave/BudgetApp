import 'package:budgettrack/pages/plans.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

import '../components/tranaction.dart';
import 'Summery.dart';
import 'goals.dart';
import 'homePage.dart';


int count=0;
int newbalance=0;
class TextScanner extends StatefulWidget {

  TextScanner({super.key, required int newBalance}){
    newbalance=newBalance;

  }

  @override
  State<TextScanner> createState() => _TextScannerState(
    balance:newbalance,

  );
}

class _TextScannerState extends State<TextScanner>with WidgetsBindingObserver {
  int balance=0;
  bool ispermissiongot=false;

  late final Future <void> future;
  CameraController?cameraController;
  _TextScannerState({required this.balance});
  final textrecognise=TextRecognizer();

  void initState(){
    super.initState();
    WidgetsBinding.instance.addObserver(this);//widget binding occurs
    future=requestCameraPermission();//get the camer permission to the future
  }
  void dispose(){
    WidgetsBinding.instance.removeObserver(this);
    StopCamera();
    textrecognise.close();
    super.dispose();

  }
  Future<void>requestCameraPermission()async{//this method occurs when the user granted only to access the permission to use camera
    final status=await Permission.camera.request();
    ispermissiongot=status==PermissionStatus.granted;
  }
  void initCamera(List<CameraDescription>cameras){
    if(cameraController!=null){//check whether the camera controller is initialized or not
      return;
    }
    CameraDescription?camera;//selec the camera first
    for(var a=0;a<cameras.length;a++){
      final CameraDescription current =cameras[a];//check whether what are the available cameras
      if(current.lensDirection==CameraLensDirection.back){
        camera=current;
        break;

      }
    }
    if(camera!=null){
      cameraSelected(camera);
    }

  }
  Future<void>cameraSelected(CameraDescription camera)async{
    cameraController=CameraController(camera, ResolutionPreset.max,enableAudio: false);
    await cameraController?.initialize();
    if(!mounted){//check the avaibale quality of the camera
      return;
    }
    setState(() {

    });
  }
  void StartCamera(){//start the camera
    if(cameraController!=null){
      cameraSelected(cameraController!.description);//starts the selected camera
    }
  }
  void StopCamera(){//start the camera
    if(cameraController!=null){
      cameraController?.dispose();
    }
  }
  Future<void>scanImage()async{//In here the process of thescanning the images using the camera
    if(cameraController==null){
      return;
    }
    final navigator=Navigator.of(context);
    try{
      final pictureFile=await cameraController!.takePicture();
      final file=File(pictureFile.path);
      final inputImage=InputImage.fromFile(file);
      final recognizeText=await textrecognise.processImage(inputImage);
      await navigator.push(MaterialPageRoute(builder: (context)=>Result(balance:balance,text:recognizeText.text)));
    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error ocured when scanning the image')),
      );
    }
  }
  void checktheapp(AppLifecycleState state){//check whether the app is working on background or foreground
    if(cameraController==null||!cameraController!.value.isInitialized){
      return;
    }
    if(state== AppLifecycleState.inactive){//when app is not background then stop the camera
      StopCamera();
    }
    else if(state==AppLifecycleState.resumed&&cameraController!=null&&cameraController!.value.isInitialized){
      StartCamera();
    }
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          return Stack(
            children: [
              //Show camera content behind everything
              if (ispermissiongot)
                FutureBuilder<List<CameraDescription>>(
                    future: availableCameras(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        initCamera(snapshot.data!);
                        return Center(
                          child: CameraPreview(cameraController!),
                        );
                      } else {
                        return const LinearProgressIndicator();
                      }
                    }),
              Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.grey[100],
                  leading: Padding(
                    padding: const EdgeInsets.only(left:23),
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
                    padding: const EdgeInsets.only(left:85.0),
                    child: Row(
                      children: [

                        const Text(
                          'S C A N',
                          style: TextStyle(
                            fontFamily: 'Lexend-VariableFont',
                            color: const Color(0xFF090950),
                          ),
                        ),
                        SizedBox(width:110),
                        Icon(Icons.document_scanner_outlined, size: 30, color: const Color(0xFF090950),),
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
                          icon: Icons.assignment,
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
                backgroundColor:
                ispermissiongot ? Colors.transparent : null,
                body:ispermissiongot
                    ? Column(
                  children: [
                    Expanded(child: Container()),
                    Container(
                      padding: EdgeInsets.only(bottom: 50),
                      // child: ElevatedButton(
                      //     onPressed: (){
                      //       scanImage();
                      //     },
                      //     child: Text('Scan Now')),
                      child:ElevatedButton(
                        onPressed: () {
                          scanImage();
                             },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          onPrimary: Color(0xFF090950),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color:  Color(0xFF090950),
                              width: 2,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 12),
                          textStyle: TextStyle(
                              fontFamily:'Lexend-VariableFont',
                              fontSize: 20),
                          elevation: 2,
                        ),
                        child: Text('Scan Now'),
                      )
                    ),
                  ],
                )
                    : Center(
                  child: Container(
                    padding:
                    const EdgeInsets.only(left: 24.0, right: 24.0),
                    child: const Text(
                      'Camera Permission Denied',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }
}
int value=0;
int balance1=0;
class Result extends StatefulWidget {
  final String text;

  Result({super.key, required this.text, required int balance}){
    balance1=balance;

  }

  @override
  State<Result> createState() => _ResultState(
    newBalance:balance1,
    text:text,

  );
}

class _ResultState extends State<Result> {
  List<MyTransaction> transactions = [];
  String word='';
  int count=0;
  String text='';
  String transactiontype='';
  String extractedValue='';
  int expense=0;
  int newBalance=0;
  _ResultState({required this.text, required this. newBalance});

  void SplitingText(String text) {
    List<String> lines = text.split('\n');
    List<String> words = [];


    for (String line in lines) {
      List<String> lineWords = line.split(' ');
      words.addAll(lineWords);
    }
    for (word in words) {
      if (word == 'ROUTE:'||word == 'ROUTE'||word == 'RoUTE'||word == 'route:'||word == 'route') {
        transactiontype='Transport';
        print('Found the Word ROUTE');
      }
else if(word=='PHARMACY'||word=='Pharmacy'||word=='pHARMACY'||word=='PHARMACY:'){
        transactiontype='Health';
        print('Found the Word PHARMACY');
      }
else if(word=='Telecom'||word=='CEB'||word=='TELECOME'||word=='Water'||word=='WATER'||word=='SLT'){
  transactiontype='Bills';
      }
      else if(word=='BANK'||word=='Bank'||word=='Account'||word=='ACCOUNT'||word=='INVOICE'||word=='ID'||word=='Invoice'){
        transactiontype='Others';
      }
      else if(word=='Foods'||word=='FOODS'||word=='Bulk'||word=='kg'||word=='KEELS'||word=='SATHOSA'||word=='-Bulk-'||word=='eats'||word=='GROSS'){
        transactiontype='Foods';
      }
    }
    print(transactiontype);
    if( transactiontype=='Transport') {
      for (String word in words) {
        if (word.startsWith(
            "Rs.")) { //in here we check the word start with Rs.


          RegExp regex = RegExp(r'Rs\.(\d+\.\d+)');
           //in we check the value if it is as the order of XXX.XX then we get it as integer value
          Match? match = regex.firstMatch(
              word); //if the word is match then we get the value

          if (match != null) {
            // Extracted value is stored in match.group(1)
            extractedValue = match.group(1)!;
            print('Found Rs.$extractedValue');
          } else { //print the value when we unable to get the value
            print('Found Rs. but couldn\'t extract a valid value');
          }
        }
      }
      if(word.startsWith("Rs."))
      print( transactiontype);
      double paresdevalue=double.parse(extractedValue);
      try {

        addtransaction(transactiontype, paresdevalue.toInt());
      }
      catch(e){
        showDialog(
          context: context, // Use the current context
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xFFC2DAFF), // Set background color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0), // Add circular border
              ),
              content: Text('$e'),
              actions: [
                TextButton(

                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the alert dialog
                  },
                ),
              ],
            );
          },
        );
      }

    }
    if (transactiontype == 'Health') {
      bool foundNetTotal = false;
      String highestValue = '0';

      // Regular expression to match values in the format "X,XXX.XX"
      RegExp regex = RegExp(r'(\d{1,3},\d+\.\d+)');

      for (int i = 0; i < words.length - 1; i++) {
        String word = words[i];

        if (word.toUpperCase() == 'NET' && words[i + 1].toUpperCase() == 'TOTAL'||word.toUpperCase()=='TOTAL'||word.toUpperCase()=='Total') {
          // Check for the keyword "NET TOTAL" (case-insensitive)
          foundNetTotal = true;
        }

        if (foundNetTotal) {
          double parsedHighestValue = double.parse(highestValue.replaceAll(',', ''));
          double justLessThanHighestValue = 0;
          // Extract the value using the regular expression
          Match? match = regex.firstMatch(word);

          if (match != null) {
             extractedValue = match.group(1)!;

             extractedValue = extractedValue.replaceAll(',', '');
             double parsedValue = double.parse(extractedValue);

             if (parsedValue < parsedHighestValue && parsedValue > justLessThanHighestValue) {
               justLessThanHighestValue = parsedValue;
             }
          }
        }
      }

      if (foundNetTotal) {
        print('Highest NET TOTAL value: $highestValue');

        double parsedValue = double.parse(highestValue.replaceAll(',', ''));
        try {
          addtransaction(transactiontype, parsedValue.toInt());
        } catch (e) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Color(0xFFC2DAFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                content: Text('$e'),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      } else {
        print('NET TOTAL value not found');
      }
    }
    if (transactiontype == 'Foods') {
      bool foundNetTotal = false;
      String highestValue = '0';

      // Regular expression to match values in the format "X,XXX.XX"
      RegExp regex = RegExp(r'(\d{1,3},\d+\.\d+)');

      for (int i = 0; i < words.length - 1; i++) {
        String word = words[i];

        if (word.toUpperCase() == 'NET' && words[i + 1].toUpperCase() == 'TOTAL'||word.toUpperCase()=='TOTAL'||word.toUpperCase()=='Total') {
          // Check for the keyword "NET TOTAL" (case-insensitive)
          foundNetTotal = true;
        }

        if (foundNetTotal) {
          double parsedHighestValue = double.parse(highestValue.replaceAll(',', ''));
          double justLessThanHighestValue = 0;
          // Extract the value using the regular expression
          Match? match = regex.firstMatch(word);

          if (match != null) {
            extractedValue = match.group(1)!;

            extractedValue = extractedValue.replaceAll(',', '');
            double parsedValue = double.parse(extractedValue);

            if (parsedValue < parsedHighestValue && parsedValue > justLessThanHighestValue) {
              justLessThanHighestValue = parsedValue;
            }
          }
        }
      }

      if (foundNetTotal) {
        print('Highest NET TOTAL value: $highestValue');

        double parsedValue = double.parse(highestValue);
        print('double value is $parsedValue');
        try {
          addtransaction(transactiontype, parsedValue.toInt());
        } catch (e) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Color(0xFFC2DAFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                content: Text('$e'),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      } else {
        print('Invalid or empty value in NET TOTAL');
      }
    } else {
      print('NET TOTAL value not found');
    }

    if (transactiontype == 'Bills') {
      bool foundNetTotal = false;
      String highestValue = '0';

      // Regular expression to match values in the format "X,XXX.XX"
      RegExp regex = RegExp(r'(\d{1,3},\d+\.\d+)');

      for (int i = 0; i < words.length - 1; i++) {
        String word = words[i];

        if (word.toUpperCase() == 'NET' && words[i + 1].toUpperCase() == 'TOTAL'||word.toUpperCase()=='TOTAL'||word.toUpperCase()=='Total') {
          // Check for the keyword "NET TOTAL" (case-insensitive)
          foundNetTotal = true;
        }

        if (foundNetTotal) {
          double parsedHighestValue = double.parse(highestValue.replaceAll(',', ''));
          double justLessThanHighestValue = 0;
          // Extract the value using the regular expression
          Match? match = regex.firstMatch(word);

          if (match != null) {
            extractedValue = match.group(1)!;

            extractedValue = extractedValue.replaceAll(',', '');
            double parsedValue = double.parse(extractedValue);

            if (parsedValue < parsedHighestValue && parsedValue > justLessThanHighestValue) {
              justLessThanHighestValue = parsedValue;
            }
          }
        }
      }

      if (foundNetTotal) {
        print('Highest NET TOTAL value: $highestValue');

        double parsedValue = double.parse(highestValue);
        print('double value is $parsedValue');
        try {
          addtransaction(transactiontype, parsedValue.toInt());
        } catch (e) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Color(0xFFC2DAFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                content: Text('$e'),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      } else {
        print('Invalid or empty value in NET TOTAL');
      }
    } else {
      print('NET TOTAL value not found');
    }
    if (transactiontype == 'Others') {
      bool foundNetTotal = false;
      String highestValue = '0';

      // Regular expression to match values in the format "X,XXX.XX"
      RegExp regex = RegExp(r'(\d{3,3},\d+\.\d+)');


      for (int i = 0; i < words.length - 1; i++) {
        String word = words[i];

        if ((word.toUpperCase() == 'NET' && words[i + 1].toUpperCase() == 'TOTAL')||word.toUpperCase()=='TOTAL'||word.toUpperCase()=='Total'||word.toUpperCase()=='AMOUNT :'||word.toUpperCase()=='AMOUNT') {
          // Check for the keyword "NET TOTAL" (case-insensitive)
          foundNetTotal = true;
        }

        if (foundNetTotal) {
          // Extract the value using the regular expression
          Match? match = regex.firstMatch(word);

          if (match != null) {
         extractedValue = match.group(1)!;

            // Replace commas with an empty string before parsing
            extractedValue = extractedValue.replaceAll(',', '');

            // Replace comma with a period before parsing
            double parsedValue = double.parse(extractedValue);

            if (parsedValue > double.parse(highestValue.replaceAll(',', ''))) {
              highestValue = extractedValue;
            }
          }
        }
      }

      if (foundNetTotal) {
        print('Highest NET TOTAL value: $highestValue');

        double parsedValue = double.parse(highestValue.replaceAll(',', ''));
        try {
          addtransaction(transactiontype, parsedValue.toInt());
        } catch (e) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Color(0xFFC2DAFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                content: Text('$e'),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      } else {
        print('NET TOTAL value not found');
      }
    }
    try {
      final parsedValue = double.parse(extractedValue).toInt();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xFFC2DAFF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            title: Text('Transaction'),
            content: Text(
              'Transaction: ($transactiontype) occurred successfully\n The transaction amount is Rs.${parsedValue}',
            ),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      // Handle the parsedValue here as needed (e.g., add to transactions).
    } catch (e) {
      // Handle the parsing error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xFFC2DAFF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            content: Text('Please Scan Valid Receipt'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

  }

  Future<int> getTotalBalance(String userId) async {
    int totalIncome = await calculateTotalIncome(userId);
    int totalExpence = await getTotalExpence(userId);


    int balance = (totalIncome - totalExpence).toInt();

    setState(() {
      newBalance = balance;
    });

    return newBalance;
  }
  void addtransaction(String name,int value)async{
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    String username = user!.uid;
    // transactions
    //     .sort((a, b) => b.timestamp.compareTo(a.timestamp));
    //
    // Navigator.of(context).pop();
    setState(() {
      transactions.add(
        MyTransaction(
          transactionName:name,
          transactionAmount: value,
          transactionType: 'Expence',
          timestamp: DateTime.now(),
          currencySymbol: '\$',
        ),
      );
    });
    addExpenceToFireStore(username, transactiontype,double.parse(extractedValue).toInt());
    final balance=await getTotalBalance(username);
    final income=await calculateTotalIncome(username);
    final expense= await getTotalExpence(username);
    print(balance);
    updateBalance(username,balance,income,expense);
    print(await getBalance(username));
  }
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
          'Income':income,
          'Expences':expence,
        });

        print('Balance updated successfully!');
      } else {
        // No entry for the current month, add a new one
        addBalanceToFireStore(userId, balance,income,expence);
      }
    } catch (ex) {
      print('Error updating balance: $ex');
    }
    setState(() {});
  }
  Future<void>addBalanceToFireStore(
      String userId,
      int balance,
      int income,
      int expence,
      )async{
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      final CollectionReference expenceCollection = firestore
          .collection('userDetails')
          .doc(userId)
          .collection('Balance');

      await expenceCollection.add({
        'Balance': balance,
        'timestamp': DateTime.now(),
        'Income':income,
        'Expences':expence,
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
        'transactionName': transactionName,
        'transactionAmount': transactionAmount,
        'timestamp': DateTime.now(),
      });
    } catch (ex) {
      print('expence adding failed');
    }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Define your custom logic here for what happens when the back button is pressed.
        // You can navigate to a different screen or perform any other action.
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) =>  Controller(balance:newBalance)),
        );
        return false; // Return true if you want to allow the back button, or false to prevent it.
      },
      child: Scaffold(
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
                  'S C A N',
                  style: TextStyle(
                    fontFamily: 'Lexend-VariableFont',
                    color: const Color(0xFF090950),
                  ),
                ),

              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right:30),
              child: Icon( Icons.document_scanner_outlined, size: 30, color: const Color(0xFF090950),),
            ),
          ],
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
                        builder: (context) => HomePage()),
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
                  icon: Icons.assignment,
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
        body: Container(
          padding: EdgeInsets.all(30.0),
          child: SingleChildScrollView(
              child:Column(
                children: [
                  Text('Payment Recipt',  style: TextStyle(

                    fontFamily:'Lexend-VariableFont',
                    color:    const Color(0xFF090950),
                    fontSize:30.0,
                    //fontWeight: FontWeight.bold,
                  ),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    margin:EdgeInsets.only(top:10,left:30,right:30),
                    height:350,
                    width:300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          text==''?
                          Container(
                            child:Column(
                              children: [
                                SizedBox(height:10),
                                Text('Scan your recipt here',  style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily:'Lexend-VariableFont',
                                  color:    const Color(0xFF090950),
                                  fontSize:15.0,
                                  //fontWeight: FontWeight.bold,
                                ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            )
                          )
                              : Container(

                                child: Column(

                                  children: [
                                    SizedBox(height:10),
                                  Text(text,style: TextStyle(

                                    fontFamily:'Lexend-VariableFont',
                                    color:    const Color(0xFF090950),
                                    fontSize:15.0,
                                    //fontWeight: FontWeight.bold,
                                  ),  textAlign: TextAlign.center,),
                                    SizedBox(height:30),

                                  ],
                                )
                          ),
                         
                          
                        ],
    
                      ),
                    ),
                  ),
                  SizedBox(height:10),
                  ElevatedButton(
                    onPressed: () {
                      SplitingText(text);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Color(0xFF090950),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color:  Color(0xFF090950),
                          width: 2,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 40, vertical: 12),
                      textStyle: TextStyle(
                          fontFamily:'Lexend-VariableFont',
                          fontSize: 20),
                      elevation: 2,
                    ),
                    child: Text('Update the balance'),
                  ),
                  SizedBox(height:30),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TextScanner(newBalance:this.newBalance)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Color(0xFF090950),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color:  Color(0xFF090950),
                          width: 2,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 40, vertical: 12),
                      textStyle: TextStyle(
                          fontFamily:'Lexend-VariableFont',
                          fontSize: 20),
                      elevation: 2,
                    ),
                    child: Text('Scan now'),
                  )
                ],
              )
          ),
        ),
      ),
    );
  }
}



