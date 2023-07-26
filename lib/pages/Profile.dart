
import 'dart:typed_data';

import 'package:budgettrack/pages/MyMenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'homePage.dart';

class Check extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(300, 812),
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home:Profile(),
      ),
    );
  }
}
class Profile extends StatefulWidget {

  Profile({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _Profile createState() => _Profile();



}
class _Profile extends State<Profile>{

  Uint8List? _image;
  final List<String> items = ['SL Rupees', 'US Dollar', 'Yen','Indian Rupees','කහවනු'];
  String selectedValue = 'SL Rupees';
  // Default selected value
   PickImage(ImageSource source)async{
    final ImagePicker _imagepicker=ImagePicker();
    XFile? _file=await _imagepicker.pickImage(source: source);
    if(_file!=null){
      return await _file.readAsBytes();
    }

  }
  void SelectImageFromGalery()async{
     Uint8List img =await PickImage(ImageSource.gallery);
     setState(() {
       _image=img;
     });
  }
  void TakePhoto()async
  {
    Uint8List img =await PickImage(ImageSource.camera);
    setState(() {
      _image=img;
    });
  }


  Widget buttonsheet(context){
    return Container(
      height:100,
      width:MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20
      ),
      child: Column(
        children: [
          Text("Choose profile picture",
            style: TextStyle(
              fontSize: 20.0
            ),
          ),

          Row(
            children: [
              TextButton.icon(onPressed: (){
                TakePhoto();
              },
                icon: Icon(Icons.camera),
                label: Text('camera'),
              ),
              TextButton.icon(onPressed: (){
                SelectImageFromGalery();
              },
                icon: Icon(Icons.image),
                label: Text('Galery'),
              )
            ],
          )

        ],
      ),
    );
  }

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
                height: 100,
                width: 400,
                margin: EdgeInsets.only(left: 20, right: 15,),
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
                            'Profile',
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
            ],
        ),
          ),
              Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.only(left:40, right:40,top:20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //const SizedBox(height: 10),
                    Column(
                      children:[
                        Container(
                          height:250,
                          width:250,
                          decoration: BoxDecoration(
                            color: const Color(0xffEDF2FB),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                                   _image!=null ?
                                   CircleAvatar(
                                       radius: 80.0,
                                       backgroundImage:
                                       MemoryImage(_image!)
                                   )
                                       :CircleAvatar(
                                      radius: 80.0,
                                      backgroundImage:
                                         AssetImage('lib/images/Profileimage.png')
                                    ),
                                    Positioned(
                                      bottom: 20.0,
                                      right: 20.0,
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

                            ],
                          ),
                        ),

                ]
                    ),


                  ],
                ),

              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FractionallySizedBox(//UAbove the percentage value I have displayed the current date and time
                    widthFactor:1.0,
                    child:Align(
                      alignment: Alignment.centerLeft,
                      child :Padding(
                        padding: EdgeInsets.only(left:60,top:15),
                        child:Text(
                          'User Name',
                          style: TextStyle(
                            fontSize:20,

                            color:Colors.black,
                          ),
                        ),
                      ),
                    ),


                  ),
                  Padding(
                    padding: EdgeInsets.only(top:10,left:60,right:60),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(10),
                          ),

                        ),
                        hintText: 'Enter your User Name',

                      ),
                    ),
                  ),
                  FractionallySizedBox(//UAbove the percentage value I have displayed the current date and time
                    widthFactor:1.0,
                    child:Align(
                      alignment: Alignment.centerLeft,
                      child :Padding(
                        padding: EdgeInsets.only(left:60,top:15),
                        child:Text(
                          'Currency',
                          style: TextStyle(
                            fontSize:20,

                            color:Colors.black,
                          ),
                        ),
                      ),
                    ),


                  ),
                  Padding(
                    padding: EdgeInsets.only(top:10,),
                    child: Align(
                      alignment: Alignment.centerLeft,

                      child: Container(
                        width: 300,
                        margin: EdgeInsets.only(left:60,right: 60),
                        padding: EdgeInsets.only(top:10.0,left:10,right:10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 0.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButton<String>(
                          value: selectedValue,
                          onChanged: (newValue) {
                           selectedValue = newValue!;
                             },

                            icon: Container(
                              margin: EdgeInsets.only(left:100),
                                child: Icon(Icons.arrow_drop_down)), // Default arrow icon
                            iconSize:45,
                            elevation: 16,
                            style: TextStyle(color: Colors.black, fontSize: 18),
                            underline: Container(
                              height: 0,
                              color: Colors.transparent,
                            ),

                          items: items.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top:30),
                        child:ElevatedButton(
                            onPressed:(){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => MyMenu()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xff181EAA),
                              onPrimary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(horizontal:40,vertical: 12),
                              textStyle: TextStyle(fontSize:20),
                              elevation: 3,
                            ),

                            child:Text('Settings')),
                      ),
                      Container(
                        margin: EdgeInsets.only(top:10),
                        child:ElevatedButton(
                            onPressed:(){
                              print('Hello World');

                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xff181EAA),
                              onPrimary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(horizontal:40,vertical: 12),
                              textStyle: TextStyle(fontSize:20),
                              elevation: 3,
                            ),

                            child:Text('Log Out')),
                      )
                    ],

                  )
                ],
              )
        ],
      ),
    ),
    ),
    );

  }
}