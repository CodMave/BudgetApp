import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';//Icon package from font awesome
import 'package:homeindex/Menu.dart';
import 'package:intl/intl.dart';//Date format package
import 'package:percent_indicator/percent_indicator.dart';//package of the percentage indicator which is used to display the percentage as diagrammatically
main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget{
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,//Color of the app bar
      ),
      home: MyHomePage(),
    );
  }
}

double balance=6920.73;//variable which shows the value of the current balance
class MyHomePage extends StatelessWidget{
  double percent=0.85;//percentage of the balance to the expenses
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
       // backgroundColor: Colors.black,
        appBar: AppBar(

          title: Text("Hello,Sehan!",//name of the user
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
            ),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(//Icons in the app bar
            color: Colors.black,
            size:40
          ),
          leading: IconButton(
              onPressed: (){
                Navigator.push(
                context,
                  MaterialPageRoute(builder:(context)=>MyMenu()

                  ),

                );
              },
              icon:Icon(Icons.menu),//to change the further setting used a hamburger icon

          ),
         actions: [
           IconButton(
             onPressed: (){},
             icon:Icon(Icons.notifications_active_outlined),//notification icon
           ),
         ],
         bottom: PreferredSize(
           preferredSize:Size.fromHeight(10.0),//App bar size to the bottom side
           child:Container() ,
         ),
        ),

