
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppColors.dart';
import 'package:sep21/Screens/Card/cart.dart';
import 'package:sep21/Screens/feed.dart';
import 'package:sep21/Screens/home.dart';
import 'package:sep21/Screens/search.dart';
import 'package:sep21/Screens/userInfo.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../Consts/my_custom_icons/MyAppIcons.dart';


class BottomBarScreen extends StatefulWidget{

  static const routeName = '/BottomBarScreen';

  @override
    // TODO: implement createState
  _BottomBarScreenState createState()=> _BottomBarScreenState();


}

class _BottomBarScreenState extends State<BottomBarScreen>{

  // List _pages = [
  //   Home(),
  //   Feed(),
  //   Search(),
  //   Cart(),
  //   UserInfo()
  // ];

  //late List <Map<String, dynamic>> _pages;
  var _pages;


  int _selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    _pages =
    [
      {
        "page": Home(),
        "title" : 'Home Screen'
      },
      {
        "page": Feed(),
        "title" : 'Feeds Screen'
      },
      {
        "page": Search(),
        "title" : 'Search Screen'
      },
      {
        "page": Cart(),
        "title" : 'Cart Screen'
      },
      {
        "page": UserInfo(),
        "title" : 'User Screen'
      }
    ];
    super.initState();
  }

  void _selectedPage(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      // appBar: AppBar(centerTitle: true,
      // title: Text(_pages[_selectedIndex]['title']),)
      body: _pages[_selectedIndex]['page'],
      bottomNavigationBar: BottomAppBar(
      notchMargin: 3,
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      shape: CircularNotchedRectangle(),
      child: Container(
        decoration: BoxDecoration(border: Border (top:BorderSide(width: 0.5))),
        //height: kBottomNavigationBarHeight*0.98,
        child: BottomNavigationBar(
          onTap: _selectedPage,
        backgroundColor: Theme.of(context).primaryColor,
          unselectedItemColor: Theme.of(context).accentColor,
          selectedItemColor: Colors.blue[100],
          selectedLabelStyle: TextStyle(fontSize: 15),
          currentIndex: _selectedIndex,
          items:
          [
            // (1) Home
            BottomNavigationBarItem(icon: Icon(MyAppIcons.home), tooltip: 'Home', label: 'Home'),
            // (2) Feed
            BottomNavigationBarItem(icon: Icon(MyAppIcons.ballot), tooltip: 'Games', label: 'Games'),
            // (3) Search
            BottomNavigationBarItem(activeIcon:null , icon: Icon(null), tooltip: 'Search', label: 'Search'),
            // (4) Cart
            BottomNavigationBarItem(icon: Icon(MyAppIcons.shopping_basket_outlined), tooltip: 'Cart', label: 'Cart'),
            // (5) User
            BottomNavigationBarItem(icon: Icon(MyAppIcons.user), tooltip: 'User', label: 'Account'),
          ]
        ),
      ),
    ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: FloatingActionButton(
            backgroundColor: Colors.blue,
            hoverElevation: 10,
            splashColor: Colors.grey,
            tooltip: 'Search',
            elevation: 4,
            child: (Icon(MyAppIcons.search)),
            onPressed: (){
              setState(() {
                _selectedIndex = 2; //
              });
            },
          ),
        ),
      ),
    );
  }


}




