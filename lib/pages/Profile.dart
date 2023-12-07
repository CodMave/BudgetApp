import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';
import 'package:budgettrack/pages/authPage.dart';
import 'package:budgettrack/pages/plans.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'Summery.dart';
import 'TextScanner.dart';
import 'forgotPassword.dart';
import 'goals.dart';
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
  String? selectedCurrency = "USD";
  //private class of the Profile class

  List currency = [
    'USD',
    'EUR',
    'INR',
    'SLR',
    'GBP',
    'AUD',
    'CAD'
    // ADD MORE
  ];
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

//  _image = base64Decode(imageData); //decode image to String
  void initState() {
    super.initState();
    loadStoredImage();
  }
  void ChangeCurrency() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Colors.white),
          ),
          backgroundColor: Colors.white,
          title:Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              children: [
                DropdownButtonFormField(
                  value: selectedCurrency,
                  items: currency.map((listValue) {
                    return DropdownMenuItem(
                      value: listValue,
                      child: Text(listValue),
                    );
                  }).toList(),
                  onChanged: (valueSelected) {
                    setState(() {
                      selectedCurrency = valueSelected as String;
                    });
                  },
                  icon: Icon(
                    Icons.arrow_downward_outlined,
                    color: Colors.grey[800],
                  ),
                  dropdownColor: Colors.grey[200],
                  decoration: InputDecoration(
                    labelText: "Selet The Currency",
                    labelStyle: TextStyle(
                        fontFamily:'Lexend-VariableFont',
                        color:  Color(0xFF090950),
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                    prefixIcon: Icon(
                      Icons.attach_money_sharp,
                      color: Colors.grey[700],
                      size: 40,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: (){
                    updateCurrency(selectedCurrency!);
                  },
                  child: Text('Ok'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  Future<void> updateCurrency(String currency) async {
    User? user = _auth.currentUser;
    String? email = user?.email;
    print(email);

    try {
      QuerySnapshot qs = await FirebaseFirestore.instance
          .collection('userDetails')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (qs.docs.isNotEmpty) {
        // Get the reference to the first document in the result set
        DocumentReference docRef = qs.docs.first.reference;

        // Update the 'currency' field of the document
        await docRef.update({
          'currency': currency,
        });

        print('Currency updated successfully!');
      }
    } catch (ex) {
      print(ex);
    }

    setState(() {});
  }

  Future<Uint8List?> getImageFromFirestore() async {
    try {
      User? user = _auth.currentUser;
      String username = user!.uid;

      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      final CollectionReference profileImageCollection = firestore
          .collection('userDetails')
          .doc(username)
          .collection('ProfileImage');

      QuerySnapshot imageDocuments = await profileImageCollection.get();

      if (imageDocuments.docs.isNotEmpty) {
        // If there are image documents, retrieve the first one (assuming only one exists)
        String base64Image = imageDocuments.docs.first['Userimage'];

        // Decode the base64-encoded image data and return it as Uint8List
        Uint8List imageBytes = base64Decode(base64Image);
        return imageBytes;
      } else {
        return null; // Return null if no image documents are found
      }
    } catch (ex) {
      print('Image retrieval from Firestore failed: $ex');
      return null; // Return null to indicate failure
    }
  }


  void loadStoredImage() async {

    Uint8List? profileImage = await getImageFromFirestore();

    if (profileImage != null) {
      setState(() {
        _image = profileImage;
      });
    } else {
      _image=null;
    }
  }

  Future<String?> saveImageToStorage(Uint8List? image) async {
    try {
      User? user = _auth.currentUser;
      String username = user!.uid;

      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      final CollectionReference profileImageCollection = firestore
          .collection('userDetails')
          .doc(username)
          .collection('ProfileImage');

      // Query the Firestore to check if an image document already exists
      QuerySnapshot existingImages = await profileImageCollection.get();

      if (existingImages.docs.isNotEmpty) {
        // If an image document exists, update it with the new image data
        String base64Image = base64Encode(image!);
        DocumentSnapshot existingImage = existingImages.docs.first;
        await existingImage.reference.update({'Userimage': base64Image});
        print('Image updated with ID: ${existingImage.id}');
        return existingImage.id;
      } else {
        // If no image document exists, add a new one
        if (image != null) {
          String base64Image = base64Encode(image);
          DocumentReference newDocument =
          await profileImageCollection.add({'Userimage': base64Image});
          String newDocumentId = newDocument.id;
          print('New document created with ID: $newDocumentId');
          return newDocumentId;
        } else {
          return null; // Return null if no image data is provided
        }
      }
    } catch (ex) {
      print('Image upload to Firestore failed: $ex');
      return null; // Return null to indicate failure
    }
  }

  void   SelectImageFromGalery() async {
    try {
      Uint8List? img = await PickImage(ImageSource.gallery);

      if (img != null && img is Uint8List) {
        saveImageToStorage(img); // Save the image
        setState(() {
          _image = img;
        });
      } else {
        setState(() {
          _image = null;
        });
      }
    } catch (e) {

      print('Error selecting image: $e');
      setState(() {
        _image = null;
      });
    }
  }

  void removeImage() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    String username = user!.uid;

    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;


      final CollectionReference image = firestore
          .collection('userDetails')
          .doc(username)
          .collection('ProfileImage');
      QuerySnapshot existingImages = await image.get();
      DocumentSnapshot existingImage = existingImages.docs.first;
      await existingImage.reference.delete();
     loadStoredImage();

    } catch (ex) {
      print('Error deleting image: $ex');
    }
  }


  void TakePhoto() async //allows to user to set the profile image as taken photo fro camera
      {
        try {
          Uint8List img = await PickImage(ImageSource.camera);
          if (img != null) {
            saveImageToStorage(img); //save the image

            setState(() {
              _image = img;
            });
          }
        }
        catch(e) {
            print('Displaying image error ');
  setState(() {
  _image = null;
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
      QuerySnapshot qs = await FirebaseFirestore.instance.collection(
        //the query check wither the authentication email match with the email which is taken at the user details
          'userDetails').where('email', isEqualTo: email).limit(1).get();

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
      width: MediaQuery
          .of(context)
          .size
          .width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Text(
            "Choose profile picture",
            style: TextStyle(fontSize: 20.0),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              ),
              TextButton.icon(
                onPressed: () {
                removeImage();

                },
                icon: Icon(Icons.delete), //gallery option to set the image
                label: Text('Remove'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await _auth.signOut(); // Sign out the current user
      Navigator.of(context).popUntil((route) => route.isFirst); // Clear the navigation stack
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthPage())); // Navigate to the initial route
    } catch (e) {
      print('Error while signing out: $e');
    }
  }



  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(

        backgroundColor: Colors.grey[100],

        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              color: Color(0xFF090950),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomePage()
                  ),
                );
              },
            ),
            SizedBox(width:95),
            Text(
              'M E N U',
              style: TextStyle(
                fontFamily:'Lexend-VariableFont',
                color: Color(0xFF090950),
                fontSize: 20.0,
                //fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), bottomRight: Radius.circular(20),bottomLeft:Radius.circular(20) )),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 3,
          ),
          child: GNav(
            backgroundColor: Colors.transparent,
            color: const Color(0xFF090950),
            activeColor: const Color.fromARGB(255, 31, 96, 192),
            tabBackgroundColor: Colors.white,
            gap:6,
            onTabChange: (Index) {
              //if the user click on the bottom navigation bar then it will move to the following pages
              if (Index == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage()),
                );
              } else if (Index == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>Pro()),
                );
              } else if (Index == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>PlansApp()),
                );
              } else if (Index == 3) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Goals()),
                );
              } else if (Index ==4) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TextScanner(newBalance:newbalance)),
                );
              }
            },
            padding: const EdgeInsets.all(15),
            tabs: const [
              GButton(
                icon: Icons.home,
                //text: 'Home',
              ),
              GButton(
                icon: Icons.align_vertical_bottom_outlined,
                //text: 'Summary',
              ),
              GButton(
                icon: Icons.assignment,
                //text: 'Savings',
              ),
              GButton(
                icon: Icons.track_changes_rounded,
                //text: 'Plans',
              ),
              GButton(
                icon: Icons.document_scanner_outlined,
                //text: 'Scan',
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height:10),
                  Container(
                    margin:EdgeInsets.only(left:20,right:20),
                    width: 400,
                    height:320,

                    decoration:BoxDecoration(
                        color: Color(0xFFD5E3FA),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius:8,
                            offset: Offset(0,3),
                          ),
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height:200,
                          color: Colors.transparent,
                          child: Stack(
                            children: [
                              Positioned(
                                top:20,
                                left:100,
                                child: _image != null
                                    ? CircleAvatar(
                                    radius: 80.0,
                                    backgroundImage: MemoryImage(_image!))
                                    : CircleAvatar(
                                    radius: 80.0,
                                    backgroundImage:
                                    AssetImage('lib/images/Profile.png')),
                              ),
                              Positioned(
                                top:160,
                                right:115.0,
                                child: InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) => buttonsheet(context),
                                    );
                                  },
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.teal,
                                    size: 28.0,
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width:100,
                              height:45,
                              margin: EdgeInsets.only(left:30,),
                              decoration: BoxDecoration(
                                  color:Color(0xFFEEEEEE),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius:8,
                                      offset: Offset(0,3),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.only(topLeft:Radius.circular(20),bottomLeft:Radius.circular(20))
                              ),
                              child: Center(
                                child: Text(
                                  'Name',
                                  style: TextStyle(
                                    fontFamily:'Lexend-VariableFont',
                                    fontSize:17,
                                    color: Color(0xFF5C6C84),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              //this container display the current user's name as text
                              width:150,
                              height:45,
                              margin:EdgeInsets.only(left:20),
                              decoration: BoxDecoration(
                                  color:Color(0xFFC2DAFF),
                                  boxShadow: [
                                  BoxShadow(
                                    color: Colors.white,
                                    spreadRadius:1,
                                    blurRadius:1,
                                    offset: Offset(0,2),
                                  ),
                                  ],
                                  borderRadius: BorderRadius.only(topRight:Radius.circular(20),bottomRight:Radius.circular(20))
                              ),
                              child: FutureBuilder<String>(
                                  future: getUserName(),
                                  builder: (context, snapshot) {
                                    return Center(
                                      child: Text(
                                        "${snapshot.data}",
                                        style: TextStyle(
                                          fontFamily:'Lexend-VariableFont',
                                          color: Color(0xFF090950),
                                          fontSize:20,
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                        SizedBox(height:5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width:100,
                              height:45,
                              margin: EdgeInsets.only(top:5,left:30,),
                              decoration: BoxDecoration(
                                  color:Color(0xFFEEEEEE),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius:8,
                                      offset: Offset(0,3),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.only(topLeft:Radius.circular(20),bottomLeft:Radius.circular(20))
                              ),
                              child: Center(
                                child: Text(
                                  'Currency',
                                  style: TextStyle(
                                    fontFamily:'Lexend-VariableFont',
                                    fontSize:17,
                                    color: Color(0xFF5C6C84),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              //this container display the current user's name as text
                              width:150,
                              height:45,
                              margin:EdgeInsets.only(left:20),
                              decoration: BoxDecoration(
                                  color: Color(0xFFC2DAFF),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white,
                                      spreadRadius:1,
                                      blurRadius:1,
                                      offset: Offset(0,2),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.only(topRight:Radius.circular(20),bottomRight:Radius.circular(20))
                              ),
                              child: FutureBuilder<String>(
                                  future: getCurrency(),
                                  builder: (context, snapshot) {
                                    return Center(
                                      child: Text(
                                        "${snapshot.data}",
                                        style: TextStyle(
                                          fontFamily:'Lexend-VariableFont',
                                          color:  Color(0xFF090950),
                                          fontSize:20,
                                        ),
                                      ),
                                    );
                                  }),
                            ),

                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      SizedBox(height:10),
                      Container(
                        margin:EdgeInsets.only(top:10),
                        height:40,
                        width:double.infinity,

                        color: Color(0xFFEEEEEE),
                        child:Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left:30,),
                            child: Text(
                              'Settings',
                              style: TextStyle(
                                fontFamily:'Lexend-VariableFont',
                                color:Color(0xFF090950),
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height:5),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin:EdgeInsets.only(left:30),
                          width:350, // Set the desired width
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ForgotPassword(),
                                ),
                              );
                            },

                            style: ElevatedButton.styleFrom(
                              primary:  Color(0xFFFFFFFF),
                              onPrimary:  Color(0xFF090950),
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(
                                  'Change Password',
                                  style: TextStyle(
                                    fontFamily: 'Lexend-VariableFont',
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height:5),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin:EdgeInsets.only(left:30),
                          width:350, // Set the desired width
                          child: ElevatedButton(
                            onPressed: () {
                              ChangeCurrency();
                            },

                            style: ElevatedButton.styleFrom(
                              primary:  Color(0xFFFFFFFF),
                              onPrimary:  Color(0xFF090950),
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(
                                  'Change Currency',
                                  style: TextStyle(
                                    fontFamily: 'Lexend-VariableFont',
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin:EdgeInsets.only(top:5),
                        height:40,
                        width:double.infinity,
                        color: Color(0xFFEEEEEE),
                        child:Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left:30,),
                            child: Text(
                              'Version                       1.0.0',
                              style: TextStyle(
                                fontFamily:'Lexend-VariableFont',
                                color: Color(0xFF090950),
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin:EdgeInsets.only(top:5),
                        height:40,
                        width:double.infinity,
                        color: Color(0xFFEEEEEE),
                        child:Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left:30,),
                            child: Text(
                              'Rate Us',
                              style: TextStyle(
                                fontFamily:'Lexend-VariableFont',
                                color:Color(0xFF090950),
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin:EdgeInsets.only(top:10),
                        width:350,height:40,
                        decoration: BoxDecoration(
                          color:Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius:8,
                              offset: Offset(0,3),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: RatingBar.builder(
                            itemBuilder: (context, _) => Icon(
                                Icons.star_border,
                                color:Color(0xFF85B6FF)),
                            minRating: 1,
                            itemSize: 40,
                            itemPadding: EdgeInsets.symmetric(
                                horizontal:14),
                            updateOnDrag: true,
                            onRatingUpdate: (newRating) {
                              setState(() {
                                // this.rating = newRating;
                              });
                            }),
                      ),
                      SizedBox(height:5),
                      Divider( // Add a Divider here
                        height: 3, // You can adjust the height of the divider
                        thickness:1, // You can adjust the thickness of the divider
                        color: Colors.grey, // You can set the color of the divider
                      ),
                      Container(
                        //this button allows to user to log out from the account
                          margin: EdgeInsets.only(top:5),
                          child: ElevatedButton(
                            onPressed: () => _signOut(context),
                            // Use _signOut as the onPressed callback
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              onPrimary: Color(0xFF090950),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color:  Color(0xFF090950), // Set the border color
                                  width: 2, // Set the border width
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 12),
                              textStyle: TextStyle(
                                  fontFamily:'Lexend-VariableFont',
                                  fontSize: 20),
                              elevation: 2,
                            ),
                            child: Text('Log Out'),
                          )

                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

