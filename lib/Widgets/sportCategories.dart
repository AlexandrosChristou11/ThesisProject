// The following widget is responsible to
// display all teams on the home screen ..
// 22Oct21 - @Author: Alexandros Christou

// Default from tutorial: CategoriesWidget

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppIcons.dart';
import 'package:sep21/Provider/DarkTheme.dart';
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
      'sportName': 'Football',
      'category' : 'Football',
      'teamImagePath': 'assets/images/Sports/ba.jpg',
      'icon' : MyAppIcons.sports_soccer
    },
    {
      'sportName': 'Basketball',
      'category' : 'Basketball',
      'teamImagePath': 'assets/images/Sports/bask.png',
      'icon' : MyAppIcons.sports_basketball_rounded
    },
    {
      'sportName': 'Handball',
      'teamImagePath': 'assets/images/Sports/download.png',
      'icon' : MyAppIcons.sports_handball_rounded
    },
    {
      'sportName': 'Volleyball',
      'category' : 'Volleyball',
      'teamImagePath': 'assets/images/Sports/vol.jpg',
      'icon' : MyAppIcons.sports_volleyball_rounded
    },

  ];



  @override
  Widget build(BuildContext context) {
    /// --------------
    ///   PROVIDERS:
    /// --------------
    final darkTheme = Provider.of<DarkThemeProvider>(context);
    return Stack(
      children: [
        InkWell(
          onTap: (){

            Navigator.of(context).pushNamed(CategoriesFeedsScreen.routeName, arguments: '${teams[widget.index]['sportName']}');

          },

              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: darkTheme.darkTheme ? Colors.white24 : Colors.black54
                  ),
                  //borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).bottomAppBarColor,
                  // image: DecorationImage(
                  //   image: AssetImage(teams[widget.index]['teamImagePath']),
                  //   fit: BoxFit.scaleDown
                  // ),
                ),
               // margin: EdgeInsets.symmetric(vertical: 4),
                margin: EdgeInsets.symmetric(vertical: 1.0),
                width: 100,
                height: 100,
                child: Icon((teams[widget.index]['icon']), size: 50,),

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
