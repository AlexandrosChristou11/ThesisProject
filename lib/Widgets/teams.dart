// The following widget is responsible to
// display all teams on the home screen ..
// 22Oct21 - @Author: Alexandros Christou

// Default from tutorial: CategoriesWidget

import 'package:flutter/cupertino.dart';
import 'package:sep21/Screens/feed.dart';
import 'package:flutter/material.dart';
import 'package:sep21/Inner Screens/categories_feeds.dart';

class TeamsWidget extends StatefulWidget {
  TeamsWidget({Key? key, required this.index}) : super(key: key);
  final int index;

  @override
  State<TeamsWidget> createState() => _TeamsWidgetState();
}

class _TeamsWidgetState extends State<TeamsWidget> {
  List teams = [
    {
      'teamName': 'Anorthosis',
      'category' : 'Football',
      'teamImagePath': 'assets/images/Teams/ano.png',
    },
    {
      'teamName': 'AEK',
      'category' : 'Football',
      'teamImagePath': 'assets/images/Teams/aek.png',
    },
    {
      'teamName': 'AEL',
      'teamImagePath': 'assets/images/Teams/ael.png',
    },
    {
      'teamName': 'APOEL',
      'category' : 'Football',
      'teamImagePath': 'assets/images/Teams/apoel.png',
    },
    {
      'teamName': 'APOLLON',
      'category' : 'Football',
      'teamImagePath': 'assets/images/Teams/apoll.png',
    },
    {
      'teamName': 'DOXA',
      'category' : 'Basketball',
      'teamImagePath': 'assets/images/Teams/3393.png',
    },
    {
      'teamName': 'OLYMPIAKOS NICOSIA',
      'category' : 'Basketball',
      'teamImagePath': 'assets/images/Teams/Olympiakos-Nicosia_LOGO.png',
    },
    {
      'teamName': 'OMONOIA NICOSIA',
      'category' : 'Basketball',
      'teamImagePath': 'assets/images/Teams/omo.png',
    },
    {
      'teamName': 'PAFOS FC',
      'category' : 'Handball',
      'teamImagePath': 'assets/images/Teams/pafos.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: (){
            Navigator.of(context).pushNamed(CategoriesFeedsScreen.routeName, arguments: '${teams[widget.index]['teamName']}');

          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage(teams[widget.index]['teamImagePath']),
                fit: BoxFit.scaleDown
              ),
            ),
            margin: EdgeInsets.symmetric(vertical: 10),
            width: 100,
            height: 100,
          ),
        ),
        // Positioned(
        //   bottom: 0,
        //   left: 10,
        //   right: 10,
        //   child: Container(
        //     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        //     color: Theme.of(context).backgroundColor,
        //     child: Text(
        //       teams[index]['teamName'],
        //       style: TextStyle(
        //           fontWeight: FontWeight.w600,
        //           fontSize: 6,
        //           color: Theme.of(context).textSelectionTheme.selectionColor),
        //     ),
        //   ),
        // )
      ],
    );
  }
}
