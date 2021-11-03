import 'package:backdrop/app_bar.dart';
import 'package:backdrop/button.dart';
import 'package:backdrop/scaffold.dart';
import 'package:backdrop/sub_header.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:sep21/Inner%20Screens/team_navigation_rail.dart';
import 'package:sep21/Provider/Matches.dart';
import 'package:sep21/Widgets/backlayer.dart';
import 'package:sep21/Widgets/popular_matches.dart';
import 'package:sep21/Widgets/teams.dart';
import 'package:sep21/consts/my_custom_icons/MyAppColors.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _carouselImages = [
    'assets/images/pap.png',
    'assets/images/gsp.jpg',
    'assets/images/arena.jpg'
  ];
  List _sportImages = [
    'assets/images/Sports/vol.jpg',
    'assets/images/Sports/download.png',
    'assets/images/Sports/bask.png',
    'assets/images/Sports/ba.jpg'
  ];

  List _ClubsLogosImages =[
    'assets/images/Teams/ano.png',
    'assets/images/Teams/aek.png',
    'assets/images/Teams/ael.png',
    'assets/images/Teams/apoel.png',
    'assets/images/Teams/omo.png'
  ];

  @override
  Widget build(BuildContext context) {
    final matchesData = Provider.of<Matches>(context);
    final popularMatches = matchesData.PopularMatches;

    return  Scaffold(
        body: BackdropScaffold(
            frontLayerBackgroundColor:
                Theme.of(context).scaffoldBackgroundColor,
            headerHeight: MediaQuery.of(context).size.height * 0.25,
            appBar: BackdropAppBar(
              title: Text("Home"),
              leading: BackdropToggleButton(
                icon: AnimatedIcons.home_menu,
              ),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  MyAppColor.starterColor,
                  MyAppColor.endColor
                ])),
              ),
              actions: <Widget>[
                IconButton(
                  iconSize: 15,
                  icon: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 13,
                      backgroundImage: NetworkImage(
                          'https://cdn1.vectorstock.com/i/thumb-large/62/60/default-avatar-photo-placeholder-profile-image-vector-21666260.jpg'),
                    ),
                  ),
                  padding: const EdgeInsets.all(10),
                  onPressed: () {},
                )
              ],
            ),
            backLayer: BackLayerMenu(),

            frontLayer: SingleChildScrollView(

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // club selection text on the left
                children: [
                  Container(
                    child: SizedBox(
                      height: 190.0,
                      width: double.infinity,
                      child: Carousel(
                        boxFit: BoxFit.fill,
                        autoplay: true,
                        animationCurve: Curves.fastOutSlowIn,
                        animationDuration: Duration(milliseconds: 1000),
                        dotSize: 5.0,
                        dotIncreasedColor: Colors.blue,
                        dotBgColor: Colors.black.withOpacity(0.2),
                        dotPosition: DotPosition.bottomCenter,
                        //dotVerticalPadding: 10.0,
                        showIndicator: true,
                        indicatorBgPadding: 5.0,
                        images: [
                          ExactAssetImage(_carouselImages[0]),
                          ExactAssetImage(_carouselImages[1]),
                          ExactAssetImage(_carouselImages[2])
                        ],
                      ),
                    ),
                  ),

                  /// ***************************************************
                  ///                 CLUB SELECTION
                  /// ***************************************************
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Select Club:",
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                    ),
                  ),
                  Container(
                    width: double.infinity, height: 180,
                    child: ListView.builder(
                        itemCount: 9,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext ctx,
                      int index){
                          return TeamsWidget(index:index);
                      }, )
                  ),

                  /// ***************************************************
                  ///               SPORT TYPE (CATEGORY) SELECTION
                  /// ***************************************************
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          "Select your match:",
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 20),
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: Text("View all ..",
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                  color: Colors.red)),
                        )
                      ],
                    ),
                  ),


                  Container(
                      height: 180,
                     width: MediaQuery.of(context).size.width * 0.95,
                      child: Swiper(
                        itemCount: _sportImages.length,
                        autoplay: true,
                        onTap: (index) {},
                        itemBuilder: (BuildContext context, int index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                                color: Colors.blueGrey,
                                child: Image.asset(_sportImages[index],
                                    fit: BoxFit.fill)),
                          );
                        },
                      )),

                  /// ***************************************************
                  ///                 POPULAR TEAMS
                  /// ***************************************************
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          'Popular Clubs',
                          style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              TeamsNavigationRailScreen.routeName,
                              arguments: {
                                5,
                              },
                            );
                          },
                          child: Text(
                            'View all...',
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                                color: Colors.red),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 210,
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: Swiper(
                      itemCount: _ClubsLogosImages.length,
                      autoplay: true,
                      viewportFraction: 0.8,
                      scale: 0.9,
                      onTap: (index) {
                        Navigator.of(context).pushNamed(
                          TeamsNavigationRailScreen.routeName,
                          arguments: {
                            index,
                          },
                        );
                      },
                      itemBuilder: (BuildContext ctx, int index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            color: Colors.blueGrey,
                            child: Image.asset(
                              _ClubsLogosImages[index],
                              fit: BoxFit.fill,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  /// ***************************************************
                  ///                POPULAR MATCHES
                  /// ***************************************************
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          "Popular Matches",
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 20),
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: Text("View all ..",
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                  color: Colors.red)),
                        )
                      ],
                    ),
                  ),

                  Container(
                    width: double.infinity,
                    height: 285,
                    margin: EdgeInsets.symmetric(horizontal: 3),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: popularMatches.length,
                      itemBuilder: (BuildContext ctx, int index){
                        return ChangeNotifierProvider.value(
                          value: popularMatches[index],
                          child: PopularMatches(
                            // imageURL:popularMatches[index].imageURL,
                            // title: popularMatches[index].homeTeam + " vs " + popularMatches[index].AwayTeam,
                            // type: popularMatches[index].type,
                            // stadium: popularMatches[index].stadium,

                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            )));
  }
}
