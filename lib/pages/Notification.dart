import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'homePage.dart';

Future<void>_FirebaseMessagingBackgroundHandler(RemoteMessage message)async{
  await Firebase.initializeApp();
  print('Handling background message:${
  message.messageId
  }');
}
const AndroidNotificationChannel channel=AndroidNotificationChannel('high_importance_channel','High Importance Notifications',

importance: Importance.high,);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();

void main() async {


WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp();
FirebaseMessaging.onBackgroundMessage(_FirebaseMessagingBackgroundHandler);
var initializationsettingsAndroid=AndroidInitializationSettings('@mipmap/ic_launcher');
var initializationsettings=InitializationSettings(android: initializationsettingsAndroid);
flutterLocalNotificationsPlugin.initialize( initializationsettings);
await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
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
int times=0;
class MyHomePage extends StatefulWidget {
  static int Counter(){
    return _MyHomePageState().NumberOfNotification();
  }


  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {
    late int size1;
    late int size2;
  FirebaseMessaging msg = FirebaseMessaging.instance;
  List<NotificationData> notificationList = [];
  List<DateTime> time = [];
  SharedPreferences? _prefs;

 void initState(){
   super.initState();

   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
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

       // Add notification to the list
       addNotificationToList(notification.body ?? '');
     }
   });
   getToken();
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
       addNotificationToList(notification.body ?? '');
     }
   });
   loadSavedMessages();

 }


  void addNotificationToList(String message) {
    NumberOfNotification();
   setState(() {

    DateTime now=DateTime.now();

     final notificationData = NotificationData(
       message: message,
       receivedDateTime:now,
     );
     notificationList.insert(0, notificationData);
     saveMessage(notificationData);

   });
 }


  Future<void> saveMessage(NotificationData notificationData) async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    final messages =
    notificationList.map((notification) => notification.message).toList();
    final times = notificationList
        .map((notification) => notification.receivedDateTime.toString())
        .toList();
    _prefs!.setStringList('messages', messages);
    _prefs!.setStringList('times', times);
  }

  Future<void> loadSavedMessages() async {
    _prefs = await SharedPreferences.getInstance();
    final savedMessages = _prefs!.getStringList('messages');
    final savedTimes = _prefs!.getStringList('times');

    if (savedMessages != null && savedTimes != null) {
      setState(() {
        notificationList = savedMessages
            .map((message) {
          final index = savedMessages.indexOf(message);
          final receivedTime = DateTime.parse(savedTimes[index]);
          return NotificationData(
            message: message,
            receivedDateTime: receivedTime,
          );
        })
            .toList();
        if (_prefs != null) {
          if (savedMessages != null) {
            times = notificationList.length - savedMessages.length;
          }
        }
      });
    }
  }

  int NumberOfNotification(){
   return times;
  }
    getToken()async{
      String? token=await FirebaseMessaging.instance.getToken();

    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 170,
                        width: 400,
                        margin: EdgeInsets.only(left: 20, right: 15),
                        decoration: BoxDecoration(
                          color: Color(0xff181EAA),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.topLeft,
                          children: [
                            Container(
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios_new,
                                  size: 40,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomePage(),
                                    ),
                                  );
                                },
                              ),
                            ),
                            FractionallySizedBox(
                              //UAbove the percentage value I have displayed the current date and time
                              widthFactor: 1.0,
                              child: Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 0),
                                  child: Text(
                                    'Notifications',
                                    style: TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: notificationList.length,
                          itemBuilder: (context, index){
                            final notificationData = notificationList[index];

                            return Column(
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    notificationData.message,
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
                                          DateFormat('dd/MM/yyyy   h:mm a').format(notificationData.receivedDateTime),
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
                            );
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