        body: Container(//implementation in the body
          alignment: Alignment.topCenter,

              child:Column(//I need to place the all the elements as a column
            mainAxisAlignment: MainAxisAlignment.start,//locate the  CircularPercentIndicator to the top of the body
                children: [
              SizedBox(height:10),

             Container(//container wigit which caries the percentageIndicator
               height: 270,
               width:450,
               decoration: BoxDecoration(
                 color:Color(0xffEDF2FB),
                 borderRadius:BorderRadius.circular(10),
               ),

               margin: EdgeInsets.only(left:20,top:10,right:20,),
               child: Stack(
                 alignment: Alignment.center,
                 children: [
                 CircularPercentIndicator(

                 radius:120,
                 lineWidth: 30,
                 percent:percent,
                 progressColor: Color(0xff039EF0),
                 backgroundColor:Color(0xff181EAA),
                   center:Text(
                       '${(percent*100).toStringAsFixed(0)}%',//Inside space of the indicator I have displayed the percentage of the "percent" value
                       style:TextStyle(
                         fontSize:60,
                         fontWeight: FontWeight.bold,
                         color:Colors.black,
                       ),



                   ),
                 ),
                   FractionallySizedBox(//UAbove the percentage value I have displayed the current date and time
                     widthFactor:1.0,
                     child:Align(
                       alignment: Alignment.topCenter,
                       child :Padding(
                         padding: EdgeInsets.only(top:60.0),
                         child:Text(
                           DateFormat('MMMM dd').format(DateTime.now()),
                           style: TextStyle(
                             fontSize:25,
                             fontWeight: FontWeight.bold,
                             color:Colors.black,
                           ),
                         ),
                       ),
                     ),


                   ),
                   FractionallySizedBox(//Under the Percentage I have displayed the word remaining
                     widthFactor:1.0,
                     child:Align(
                       alignment: Alignment.center,
                       child :Padding(
                         padding: EdgeInsets.only(top:90.0),
                         child:Text(
                          'Remaining',
                           style: TextStyle(
                             fontSize:20,
                             fontWeight: FontWeight.bold,
                             color:Colors.black,
                           ),
                         ),
                       ),
                     ),
                   )
                 ],

               ),


             ),
              Positioned(child: Container(//All the percentage indicator is located inside size of 150,450 dimensions of coloured box
                height: 150,
                width:450,
                  margin: EdgeInsets.only(left:20,top:10,right:20,),

                  decoration: BoxDecoration(
                borderRadius:BorderRadius.circular(10),
                    color:Color(0xff90E0EF),
              ),
                child: Stack(
                  children:[

                    FractionallySizedBox(//then Under the percentage indicator I have created the coloured box which shows the current balance

                      widthFactor:1.0,
                      child:Align(
                        alignment: Alignment.topCenter,
                        child :Padding(
                          padding: EdgeInsets.only(top:10.0),
                          child:Text(

                            'Balance',//balance word has displayed
                            style: TextStyle(
                              fontSize:40,
                              fontWeight: FontWeight.bold,
                              color:Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(child: Container(//I have created another space to show the balance
                      height: 90,
                      width:450,
                      margin: EdgeInsets.only(left:30,top:60,right:30,),

                      decoration: BoxDecoration(
                        borderRadius:BorderRadius.only(
                          topLeft:Radius.circular(40),
                        topRight: Radius.circular(40)),
                        color:Color(0xff86D5FF),
                      ),
                      child: Stack(
                        children:[
                          FractionallySizedBox(
                            widthFactor:1.0,
                            child:Align(
                              alignment: Alignment.bottomCenter,
                              child :Padding(
                                padding: EdgeInsets.only(top:10.0,bottom:10),
                                child:Text(
                                  'RS.${(balance).toString()}',
                                  style: TextStyle(
                                    fontSize:40,
                                    fontWeight: FontWeight.bold,
                                    color:Colors.black,


                                  ),
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),

                    ),
                    ),


                  ],

              ),

              ),
              ),
                  Container(
                    child: Stack(

                      children:[
                        FractionallySizedBox(

                          widthFactor:1.0,
                          child:Align(
                            alignment: Alignment.topLeft,
                            child :Padding(
                              padding: EdgeInsets.only(top:15,left:22),
                              child:Text(
                                'Activity',
                                style: TextStyle(
                                  fontSize:20,
                                  fontWeight: FontWeight.bold,
                                  color:Colors.black,


                                ),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        height: 120,
                        width:220,
                        margin: EdgeInsets.only(top:5,left:20,),
                        decoration: BoxDecoration(

                          borderRadius:BorderRadius.all(Radius.circular(10)),
                          color:Color(0xff86D5FF),
                        ),
                        child: Stack(

                          children:[
                            FractionallySizedBox(

                              widthFactor:1.0,
                              child:Align(
                                alignment: Alignment.topLeft,
                                child :Padding(
                                  padding: EdgeInsets.only(top:5,left:5),
                                  child:Text(
                                    'Recent',
                                    style: TextStyle(
                                      fontSize:20,
                                      fontWeight: FontWeight.bold,
                                      color:Colors.black,


                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                      width:60.0,
                                      height:60.0,
                                      margin: EdgeInsets.only(top:35,left:10),
                                      decoration: BoxDecoration(

                                        shape:BoxShape.circle,
                                        border: Border.all(
                                          color:Color(0xff181EAA),
                                          width:3.0,
                                        ),
                                      ),
                                  child:Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                      child: IconButton(
                                        icon:  Icon(
                                          FontAwesomeIcons.car,
                                          size:40,
                                          color: Colors.black,


                                        ),
                                        onPressed: (){
                                          print("transport");
                                          //open the expence of transport
                                        },
                                      ),
                                  ),
                                    ),
                                Container(
                                  width:60.0,
                                  height:60.0,

                                  margin: EdgeInsets.only(top:35,left:10),
                                  decoration: BoxDecoration(

                                    shape:BoxShape.circle,
                                    border: Border.all(
                                      color:Color(0xff181EAA),
                                      width:3.0,
                                    ),
                                  ),
                                  child:Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        FontAwesomeIcons.burger,
                                        size:40,
                                        color: Colors.black,



                                      ),
                                      onPressed: (){
                                        print("Food and beverages");
                                        //open the food and beverages of expences
                                      },
                                    ),
                                  )

                                ),
                                Container(
                                  width:50.0,
                                  height:50.0,
                                  margin: EdgeInsets.only(top:35,left:20),
                                  decoration: BoxDecoration(

                                    shape:BoxShape.circle,
                                    border: Border.all(
                                      color:Colors.grey,
                                      width:3.0,
                                    ),
                                  ),
                                    child:Container(

                                      child: IconButton(
                                        icon:Icon( FontAwesomeIcons.plus,
                                          size:30,
                                          color: Colors.grey,),
                                        onPressed: (){
                                          print("Amma");

                                          //press to add additional expences

                                        },
                                        ),
                                    )

                                  ),


                              ],
                            ),
                          ],

                        ),



                      ),
                      InkWell(
                        onTap:(){
                          print("Savings");
                        },
                        child: Container(
                          height: 120,
                          width:140,
                          margin: EdgeInsets.only(top:5,left:10,),
                          decoration: BoxDecoration(

                            borderRadius:BorderRadius.all(Radius.circular(10)),
                            color:Color(0xff86D5FF),
                          ),
                          child: Stack(

                            children:[
                            FractionallySizedBox(

                            widthFactor:1.0,
                            child:Align(
                              alignment: Alignment.topLeft,
                              child :Padding(
                                padding: EdgeInsets.only(top:5,left:5),
                                child:Text(
                                  'Savings',
                                  style: TextStyle(
                                    fontSize:20,
                                    fontWeight: FontWeight.bold,
                                    color:Colors.black,


                                  ),
                                ),
                              ),
                            ),
                          ),
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(top:25),
                                child: Image(
                                  width:80,
                                  height:80,
                                  image:AssetImage('assets/Savings.png'),
                               ),
                              )

                          ],
                        ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                      InkWell(
                        onTap: (){
                          print("this is for you");
                          //handle the button press of income
                        },
                        child: Container(
                          height:80,
                          width:80,
                          margin: EdgeInsets.only(top:15),

                          decoration: BoxDecoration(

                            borderRadius:BorderRadius.all(Radius.circular(10)),
                            color:Color(0xff86D5FF),
                          ),
                          child: Stack(

                            children:[

                              Container(
                                alignment: Alignment.center,
                                 child: Image(
                                  width:60,
                                  height:60,
                                  image:AssetImage('assets/Income.png'),
                                ),
                              )

                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          print("Summery");
                          //handle the button press of Summery
                        },
                        child: Container(
                          height:80,
                          width:80,
                          margin: EdgeInsets.only(top:15),

                          decoration: BoxDecoration(

                            borderRadius:BorderRadius.all(Radius.circular(10)),
                            color:Color(0xff86D5FF),
                          ),
                          child: Stack(

                            children:[

                              Container(
                                alignment: Alignment.center,
                                child: Image(
                                  width:60,
                                  height:60,
                                  image:AssetImage('assets/Summery.png'),
                                ),
                              )

                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          print("Profile");
                          //handle the button press of profile
                        },
                        child: Container(
                          height:80,
                          width:80,
                         margin: EdgeInsets.only(top:15,),

                          decoration: BoxDecoration(

                            borderRadius:BorderRadius.all(Radius.circular(10)),
                            color:Color(0xff86D5FF),
                          ),
                          child: Stack(

                            children:[

                              Container(
                                alignment: Alignment.center,
                                child: Image(
                                  width:60,
                                  height:60,
                                  image:AssetImage('assets/Profile.png'),
                                ),
                              )

                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          print("profile");
                          //handle the button press of novality
                        },
                        child: Container(
                          height:80,
                          width:80,
                          margin: EdgeInsets.only(top:15,),

                          decoration: BoxDecoration(

                            borderRadius:BorderRadius.all(Radius.circular(10)),
                            color:Color(0xff86D5FF),
                          ),

                        ),
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
