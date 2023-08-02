import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  FirebaseMessaging msg = FirebaseMessaging.instance;
  List<NotificationData> notificationList = [];
  List<DateTime> time = [];
  SharedPreferences? _prefs;
  double totalex = 0.0;
  double totalin = 0.0;
  int totalBalance = 0;

  void initState() {
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

        counter();

        addNotificationToList(notification.body ?? '');
        print(notificationList.length);
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
      }
    });

    loadSavedMessages();
    getNewMessagesCount().then((value) {
      setState(() {
        flag = value;
      });
    });
  }

  Future<int> getNewMessagesCount() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs?.getInt('newMessagesCount') ?? 0;
  }

  void addNotificationToList(String message) {
    setState(() {
      DateTime now = DateTime.now();

      final notificationData = NotificationData(
        message: message,
        receivedDateTime: now,
      );

      notificationList.insert(0, notificationData);

      saveMessage();
    });
  }

  void _onDeleteNotification(int index) {
    setState(() {
      notificationList.removeAt(index);
      saveMessage();
    });
  }

  Future<void> saveMessage() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
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
    }
  }

  Future<void> loadSavedMessages() async {
    _prefs = await SharedPreferences.getInstance();

    final savedMessages = _prefs!.getStringList('messages');
    final savedTimes = _prefs!.getStringList('times');

    if (savedMessages != null && savedTimes != null) {
      setState(() {
        notificationList = savedMessages.map((message) {
          final index = savedMessages.indexOf(message);
          final receivedTime = DateTime.parse(savedTimes[index]);
          return NotificationData(
            message: message,
            receivedDateTime: receivedTime,
          );
        }).toList();
      });
    }
  }

  Future<void> counter() async {
    final newCount = flag + 1;
    _prefs = await SharedPreferences.getInstance();
    _prefs?.setInt('newMessagesCount', newCount);
    setState(() {
      flag = newCount;
    });
    print(notificationList.length);
  }

  getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Controller(
          balance: totalBalance,
          expense: totalex,
          income: totalin,
          notificationList: notificationList,
          num: flag,
          onDeleteNotification: (int index) => _onDeleteNotification(index)),
    );
  }
}

class Holder extends StatefulWidget {
  final List<NotificationData> notificationList;

  final Function(int) onDeleteNotification;

  final double totalex;
  final double totalin;
  final int totalBalance;

  Holder({
    required this.totalBalance,
    required this.totalex,
    required this.totalin,
    required this.notificationList,
    required this.onDeleteNotification,
  });

  @override
  State<Holder> createState() => _HolderState();
}

class _HolderState extends State<Holder> {
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
                    ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: List.generate(widget.notificationList.length,
                          (index) {
                        final notificationData = widget.notificationList[index];

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
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
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
