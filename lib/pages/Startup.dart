
import 'package:budgettrack/pages/authPage.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

import 'loginOrReg.dart';



class Myclass extends StatelessWidget {
  const Myclass({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late VideoPlayerController _controller;
  String screentext = '';
  String screensubtext = '';
  Timer? timer;
  int pos = 0;
  List<String> screentextList = ["M Buddy", "M Buddy", "M Buddy"];
  List<String> screensubtextList = [
    "Take control of your finances like never before with our powerful budget tracking app.",
    "Whether you're a seasoned pro or just starting your financial journey.",
    "Budget tracker is here to simplify your money management and help you achieve your financial goals"
  ];

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('lib/videos/logo.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
    _controller.play();
    _controller.setLooping(true);
    _controller.setVolume(0.0);
    timer = Timer.periodic(Duration(seconds: 15), (Timer t) {
      setState(() {
        screentext = screentextList[pos];
        screensubtext = screensubtextList[pos];
        pos = (pos + 1) % screentextList.length;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              child: _controller.value.isInitialized
                  ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
                  : Container(),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Container(
                    child: Text(
                      screentext,
                      style: TextStyle(color: Colors.blue, fontSize: 20.0),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Container(
                    child: Text(
                      screensubtext,
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
                        backgroundColor: Color(0xff222327),
                        foregroundColor: Colors.yellow,
                        padding: EdgeInsets.all(10.0),
                        elevation: 5.0,
                      ),
                      onPressed: () {
                         Navigator.push(context,
                 MaterialPageRoute(builder: (context) =>AuthPage()),//create the connection to the Uth page
                          );
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

