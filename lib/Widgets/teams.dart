// The following widget is responsible to
// display all teams on the home screen ..
// 22Oct21 - @Author: Alexandros Christou

// Default from tutorial: CategoriesWidget

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TeamsWidget extends StatelessWidget {
  TeamsWidget({Key? key, required this.index}) : super(key: key);
  final int index;

  // List<Map<String,Object>> teams = [
  List teams = [
    {
      'teamName': 'Anorthosis',
      'teamImagePath': 'assets/images/Teams/ano.png',
    },
    {
      'teamName': 'AEK',
      'teamImagePath': 'assets/images/Teams/aek.png',
    },
    {
      'teamName': 'AEL',
      'teamImagePath': 'assets/images/Teams/ael.png',
    },
    {
      'teamName': 'APOEL',
      'teamImagePath': 'assets/images/Teams/apoel.png',
    },
    {
      'teamName': 'APOLLON',
      'teamImagePath': 'assets/images/Teams/apoll.png',
    },
    {
      'teamName': 'DOXA',
      'teamImagePath': 'assets/images/Teams/3393.png',
    },
    {
      'teamName': 'OLYMPIAKOS NICOSIA',
      'teamImagePath': 'assets/images/Teams/Olympiakos-Nicosia_LOGO.png',
    },
    {
      'teamName': 'OMONOIA NICOSIA',
      'teamImagePath': 'assets/images/Teams/omo.png',
    },
    {
      'teamName': 'PAFOS FC',
      'teamImagePath': 'assets/images/Teams/pafos.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage(teams[index]['teamImagePath']),
              fit: BoxFit.scaleDown
            ),
          ),
          margin: EdgeInsets.symmetric(vertical: 10),
          width: 100,
          height: 100,
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
