import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:budgettrack/pages/homePage.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyMenu(),
    );
  }
}

class MyMenu extends StatefulWidget {
  _MyMenuState createState() => _MyMenuState();
}

class _MyMenuState extends State<MyMenu> {
  double rating = 0;
  String version = '1.0.0';
  void UpdateVersion(String newVersion) {
    setState(() {
      version = newVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 170,
              width: 400,
              margin: EdgeInsets.only(left: 20, right: 15),
              decoration: const BoxDecoration(
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
                      icon: const Icon(
                        weight: 10,
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
                  const FractionallySizedBox(
                    //UAbove the percentage value I have displayed the current date and time
                    widthFactor: 1.0,
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(top: 0),
                        child: Text(
                          'Budget Tracker',
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
            SingleChildScrollView(
              child: Container(
                height: 600,
                width: 400,
                margin: const EdgeInsets.only(left: 20, right: 15, top: 10),
                decoration: const BoxDecoration(
                  color: Color(0xffCED8DC),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const FractionallySizedBox(
                      //UAbove the percentage value I have displayed the current date and time
                      widthFactor: 1.0,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20, top: 20),
                          child: Text(
                            'About',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 400,
                      height: 100,
                      margin:
                          const EdgeInsets.only(left: 20, top: 10, right: 20),
                      decoration: const BoxDecoration(
                        color: Color(0xffEDF2FB),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: TextFormField(
                        minLines: 2,
                        maxLines: 5,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Description...',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    FractionallySizedBox(
                      //UAbove the percentage value I have displayed the current date and time
                      widthFactor: 1.0,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                          ),
                          child: Row(
                            children: [
                              const Text(
                                'Settings          ',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.settings,
                                    color: Colors.black, size: 35),
                                onPressed: () {
                                  print("Amma");
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const FractionallySizedBox(
                      //UAbove the percentage value I have displayed the current date and time
                      widthFactor: 1.0,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20, bottom: 30),
                          child: Text(
                            'Language',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const FractionallySizedBox(
                      //UAbove the percentage value I have displayed the current date and time
                      widthFactor: 1.0,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20, bottom: 0),
                          child: Text(
                            'Version',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 0, left: 150),
                        child: Text(
                          '$version',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const FractionallySizedBox(
                      //UAbove the percentage value I have displayed the current date and time
                      widthFactor: 1.0,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20, bottom: 30),
                          child: Text(
                            'Rate Us',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'Rating:$rating',
                      style: const TextStyle(fontSize: 30, color: Colors.black),
                    ),
                    Container(
                      child: RatingBar.builder(
                          itemBuilder: (context, _) =>
                              const Icon(Icons.star, color: Colors.amber),
                          minRating: 1,
                          itemSize: 46,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4),
                          updateOnDrag: true,
                          onRatingUpdate: (newRating) {
                            setState(() {
                              rating = newRating;
                            });
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
