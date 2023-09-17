import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

import '../components/tranaction.dart';
import 'homePage.dart';


 int count=0;
 int newbalance=0;
class TextScanner extends StatefulWidget {

 TextScanner({super.key, required int num, required int newBalance}){
   newbalance=newBalance;
    count=num;
  }

  @override
  State<TextScanner> createState() => _TextScannerState(
    balance:newbalance,
    newcount:count,
  );
}

class _TextScannerState extends State<TextScanner>with WidgetsBindingObserver {
  int balance=0;
  bool ispermissiongot=false;
  int newcount=0;
  late final Future <void> future;
  CameraController?cameraController;
  _TextScannerState({required this.balance,required this.newcount});
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
      final CameraDescription current =cameras[a];//heck whether what are the available cameras
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
      await navigator.push(MaterialPageRoute(builder: (context)=>Result(balance:balance,newcount:newcount,text:recognizeText.text)));
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
                  title: const Text('Text Recognition Sample'),
                ),
                backgroundColor:
                ispermissiongot ? Colors.transparent : null,
                body:ispermissiongot
                    ? Column(
                  children: [
                    Expanded(child: Container()),
                    Container(
                      padding: EdgeInsets.only(bottom: 30),
                      child: ElevatedButton(
                          onPressed: (){
                            scanImage();
                          },
                          child: Text('Scan Text')),
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

  Result({super.key, required this.text, required int newcount, required int balance}){
    balance1=balance;
    value=newcount;
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
      if (word == 'ROUTE:'||word == 'ROUTE'||word == 'RoUTE') {
        transactiontype='Transport';
        print('Found the Word ROUTE');
      }
    }
    print(transactiontype);
        if( transactiontype=='Transport') {
          for (String word in words) {
            // if (word == 'ROUTE') {
            //   print('Found the Word ROUTE');
            // } else
            if (word.startsWith(
                "Rs.")) { //in here we check the word start with Rs.


              RegExp regex = RegExp(
                  r'Rs\.(\d+\.\d+)'); //in we check the value if it is as the order of XXX.XX then we get it as integer value
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
          print( transactiontype);
          addtransaction( transactiontype,double.parse(extractedValue).toInt());

        }
    showDialog(
      context: context, // Use the current context
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFFC2DAFF), // Set background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0), // Add circular border
          ),
          title: Text('Transaction'),
          content: Text('Transaction:($transactiontype) occured successfully\n The transaction amount is Rs.${double.parse(extractedValue).toInt()}'),
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
          MaterialPageRoute(builder: (context) =>  Controller(balance:newBalance,num:count)),
        );
        return false; // Return true if you want to allow the back button, or false to prevent it.
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Text Recognition'),
        ),
        body: Container(
          padding: EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child:Column(
              children: [
                Text(text),
              SizedBox(height:10),
                ElevatedButton(
                    onPressed: ()=> SplitingText(text) , child: Text('Update the balance')),
              ],
            )
          ),
        ),
      ),
    );
  }
}



