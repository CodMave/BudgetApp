import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;
  List<String> screentextList = ["Home", "Transactions", "Savings", "Plans", "Summary","Goals","Scan","Notifications","Menu"];
  List<String> screensubtextList = [
    "This is your main budget dashboard. See your overall income and expense summary, set goals, and track your progress.",
    "Easily add your income and expenses to the app. Your data is stored securely and used to generate reports and summaries.",
    "Track your monthly savings and generate reports to see how you're doing over time. This will help you reach your financial goals faster.",
    "Create budget plans to allocate your income to different expense categories. This will help you stay on track with your financial goals.",
    "See your income and expense reports as graphs for weeks, months, or years, and view category percentages to get a clear picture of your finances.",
    "Set financial goals to save for specific targets, such as a vacation or emergency fund. The app will track your progress toward these goals.",
    "Scan your bills and receipts to automatically add them to your transaction records. This will help you stay organized and generate accurate reports.",
    "Set up reminders for upcoming bills and financial goals. This will help you stay on top of your finances.",
    "View and manage your personal information, settings, app ratings ang logout the app."
  ];

  PageController pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    _startSlideshow();
  }

  void _startSlideshow() {
    Timer.periodic(Duration(seconds: 5), (Timer t) {
      if (pageController.page != null) {
        final nextPage = (currentIndex + 1) % screentextList.length;
        pageController.animateToPage(
          nextPage,
          duration: Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Slideshow Demo',
      home: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              child: PageView(
                controller: pageController,
                scrollDirection: Axis.horizontal,
                onPageChanged: (int page) {
                  setState(() {
                    currentIndex = page;
                  });
                },
                children: [
                  Image.asset('lib/images/image1.png'),
                  Image.asset('lib/images/image2.png'),
                  Image.asset('lib/images/image3.png'),
                  Image.asset('lib/images/image4.png'),
                  Image.asset('lib/images/image5.png'),
                  Image.asset('lib/images/image6.png'),
                  Image.asset('lib/images/image7.png'),
                  Image.asset('lib/images/image8.png'),
                  Image.asset('lib/images/image9.png'),
                ],
              ),
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Container(
                    child: Text(
                      screentextList[currentIndex],
                      style: TextStyle(color: Colors.blue, fontSize: 20.0),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Container(
                    child: Text(
                      screensubtextList[currentIndex],
                      style: TextStyle(color: Colors.blueGrey, fontSize: 16.0),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        backgroundColor: Color(0xFF090950),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.all(10.0),
                        elevation: 5.0,
                      ),
                      onPressed: () {
                        pageController.jumpToPage(0);
                      },
                      child: Text("Get Started"),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
