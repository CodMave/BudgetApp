import 'dart:convert';
import 'dart:typed_data';
import 'package:budgettrack/pages/MyMenu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginPage.dart';
import 'homePage.dart';

class Check extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(300, 812),
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Profile(), //routes to the Profile class
      ),
    );
  }
}

class Profile extends StatefulWidget {
  FirebaseAuth auth = FirebaseAuth.instance;

  Profile({
    Key? key,
    this.title,
  }) : super(key: key);

  final String? title;

  @override
  _Profile createState() => _Profile();
}

class _Profile extends State<Profile> {
  //private class of the Profile class

  Uint8List? _image; //initialize the image variable
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _imagekey =
      'user_image'; //initialize the _imagekey to hold default value to the image

  PickImage(ImageSource source) async {
    //Allow the user to pick an image to change the profile
    final ImagePicker _imagepicker = ImagePicker();
    XFile? _file = await _imagepicker.pickImage(source: source);
    if (_file != null) {
      return await _file.readAsBytes();
    }
  }

  void initState() {
    super.initState();
    loadStoredImage();
  }

  void loadStoredImage() async {
    //load the profile image when the user load the app
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imageData = prefs.getString(_imagekey);
    if (imageData != null) {
      setState(() {
        _image = base64Decode(imageData); //decode image to String
      });
    }
  }

  void saveImageToStorage(Uint8List image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String imageData =
        base64Encode(image); //again encode the String to the image

    prefs.setString(_imagekey, imageData);
  }

  void SelectImageFromGalery() async {
    //allows user to select an image from the gallery
    Uint8List img = await PickImage(ImageSource.gallery);
    if (img != null) {
      saveImageToStorage(img); //save the image

      setState(() {
        _image = img;
      });
    }
  }

  void
      TakePhoto() async //allows to user to set the profile image as taken photo fro camera
  {
    Uint8List img = await PickImage(ImageSource.camera);
    if (img != null) {
      saveImageToStorage(img); //save the image

      setState(() {
        _image = img;
      });
    }
  }

  static Future<String> getUserName() async {
    //get the username of the current user and display it as text
    User? user = _auth.currentUser;
    email = user!.email!;
    if (user != null) {
      //the query check wither the authentication email match with the email which is taken at the user details
      QuerySnapshot qs = await FirebaseFirestore.instance
          .collection('userDetails')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (qs.docs.isNotEmpty) {
        // Loop through the documents to find the one with the matching email
        for (QueryDocumentSnapshot doc in qs.docs) {
          if (doc.get('email') == email) {
            // Get the 'username' field from the matching document
            String username = doc.get('username');
            print(username);
            return username; //return the user name
          }
        }
      }
      // Handle the case when no matching documents are found for the current user
      print('No matching document found for the current user.');
      return ''; // Return an empty string or null based on your requirements
    } else {
      // Handle the case when the user is not authenticated
      print('User not authenticated.');
      return ''; // Return an empty string or null based on your requirements
    }
  }

  static Future<String> getCurrency() async {
    //get the currency that user selected and show it as text
    User? user = _auth.currentUser;
    email = user!.email!;
    if (user != null) {
      QuerySnapshot qs = await FirebaseFirestore.instance
          .collection('userDetails')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (qs.docs.isNotEmpty) {
        // Loop through the documents to find the one with the matching email
        for (QueryDocumentSnapshot doc in qs.docs) {
          if (doc.get('email') == email) {
            // Get the 'username' field from the matching document
            String currency = doc.get('currency');
            print(currency);
            return currency; //return the currency
          }
        }
      }
      // Handle the case when no matching documents are found for the current user
      print('No matching document found for the current user.');
      return ''; // Return an empty string or null based on your requirements
    } else {
      // Handle the case when the user is not authenticated
      print('User not authenticated.');
      return ''; // Return an empty string or null based on your requirements
    }
  }

  Widget buttonsheet(context) {
    //show button sheet when the user click on the camera allows to set a new image
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Text(
            "Choose profile picture",
            style: TextStyle(fontSize: 20.0),
          ),
          Row(
            children: [
              TextButton.icon(
                onPressed: () {
                  //camera option to set the image
                  TakePhoto();
                },
                icon: Icon(Icons.camera),
                label: Text('camera'),
              ),
              TextButton.icon(
                onPressed: () {
                  SelectImageFromGalery();
                },
                icon: Icon(Icons.image), //gallery option to set the image
                label: Text('Galery'),
              )
            ],
          )
        ],
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    //when our user press on the sign out button then user has to sign in again
    try {
      await _auth.signOut(); // Sign out the current user
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => LoginPage(
                    onTap: () {},
                  )), // Replace LoginPage with your app's login page
          (Route<dynamic> route) => false); // Clear the navigation stack
    } catch (e) {
      print('Error while signing out: $e');
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
        title: Text(
          'P R O F I L E',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 20.0,
            //fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            /// PROFILE HEADER
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(left: 40, right: 40, top: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //const SizedBox(height: 10),
                  Column(children: [
                    Container(
                      height: 250,
                      width: 250,
                      decoration: BoxDecoration(
                        color: const Color(0xffEDF2FB),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                _image != null
                                    ? //if the user hasn't set an image yet then display this image in the following circle avatar
                                    CircleAvatar(
                                        radius: 80.0,
                                        backgroundImage: MemoryImage(_image!))
                                    : CircleAvatar(
                                        //if the user set an image then display the corresponding image in the following circle avatar
                                        radius: 80.0,
                                        backgroundImage: AssetImage(
                                            'lib/images/Profileimage.png')),
                                Positioned(
                                  bottom: 20.0,
                                  right: 20.0,
                                  child: InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) =>
                                            buttonsheet(context),
                                      );
                                    },
                                    child: Icon(
                                      Icons
                                          .camera_alt, //camera icon allows user to set an image
                                      color: Colors.teal,
                                      size: 28.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FractionallySizedBox(
                  widthFactor: 1.0,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 60, top: 15),
                      child: Text(
                        'User Name',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  //this container display the current user's name as text
                  width: 300,

                  margin: EdgeInsets.only(left: 60, right: 60, top: 10),
                  padding: EdgeInsets.only(
                      top: 20.0, left: 10, right: 10, bottom: 20.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 0.0,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: FutureBuilder<String>(
                      future: getUserName(),
                      builder: (context, snapshot) {
                        return Text(
                          "${snapshot.data}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        );
                      }),
                ),
                FractionallySizedBox(
                    widthFactor: 1.0,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 60, top: 15),
                        child: Text(
                          'Currency',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 300,
                      margin:
                          const EdgeInsets.only(left: 60, right: 60, top: 10),
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 10, right: 10, bottom: 20.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 0.0,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: FutureBuilder<String>(
                        future: getCurrency(),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator(); // Show a loading indicator if the data is still loading
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return Text(
                              "${snapshot.data}",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 30),
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyMenu()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                //a button set to allow the user to move to the settings page
                                primary: Color(0xff181EAA),
                                onPrimary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 12),
                                textStyle: TextStyle(fontSize: 20),
                                elevation: 3,
                              ),
                              child: Text('Settings')),
                        ),
                        Container(
                            //this button allows to user to log out from the account
                            margin: EdgeInsets.only(top: 10),
                            child: ElevatedButton(
                              onPressed: () => _signOut(
                                  context), // Use _signOut as the onPressed callback
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xff181EAA),
                                onPrimary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 12),
                                textStyle: TextStyle(fontSize: 20),
                                elevation: 3,
                              ),
                              child: Text('Log Out'),
                            ))
                      ],
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
