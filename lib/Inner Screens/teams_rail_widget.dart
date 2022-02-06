import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppIcons.dart';
import 'package:sep21/Widgets/feeds_dialog.dart';
import 'package:sep21/consts/my_custom_icons/MyAppColors.dart';
import 'package:sep21/main.dart';
import 'package:sep21/Models/Match.dart';

import 'match_details.dart';

class TeamsNavigationRail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final matchesAttributes = Provider.of<Match>(context);
    int matchQuantity = matchesAttributes.SectorA_RegularQuantity + matchesAttributes.SectorA_StudentQuantity +
        matchesAttributes.SectorB_RegularQuantity + matchesAttributes.SectorB_StudentQuantity +
        matchesAttributes.SectorC_RegularQuantity + matchesAttributes.SectorC_StudentQuantity;

    bool isBefore = DateTime.parse( matchesAttributes.date).isBefore(DateTime.now());

    print ("MATCH ${matchesAttributes.title} is before ${isBefore}");

    return InkWell(
      onTap:  () => Navigator.pushNamed(context, MatchDetails.routeName, arguments: matchesAttributes.id) ,
      child: Padding(
        padding: const EdgeInsets.only(right: 18.0, top: 8.0, bottom: 8.0),
        child: Container(
          width: 250,
          height: 290,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              //color: Theme.of(context).backgroundColor),
              color: Theme.of(context).backgroundColor),
          child: Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: Container(
                        width: double.infinity,
                        height:MediaQuery.of(context).size.height * 0.3,
                        child: Card(
                          color: Colors.black54,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          child: Image.network(matchesAttributes.imageURL,
                              fit: BoxFit.contain),
                        )),
                  ),
                    !isBefore ?  Badge(
                    toAnimate: true,
                    shape: BadgeShape.square,
                    badgeColor: Colors.red,
                    borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(8)),
                    badgeContent:
                    Text('UPCOMING', style: TextStyle(color: Colors.white)),
                  ): Text(''),
                ],
              ),
              Container(
                padding: EdgeInsets.only(left: 5, bottom: 2, right: 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(MyAppIcons.access_time, size: 14,),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(' ${matchesAttributes.title}',
                                overflow: TextOverflow.fade,
                                maxLines: 2,
                                softWrap: false,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900)),

                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(MyAppIcons.date_range, size: 14,),

                        // padding: const EdgeInsets.symmetric(vertical: 8.0),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            //' ${DateFormat("dd-MM-yyyy").format(DateTime.parse(matchesAttributes.date))}' ,//+ matchesAttributes.price.toString(),
                            ' ${Jiffy(matchesAttributes.date).yMMMd}' ,//+ matchesAttributes.price.toString(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w900),

                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(MyAppIcons.location_on, size: 14,),

                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              ' ${matchesAttributes.stadium}' ,//+ matchesAttributes.price.toString(),
                              overflow: TextOverflow.ellipsis,

                              softWrap: false,
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),

                      ],
                    ),
                    Row(
                      children: [
                        Icon(MyAppIcons.data_saver_off, size: 14,),
                        Text(
                          ' ${matchQuantity} tickets left ' ,//+ matchesAttributes.price.toString(),
                          overflow: TextOverflow.ellipsis,

                          softWrap: false,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w900),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                              onTap: () async {

                                showDialog(
                                    context: context,
                                    builder: (BuildContext context)=>FeedDialog(matchId: matchesAttributes.id)
                                );
                              },
                              borderRadius: BorderRadius.circular(18),
                              child:
                              Icon(Icons.more_horiz, color: MyAppColor.gradiendLStart)),
                        )


                      ],
                    ),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
