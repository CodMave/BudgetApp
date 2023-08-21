import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'Profile.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(300, 812),
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyMenu(),
      ),
    );
  }
}

class MyMenu extends StatefulWidget {
  _MyMenuState createState() => _MyMenuState();
}

class _MyMenuState extends State<MyMenu> {
  String selectedValue = 'Light';
  double rating = 0;
  String version = '1.0.0';
  void UpdateVersion(String newVersion) {
    setState(() {
      version = newVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> options = ['Light', 'Dark'];
    return SafeArea(
        child: Scaffold(

      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Check(),
                ));
          },
        ),
        title: const Text(
          'S E T T I N G S',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 20,
            //fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          SingleChildScrollView(
            child: Container(
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 400,
                              height: 140,
                              margin:

                                  EdgeInsets.only(left: 20, top: 10, right: 20),
                              decoration: BoxDecoration(
                                color: Color(0xff90E0EF),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Column(
                                children: [
                                  FractionallySizedBox(
                                    //UAbove the percentage value I have displayed the current date and time
                                    widthFactor: 1.0,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 20),
                                        child: Text(
                                          'Theme',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 0),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: options.length,
                                      itemBuilder: (context, index) {
                                        String option = options[index];
                                        return Container(
                                          // Adjust vertical spacing between radio buttons
                                          child: RadioListTile(
                                            contentPadding: EdgeInsets.symmetric(
                                                horizontal:
                                                    120), // Adjust padding around the text
                                            title: Text(
                                              option,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            value: option,
                                            groupValue: selectedValue,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedValue = value as String;
                                              });
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 400,
                              height: 60,
                              margin:
                                  EdgeInsets.only(left: 20, top: 10, right: 20),
                              decoration: BoxDecoration(
                                color: Color(0xff90E0EF),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Column(
                                children: [
                                  FractionallySizedBox(
                                    //UAbove the percentage value I have displayed the current date and time
                                    widthFactor: 1.0,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 20, bottom: 5),
                                        child: Text(
                                          'Language',
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
                              width: 400,
                              height: 80,
                              margin:
                                  EdgeInsets.only(left: 20, top: 10, right: 20),
                              decoration: BoxDecoration(
                                color: Color(0xff90E0EF),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Column(
                                children: [
                                  FractionallySizedBox(
                                    //UAbove the percentage value I have displayed the current date and time
                                    widthFactor: 1.0,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.only(left: 20, top: 20),
                                        child: Text(
                                          'Change Password',
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
                              width: 400,
                              height: 100,
                              margin:
                                  EdgeInsets.only(left: 20, top: 10, right: 20),
                              decoration: BoxDecoration(
                                color: Color(0xff90E0EF),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Column(
                                children: [
                                  FractionallySizedBox(
                                    //UAbove the percentage value I have displayed the current date and time
                                    widthFactor: 1.0,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.only(left: 20, top: 20),
                                        child: Text(
                                          'Version',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
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
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 400,
                              height: 120,
                              margin:
                                  EdgeInsets.only(left: 20, top: 10, right: 20),
                              decoration: BoxDecoration(
                                color: Color(0xff90E0EF),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Column(
                                children: [
                                  FractionallySizedBox(
                                    //UAbove the percentage value I have displayed the current date and time
                                    widthFactor: 1.0,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.only(left: 20, top: 20),
                                        child: Text(
                                          'About',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 400,
                                    height: 60,
                                    margin: EdgeInsets.only(
                                        left: 20, top: 10, right: 20),
                                    decoration: BoxDecoration(
                                      color: Color(0xff90E0EF),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: TextFormField(
                                      minLines: 2,
                                      maxLines: 5,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Description...',
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 400,
                                    height: 100,
                                    margin: EdgeInsets.only(
                                        left: 20, top: 10, right: 20),
                                    decoration: BoxDecoration(
                                      color: Color(0xff90E0EF),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: Column(children: [
                                      FractionallySizedBox(
                                        //UAbove the percentage value I have displayed the current date and time
                                        widthFactor: 1.0,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 20, bottom: 5),
                                            child: Text(
                                              'Rate Us',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'Rating:$rating',
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.black),
                                      ),
                                      Container(
                                        child: RatingBar.builder(
                                            itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.amber),
                                            minRating: 1,
                                            itemSize: 40,
                                            itemPadding: EdgeInsets.symmetric(
                                                horizontal: 4),
                                            updateOnDrag: true,
                                            onRatingUpdate: (newRating) {
                                              setState(() {
                                                this.rating = newRating;
                                              });
                                            }),
                                      ),
                                    ]),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ]),
      ),
    ));
  }
}
