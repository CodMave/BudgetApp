import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import '../firebase_options.dart';
import 'homePage.dart';


Future<void> _FirebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling background message:${message.messageId}');
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_FirebaseMessagingBackgroundHandler);
  var initializationsettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationsettings =
      InitializationSettings(android: initializationsettingsAndroid);
  flutterLocalNotificationsPlugin.initialize(initializationsettings);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  runApp(MyWork());
}

class NotificationData {
  final String message;
  final DateTime receivedDateTime;

  NotificationData({
    required this.message,
    required this.receivedDateTime,
  });
}


class MyWork extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}
class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int flag = 0;
  String name='';
  FirebaseMessaging msg = FirebaseMessaging.instance;
 SharedPreferences? _prefs;
  int totalBalance = 0;
  String? mtoken = " ";

  String titleText = '';
  String bodyText = ' ';
  String sts = ' ';


  String titleText='';
  String bodyText=' ';
  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveToken(String token) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    String username = user!.uid;
    final CollectionReference incomeCollection =
        firestore.collection('userDetails').doc(username).collection('Tokens');

    // Check if the token already exists in the database
    final existingToken =
        await incomeCollection.where('token', isEqualTo: token).get();

    if (existingToken.docs.isEmpty) {
      // Token does not exist, so save it
      final DocumentReference newDocument =
          await incomeCollection.add({'token': token, 'State': 'invalid'});

      // Perform any additional actions you need
    } else {
      // Token already exists, no need to save it again
      print("Token already exists in the database");
    }
    firstprocess(token);
  }

  Future<void> getToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      setState(() {
        mtoken = token;
      });
      if (mtoken != null) {
        print("FCM Token: $mtoken");
        saveToken(mtoken!);
      } else {
        print("FCM Token is null");
      }
    } catch (e) {
      print("Error getting FCM token: $e");
    }
  }
  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }


  void sendPushMessage(String token, String body, String title) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAALO2Ssv8:APA91bFhhtJX7mwqMVxY4A4FYnDIrXNARvnH_ZmkasaXMwGuUkNBqiqphhLbHbnoB1OlmJnV3yQ1wX08FIT_X4RxCxBRdsvQLT_dVk1BONVlzg1IeJZnJboH3qgssZVMoMJlVEQoqVHb',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{'body': body, 'title': title},
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
    } catch (e) {
      print("error push notification");
    }
  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.show(
        id, title, body, await notificationDetails());
  }


  Future<void>firstprocess(String token)async {

  void firstprocess(String token) async {
    User? user = _auth.currentUser;
    String username = user!.uid;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    final incomeSnapshot = await firestore
        .collection('userDetails')
        .doc(username)
        .collection('Tokens')
        .where('State', isEqualTo: 'invalid')
        .get();
    print(token);
    if (incomeSnapshot.docs.isNotEmpty) {
      bodyText =
          'Hello! Welcome back to have an great experiance on budget Managing';
      titleText = 'Welcome!';

      final existingEntry = await getExistingEntry('invalid');

      if (existingEntry != null) {
        final FirebaseFirestore firestore = FirebaseFirestore.instance;

        final DocumentReference documentReference = firestore
            .collection('userDetails')
            .doc(username)
            .collection('Tokens')
            .doc(existingEntry);

        // Use the update method to update the "Balance" field
        await documentReference.update({
          'State': 'valid',
        });

        sendPushMessage(token, bodyText, titleText);

        String message='Hello! Welcome back to have an great experiance on budget Managing';
        DateTime time=DateTime.now();
       showNotification(
          id:1,
          title: 'Hello!!',
          body: message,
        );
          addNotificationToFirestore(message,time);

      }

    }
  }

  Future<String?> getExistingEntry(String state) async {
    User? user = _auth.currentUser;
    String username = user!.uid;
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      final QuerySnapshot querySnapshot = await firestore
          .collection('userDetails')
          .doc(username)
          .collection('Tokens')
          .where('State', isEqualTo: state)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Return the document ID of the existing entry
        return querySnapshot.docs.first.id;
      } else {
        return null;
      }
    } catch (ex) {
      print('Error getting existing entry: $ex');
      return null;
    }
  }


  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }


  void initState() {

    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    initNotification();
    getToken();


    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        // Show in-app notification banner
        Fluttertoast.showToast(
          msg: notification.body!,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
        );

        // Show local notification

        // Now you can use the token as needed
        // ...

        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              color: Colors.blue,
              playSound: true,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );

        counter();

        addNotificationToList(notification.body ?? '');
        print(notificationList.length);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text(notification.title!),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(notification.body!),
                    SizedBox(height: 8),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        'Received on: ${DateTime.now()}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    });

    loadSavedMessages();
    getNewMessagesCount().then((value) {

getNewMessagesCount().then((value) {

      setState(() {
        flag = value;
      });
    });

  }


 }

  Future<int> getNewMessagesCount() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs?.getInt('newMessagesCount') ?? 0;
  }


  void addNotificationToFirestore(String message,DateTime time) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    String username = user!.uid;

    try {

        try {
          final FirebaseFirestore firestore = FirebaseFirestore.instance;

          final CollectionReference incomeCollection = firestore
              .collection('userDetails')
              .doc(username)
              .collection('ReceivedNotifications');

          final DocumentReference newDocument = await incomeCollection.add({
            'message': message,
            'Time':time, // Use the formatted time as a DateTime
          });

          final String newDocumentId = newDocument.id;
          print('New document created with ID: $newDocumentId');
        } catch (ex) {
          print('Notification adding failed: $ex');
          // Handle the error appropriately, e.g., show a message to the user
        }
      // }
    }

    if (notificationList.isEmpty) {
      // If the notificationList is empty, clear the stored messages from SharedPreferences
      _prefs!.remove('messages');
      _prefs!.remove('times');
    } else {
      final messages =
          notificationList.map((notification) => notification.message).toList();
      final times = notificationList
          .map((notification) => notification.receivedDateTime.toString())
          .toList();
      _prefs!.setStringList('messages', messages);
      _prefs!.setStringList('times', times);

        catch (ex) {
      print('Error occurs: $ex');
      // Handle any unexpected errors here

    }
  }





  Future<void> counter() async {
    final newCount = flag + 1;
    _prefs = await SharedPreferences.getInstance();
    _prefs?.setInt('newMessagesCount', newCount);
    setState(() {
      flag = newCount;
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Controller(
          balance: totalBalance,
        num: flag,
      ),


    );
  }
}

