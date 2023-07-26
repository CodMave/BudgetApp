import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:budgettrack/pages/Notification.dart';
import 'package:budgettrack/pages/MyMenu.dart';
import 'package:badges/badges.dart' as badges;
import 'Notification.dart';
import 'Profile.dart';
import 'expenceAndIncome.dart';
import 'goals.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(325, 812),
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyWork(),
      ),
    );
  }
}

double balance = 6920.73;

class Controller extends StatelessWidget {
  final List<NotificationData> notificationList;
  final int num;
  final void Function(int index) onDeleteNotification;
  double percent = 0.85;


  Controller({Key? key, required this.notificationList,required this.num, required this.onDeleteNotification,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Hello, Sehan!",
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
            ),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.black,
            size: 40,
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Check()),
              );
            },
            icon: const Icon(Icons.menu),
          ),
          actions: [
            num==0?IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>Holder( notificationList: notificationList, onDeleteNotification:onDeleteNotification,)),
                );
              },
              icon:Icon(Icons.notifications_active_outlined, size:40,),

            )
                : badges.Badge(


              badgeContent:
              Text('${


                  num

              }'),

              position:badges.BadgePosition.topEnd(top:2, end:0),
              badgeAnimation: badges.BadgeAnimation.slide(

              ),
              badgeStyle: badges.BadgeStyle(

                shape: badges.BadgeShape.circle,
                padding: EdgeInsets.all(8.0),
                badgeColor: Colors.red,


              ),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>Holder( notificationList: notificationList, onDeleteNotification:onDeleteNotification)),
                  );
                },
                icon:Icon(Icons.notifications_active_outlined, size:40,),

              ),
            ),
          ],

        ),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //const SizedBox(height: 10),
                Container(
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
                        center: Text(
                          '${(percent * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: 1.0,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 60.0),
                            child: Text(
                              DateFormat('MMMM dd').format(DateTime.now()),
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
                            'Balance',
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
                                'RS.${balance.toString()}',
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
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
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
                        child: Stack(
                          children: [
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.only(top: 5, left: 5),
                                child: Text(
                                  'Recent',
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
                                              builder: (context) =>
                                                  const Expence()),
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
                                              builder: (context) =>
                                                  const Expence()),
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
                                            builder: (context) =>
                                                const Expence()),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          print("Savings");
                        },
                        child: Container(
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
                                  image: AssetImage('lib/images/Savings.png'),
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
                        print("Income");
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
                            image: AssetImage('lib/images/Income.png'),
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
                            image: AssetImage('lib/images/Summery.png'),
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
                            image: AssetImage('lib/images/Profile.png'),
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
