import 'package:flutter/material.dart';

// ignore: camel_case_types
class uiDesign extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      //App bar
      // appBar: SharingPaymentRequestAppBar(context, SharingPaymentPage()),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: uiDesignPage(),
      ),
    ));
  }
}

// ignore: camel_case_types
class uiDesignPage extends StatefulWidget {
  @override
  _uiDesignState createState() => _uiDesignState();
}

// ignore: camel_case_types
class _uiDesignState extends State<uiDesignPage> {
  get padding => null;
  List<Map> petDetails = [
    {
      'name': 'Tom',
      'foods': 'Banana',
      'skills': 'jump over a block',
    },
    {
      'name': 'Annie',
      'foods': 'Blueberries',
      'skills': 'dance',
    },
    {
      'name': 'Heidi',
      'foods': 'Cantaloupe',
      'skills': 'walk only with 2 legs',
    },
    {
      'name': 'Hugo',
      'foods': 'Mango',
      'skills': 'lying for a long time',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            // image: NetworkImage("https://images.unsplash.com/photo-1579202673506-ca3ce28943ef"),
            image: AssetImage('assets/images/iPhoneBgI.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        // color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
              // color: Color(0xff54c3c2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Pet Version",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    // decoration: BoxDecoration(
                    //   shape: BoxShape.circle,
                    //   border: Border.all(),
                    // ),
                    child: IconButton(
                        onPressed: () {
                          print('Hello');
                        },
                        icon: Icon(
                          Icons.groups_rounded,
                          size: 40,
                          color: Colors.white,
                        )),
                  )
                ],
              ),
            ),

            Expanded(
              child: Container(
                color: Colors.black12,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  // padding: EdgeInsets.fromLTRB(0, 80, 0, 80),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (int i = 1; i < 5; i++)
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          height: MediaQuery.of(context).size.height * 0.18,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.transparent),
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  // color: Colors.green,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.fromLTRB(5, 0, 10, 0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(color: Colors.white),
                                          borderRadius: BorderRadius.all(Radius.circular(30)),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                          child: Image.asset(
                                            'assets/images/pet$i.jpeg',
                                            width: 150.0,
                                            height: 120.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                          // color: Colors.blue,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                // color: Colors.yellow,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Name: ' + petDetails[i - 1]['name'].toString(),
                                                      overflow: TextOverflow.visible,
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        color: Color(0xffff0489),
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Favourite Food: ' + petDetails[i - 1]['foods'].toString(),
                                                      overflow: TextOverflow.visible,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Color(0xffff0489),
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Skills: ' + petDetails[i - 1]['skills'].toString(),
                                                      overflow: TextOverflow.visible,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Color(0xffff0489),
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        print('Hello');
                                                      },
                                                      icon: Icon(
                                                        Icons.favorite_outline_outlined,
                                                        size: 34,
                                                      )),
                                                  IconButton(
                                                      onPressed: () {
                                                        print('Hello');
                                                      },
                                                      icon: Icon(
                                                        Icons.chat_bubble_outline_outlined,
                                                        size: 34,
                                                      )),
                                                  IconButton(
                                                      onPressed: () {
                                                        print('Hello');
                                                      },
                                                      icon: Icon(
                                                        Icons.control_point_outlined,
                                                        size: 34,
                                                      )),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              ),
            )

            // Expanded(
            //   child: Container(
            //     // color: Colors.yellow,
            //     width: MediaQuery.of(context).size.width,
            //     child: Container(
            //       padding: EdgeInsets.fromLTRB(0, 80, 0, 80),
            //       child: Column(
            //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //         children: [
            //           Container(
            //             padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
            //             height: MediaQuery.of(context).size.height * 0.2,
            //             width: MediaQuery.of(context).size.width * 0.8,
            //             decoration: BoxDecoration(
            //               color: Colors.white,
            //               border: Border.all(color: Colors.transparent),
            //               borderRadius: BorderRadius.all(Radius.circular(30)),
            //             ),
            //             child: TextButton(
            //                 onPressed: () {},
            //                 child: Row(
            //                   mainAxisAlignment: MainAxisAlignment.center,
            //                   children: [
            //                     Container(
            //                       padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
            //                       child: Text(
            //                         'Pet Health',
            //                         style: TextStyle(
            //                           color: Color(0xffff0489),
            //                           fontSize: 35,
            //                           fontWeight: FontWeight.bold,
            //                         ),
            //                       ),
            //                     ),
            //                     Icon(
            //                       Icons.favorite,
            //                       size: 40,
            //                       color: Colors.red,
            //                     ),
            //                   ],
            //                 )),
            //           ),
            //           Container(
            //             padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
            //             height: MediaQuery.of(context).size.height * 0.2,
            //             width: MediaQuery.of(context).size.width * 0.8,
            //             decoration: BoxDecoration(
            //               color: Colors.white,
            //               border: Border.all(color: Colors.transparent),
            //               borderRadius: BorderRadius.all(Radius.circular(30)),
            //             ),
            //             child: TextButton(
            //                 onPressed: () {},
            //                 child: Row(
            //                   mainAxisAlignment: MainAxisAlignment.center,
            //                   children: [
            //                     Container(
            //                       padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
            //                       child: Text(
            //                         'Pet Party',
            //                         style: TextStyle(
            //                           color: Color(0xffff0489),
            //                           fontSize: 35,
            //                           fontWeight: FontWeight.bold,
            //                         ),
            //                       ),
            //                     ),
            //                     Icon(
            //                       Icons.pets,
            //                       size: 40,
            //                       color: Colors.brown,
            //                     ),
            //                   ],
            //                 )),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // )

            //
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(uiDesign());
}