class Holder extends StatefulWidget {
 final int totalBalance;

  Holder({
    required this.totalBalance,
 });


  @override
  State<Holder> createState() => _HolderState(


  );
}

class _HolderState extends State<Holder> {
//   List<String> messages = [];
//   int count=0;
// void initState(){
//   super.initState();
//   getDocCount();
// }
//
//
//  Future<List> gettheMessagefromDB() async {
//    final FirebaseAuth _auth = FirebaseAuth.instance;
//    List<String> Message = [];
//    User? user = _auth.currentUser; //created an instance to the User of Firebase authorized
//    username = user!.uid;
//
//    try {
//      final FirebaseFirestore firestore = FirebaseFirestore.instance;
//      final incomeSnapshot = await firestore
//          .collection('userDetails')
//          .doc(username)
//          .collection('ReceivedNotifications')
//          .get();
//
//      incomeSnapshot.docs.forEach((dDoc) {
//       Message.insert(0,dDoc.get('message'));
//      });
//
//      return  Message;
//    } catch (ex) {
//      print('Getting the message failed');
//      return [];
//    }
//  }
//  Future<List> gettheReceivedTimefromDB() async {
//    List<DateTime> time = [];
//    final FirebaseAuth _auth = FirebaseAuth.instance;
//
//    User? user = _auth.currentUser; //created an instance to the User of Firebase authorized
//    username = user!.uid;
//
//    try {
//      final FirebaseFirestore firestore = FirebaseFirestore.instance;
//      final incomeSnapshot = await firestore
//          .collection('userDetails')
//          .doc(username)
//          .collection('ReceivedNotifications')
//          .get();
//
//      incomeSnapshot.docs.forEach((dDoc) {
//        time.insert(0,dDoc.get('Time'));
//      });
//
//      return  time;
//    } catch (ex) {
//      print('Getting the time failed');
//      return [];
//    }
//  }
//
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
  fetchMessages(); // Fetch messages when the widget is initialized
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
                builder: (context) => const HomePage(),
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

                      children: List.generate(widget.notificationList.length,
                          (index) {
                        final notificationData = widget.notificationList[index];


                      itemCount: messages.length, // Use the length of messages
                      itemBuilder: (context, index) {

                        return Dismissible(
                          key: UniqueKey(),
                          background: Container(
                            color: Colors.blue,
                          ),
                          onDismissed: (direction) {
                            if (direction == DismissDirection.startToEnd) {
                              ScaffoldMessenger.of(context).showSnackBar(

                                  SnackBar(
                                      content: Text('$index item deleted')));

                              widget.onDeleteNotification(index);

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

                                ), // Background color for the notification
                                padding: EdgeInsets.all(
                                    10), // Padding around the notification
                                margin: EdgeInsets.all(
                                    20), // Margin between notifications

                                ),
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.all(20),

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(

                                      notificationData.message,

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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            DateFormat('dd/MM/yyyy   h:mm a')
                                                .format(notificationData
                                                    .receivedDateTime),
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    ),
                                    SizedBox(height: 5),
                                    // Align(
                                    //   alignment: Alignment.bottomRight,
                                    //   child: Column(
                                    //     crossAxisAlignment:
                                    //         CrossAxisAlignment.start,
                                    //     children: [
                                    //       Text(
                                    //         DateFormat('dd/MM/yyyy   h:mm a')
                                    //             .format(timelist?[index]),
                                    //         style: TextStyle(
                                    //           fontSize: 16,
                                    //           color: Colors.grey,
                                    //           fontWeight: FontWeight.bold,
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),

                                  ],
                                ),
                              ),
                            ],
                          ),
                        );

                      }),
                    )

                      },
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
