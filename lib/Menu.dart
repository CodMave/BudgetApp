import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:homeindex/main.dart';

main(){
  runApp(Menu());
}
class Menu extends StatelessWidget{
  const Menu({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: MyMenu(),
    );
  }
}
class MyMenu extends StatefulWidget{
  _MyMenuState createState()=>_MyMenuState();
}
class _MyMenuState extends State<MyMenu> {
  double rating=0;
  String version='1.0.0';
  void UpdateVersion(String newVersion){
    setState(() {
      version=newVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:Scaffold(
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
            height: 170,
            width:400,
            margin: EdgeInsets.only(left:20,
                right:15),
            decoration: BoxDecoration(
              color:Color(0xff181EAA),

              borderRadius:BorderRadius.only(bottomLeft:Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              ),
                child:Stack(
                  alignment: Alignment.topLeft,
                  children: [
                Container(

                  child: IconButton(
                  icon:  Icon(
                    weight:10,
                  Icons.arrow_back_ios_new,
                    size:40,
                    color: Colors.white,
                   ),
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder:(context)=>MyApp(),
                      ),
                      );
                    },

                ),
                ),

                  FractionallySizedBox(//UAbove the percentage value I have displayed the current date and time
                    widthFactor:1.0,
                    child:Align(
                      alignment: Alignment.center,
                      child :Padding(
                        padding: EdgeInsets.only(top:0),
                        child:Text(
                          'Budget Tracker',
                          style: TextStyle(
                            fontSize:35,
                            fontWeight: FontWeight.bold,
                            color:Colors.white,
                          ),
                        ),
                      ),
                    ),


                  ),



            ],

              ),
              ),
              Container(
                height:600,
                width:400,
                margin: EdgeInsets.only(left:20,
                    right:15,top:10),
                decoration: BoxDecoration(
                  color:Color(0xffCED8DC),

                  borderRadius:BorderRadius.all(Radius.circular(10),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    FractionallySizedBox(//UAbove the percentage value I have displayed the current date and time
                      widthFactor:1.0,
                      child:Align(
                        alignment: Alignment.centerLeft,
                        child :Padding(
                          padding: EdgeInsets.only(left:20,top:20),
                          child:Text(
                            'About',
                            style: TextStyle(
                              fontSize:20,

                              color:Colors.black,
                            ),
                          ),
                        ),
                      ),


                    ),
                Container(
                  height:100,
                  width:400,
                  margin: EdgeInsets.only(left:20,top:10,
                      right:20),
                  decoration: BoxDecoration(
                    color:Color(0xffEDF2FB),

                    borderRadius:BorderRadius.all(Radius.circular(10),

                    ),
                  ),

                ),

                    FractionallySizedBox(//UAbove the percentage value I have displayed the current date and time
                      widthFactor:1.0,
                      child:Align(
                        alignment: Alignment.centerLeft,
                        child :Padding(
                          padding: EdgeInsets.only(left:20),
                          child:Row(
                            children: [
                              Text(


                                'Settings          ',
                                style: TextStyle(
                                  fontSize:20,

                                  color:Colors.black,
                                ),
                              ),
                              IconButton(
                                icon:Icon(
                                    Icons.settings,
                                    color: Colors.black,
                                    size:35


                                ),
                                onPressed:(){
                                    print("Amma");
                                },
                              )
                            ],
                          ),

                        ),
                      ),


                    ),

                    FractionallySizedBox(//UAbove the percentage value I have displayed the current date and time
                      widthFactor:1.0,
                      child:Align(
                        alignment: Alignment.centerLeft,
                        child :Padding(
                          padding: EdgeInsets.only(left:20,bottom:30),
                          child:Text(
                            'Language',
                            style: TextStyle(
                              fontSize:20,

                              color:Colors.black,
                            ),
                          ),
                        ),
                      ),


                    ),

                    FractionallySizedBox(//UAbove the percentage value I have displayed the current date and time
                      widthFactor:1.0,
                      child:Align(
                        alignment: Alignment.centerLeft,
                        child :Padding(
                          padding: EdgeInsets.only(left:20,bottom:0),
                          child:Text(

                            'Version',
                            style: TextStyle(
                              fontSize:20,

                              color:Colors.black,
                            ),
                          ),
                        ),
                      ),


                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(

                        padding: const EdgeInsets.only(top:10,bottom:0,left:150),
                        child: Text(

                          '$version',
                          style: TextStyle(
                            fontWeight:FontWeight.bold,
                            fontSize:20,

                            color:Colors.black,
                          ),
                        ),
                      ),
                    ),
                    FractionallySizedBox(//UAbove the percentage value I have displayed the current date and time
                      widthFactor:1.0,
                      child:Align(
                        alignment: Alignment.centerLeft,
                        child :Padding(
                          padding: EdgeInsets.only(left:20,bottom:30),
                          child:Text(
                            'Rate Us',
                            style: TextStyle(
                              fontSize:20,

                              color:Colors.black,
                            ),
                          ),
                        ),
                      ),


                    ),
                    Text(
                      'Rating:$rating',
                      style: TextStyle(fontSize:30,color:Colors.black),
                    ),
                    Container(

                      child: RatingBar.builder(
                        itemBuilder:(context,_)=>Icon(Icons.star,
                        color:Colors.amber),
                        minRating: 1,
                        itemSize: 46,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4),
                        updateOnDrag: true,
                        onRatingUpdate:(newRating){
                          setState(() {
                            this.rating=newRating;
                          });

                        }
                        ),



                      ),

                  ],

                ),
              ),

            ],
          ),

        ),
    )
    );
  }
}

