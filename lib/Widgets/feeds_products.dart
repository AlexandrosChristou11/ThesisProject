import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppColors.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppIcons.dart';
import 'package:sep21/Inner%20Screens/match_details.dart';
import 'package:sep21/Models/Match.dart';
import 'package:sep21/Widgets/feeds_dialog.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

class FeedProducts extends StatefulWidget {



  @override
  _FeedProductsState createState() => _FeedProductsState();
}

class _FeedProductsState extends State<FeedProducts> {
  IconData _getSportIcon(String type){
    if (type.toLowerCase() == 'football'){
      return MyAppIcons.sports_soccer;
    }else if (type.toLowerCase() == 'basketball'){
      return MyAppIcons.sports_basketball_rounded;
    }else if (type.toLowerCase() == 'handball'){
      return MyAppIcons.sports_handball_rounded;
    }
    else if (type.toLowerCase() == 'volley'){
      return MyAppIcons.sports_volleyball_rounded;
    }

    return MyAppIcons.sports_soccer;
  }

  @override
  Widget build(BuildContext context) {
    final matchesAttributes = Provider.of<Match>(context);
    int matchQuantity = matchesAttributes.SectorA_RegularQuantity + matchesAttributes.SectorA_StudentQuantity +
                  matchesAttributes.SectorB_RegularQuantity + matchesAttributes.SectorB_StudentQuantity +
                  matchesAttributes.SectorC_RegularQuantity + matchesAttributes.SectorC_StudentQuantity;

    bool isBefore = DateTime.parse( matchesAttributes.date).isBefore(DateTime.now());
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, MatchDetails.routeName, arguments: matchesAttributes.id),
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
                          child: CachedNetworkImage(
                              imageUrl: matchesAttributes.imageURL,
                              fit: BoxFit.contain,
                            placeholder: (context, url) => new CircularProgressIndicator( backgroundColor: Colors.amberAccent,strokeWidth: 8.0),
                            errorWidget: (context, url, error) => new Icon(Icons.error),
                          ),
                        )),
                  ),
                  !isBefore ? Badge(
                    toAnimate: true,
                    shape: BadgeShape.square,
                    badgeColor: Colors.red,
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(8)),
                    badgeContent:
                        Text('UPCOMING', style: TextStyle(color: Colors.white)),
                  ) :Text(''),
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
                        Icon(_getSportIcon(matchesAttributes.sport), size: 14,),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                              child: Text(' ${matchesAttributes.title}',
                                  overflow: TextOverflow.fade,
                                  maxLines: 2,
                                  softWrap: false,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
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
