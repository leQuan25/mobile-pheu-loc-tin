import 'dart:async';
import 'dart:collection';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:new_insight_for_life/Common/HexColor.dart';
import 'package:new_insight_for_life/DataTransferObject/informationDto.dart';
import 'package:page_transition/page_transition.dart';
import 'package:getwidget/getwidget.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phễu lọc tin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreenPage(),
    );
  }
}

class SplashScreenPage extends StatefulWidget {
  @override
  _splashScreenState createState() => _splashScreenState();
}

class _splashScreenState extends State<SplashScreenPage> {

  Map<int, informationDto> dataDisplayGnew = HashMap();
  Map<int, informationDto> dataDisplayBnew = HashMap();

  @override
  void initState() {
    super.initState();
    waitTofetchData();
  }

  Future<void> requestSqlDataAsync() async {
    await Firebase.initializeApp();
    var db = FirebaseFirestore.instance;
    String currentDate = "25_12_2023";
    await db.collection("appCompareInfor").doc(currentDate).get().then(
          (querySnapshot) {
        print("Successfully completed");
        var dataSnapshot = querySnapshot.data();
        int c = 0;
        for (var data in dataSnapshot?['G_New']) {
          dataDisplayGnew.putIfAbsent(c, () => informationDto.fromMap(data));
          c++;
        }
        int cc = 0;
        for (var data in dataSnapshot?['B_New']) {
          dataDisplayBnew.putIfAbsent(cc, () => informationDto.fromMap(data));
          cc++;
        }
        print("data G init" + dataDisplayGnew.length.toString());
        print("data B init" + dataDisplayBnew.length.toString());
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  waitTofetchData() async {
    await requestSqlDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 5,
      nextScreen: MyHomePage(title: 'Phễu lọc tin', dataDisplayGnew: dataDisplayGnew, dataDisplayBnew: dataDisplayBnew,),
      backgroundColor: Colors.white,
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.leftToRight,
      splash: Image.asset('images/iconApp.png', fit: BoxFit.fitWidth),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title, required this.dataDisplayGnew, required this.dataDisplayBnew});

  final String title;
  Map<int, informationDto> dataDisplayGnew;
  Map<int, informationDto> dataDisplayBnew;

  @override
  State<MyHomePage> createState() => _MyHomePageState(dataDisplayGnew: dataDisplayGnew, dataDisplayBnew: dataDisplayBnew);
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState({required this.dataDisplayGnew, required this.dataDisplayBnew});

  int counterDisplay = 0;
  Map<int, informationDto> dataDisplayGnew;
  Map<int, informationDto> dataDisplayBnew;

  @override
  void initState() {
    super.initState();
  }

  void _incrementCounter() {
    setState(() {
      counterDisplay++;
      if (counterDisplay > dataDisplayGnew.length) {
        counterDisplay = dataDisplayGnew.length;
      }
    });
  }

  void _decrementCounter() {
    setState(() {
      counterDisplay--;
      if (counterDisplay < 0) {
        counterDisplay = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onPanEnd: (details) {
          // Swiping in right direction.
          if (details.velocity.pixelsPerSecond.dx > 0) {
            print("Keo trai");
            _decrementCounter();
          }

          // Swiping in left direction.
          if (details.velocity.pixelsPerSecond.dx < 0) {
            print("Keo phai");
            _incrementCounter();
          }

        },
        child: Column(
            children: <Widget>[
              Container(
                  height: 50,
                  color: Colors.blue
              ),
              Expanded(

                  child: displayInfor(true),

              ),

              GFTypography(
                fontWeight: FontWeight.w400,
                text: 'Những thứ bạn hay thấy',
                type: GFTypographyType.typo1,
                icon: Icon(Icons.ac_unit,color: Colors.lightGreen,),
                textColor: Colors.lightGreen,
              ),
              Expanded(
                child: displayInfor(false),
              ),
            ]

        ),
      ),
    );
  }


  Widget displayInfor(bool isGDate) {
    String title = "";
    String imageUrl = "";
    String description = "";
    print("counter" + counterDisplay.toString());
    if(isGDate) {
      informationDto? dataG = dataDisplayGnew[counterDisplay];
      print("data G" + dataDisplayGnew.length.toString());
      if (dataG != null) {
        title = dataG.title;
        imageUrl = dataG.imageUrl;
        description = dataG.description;
      }
    } else {
      // informationDto? dataB = dataDisplayBnew[counterDisplay];
      // print("data B" + dataDisplayBnew.length.toString());
      // if (dataB != null) {
      //   title = dataB.title;
      //   imageUrl = dataB.imageUrl;
      //   description = dataB.description;
      // }

      final List<String> imageList = [
        "https://cdn.pixabay.com/photo/2017/12/03/18/04/christmas-balls-2995437_960_720.jpg",
        "https://cdn.pixabay.com/photo/2017/12/13/00/23/christmas-3015776_960_720.jpg",
        "https://cdn.pixabay.com/photo/2019/12/19/10/55/christmas-market-4705877_960_720.jpg",
        "https://cdn.pixabay.com/photo/2019/12/20/00/03/road-4707345_960_720.jpg",
        "https://cdn.pixabay.com/photo/2019/12/22/04/18/x-mas-4711785__340.jpg",
        "https://cdn.pixabay.com/photo/2016/11/22/07/09/spruce-1848543__340.jpg"
      ];

      return GFItemsCarousel(
            rowCount: 3,
            children: imageList.map(
                  (url) {
                return Container(
                  margin: EdgeInsets.all(5.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child:
                    Image.network(url, fit: BoxFit.cover, width: 1000.0),
                  ),
                );
              },
            ).toList(),
          );
    }

    return Container(
      color: Colors.red,
      child: GFCard(
        margin: EdgeInsets.all(0),
        color: Colors.blue,
        boxFit: BoxFit.fitWidth,

        titlePosition: GFPosition.start,
        image: Image.network(imageUrl,height: MediaQuery.of(context).size.height * 0.2,width: MediaQuery.of(context).size.width, fit: BoxFit.cover),

        showImage: true,
        title: GFListTile(
          avatar: GFAvatar(
            backgroundImage: AssetImage(imageUrl),
          ),
          titleText: title,
          subTitleText: 'vnExpress',
        ),
        // content: Text(description),
        buttonBar: GFButtonBar(
          children: <Widget>[
            GFAvatar(
              backgroundColor: GFColors.PRIMARY,
              child: Icon(
                Icons.share,
                color: Colors.white,
              ),
            ),
            GFAvatar(
              backgroundColor: GFColors.SECONDARY,
              child: Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
            GFAvatar(
              backgroundColor: GFColors.SUCCESS,
              child: Icon(
                Icons.phone,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );

  }

  // Widget titleSection(String title) {
  //     return
  //       Container(
  //         margin: EdgeInsets.fromLTRB(25, 25, 25, 10),
  //         child: DecoratedBox(
  //           decoration: BoxDecoration(
  //             color: Colors.blue, // Set the background color
  //             borderRadius: BorderRadius.circular(10.0), // Set border radius
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.black.withOpacity(0.3), // Set shadow color
  //                 blurRadius: 5.0, // Set blur radius
  //                 offset: Offset(0, 3), // Set shadow offset
  //               ),
  //             ],
  //           ),
  //           child: Container(
  //             child: Center(
  //               child:
  //               DefaultTextStyle(
  //                 style: TextStyle(
  //                   color: Colors.white, // Set text color
  //                   fontSize: 18.0,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //                 child: Text(
  //                     title
  //                 )
  //               ),
  //             ),
  //           ),
  //         )
  //       );
  // }
  //
  // Widget descriptionSection(String description, imageUrl, var color) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Column(
  //         children: [
  //           Container(
  //               height: MediaQuery.of(context).size.width - 250,
  //               width: MediaQuery.of(context).size.width - 250,
  //               margin: EdgeInsets.all(4.0),
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(8.0),
  //                 image: DecorationImage(
  //                   image: NetworkImage(
  //                       imageUrl),
  //                   fit: BoxFit.cover,
  //                 ),
  //               )
  //           ),
  //         ],
  //       ),
  //       Column(
  //         children: [
  //           Container(
  //               margin: EdgeInsets.all(4.0),
  //               child: ConstrainedBox(
  //               constraints: BoxConstraints(maxWidth: 200),
  //               child: Text(description, maxLines: 10, overflow: TextOverflow.ellipsis,  textDirection: TextDirection.rtl, textAlign: TextAlign.justify, style: TextStyle(fontSize: 15, color: color)))
  //             ),
  //         ],
  //       )
  //     ],
  //   );
  // }
}
