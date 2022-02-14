/// Alexandros Christou - 09Feb21
/// Implementation Match Preview screen
/// In the current screen, the admin users will preview
/// the match details before uploading it!


import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppColors.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppIcons.dart';
import 'package:sep21/Models/MatchPreview.dart';
import 'package:sep21/Provider/DarkTheme.dart';
import 'package:sep21/Screens/home.dart';
import 'package:sep21/Screens/uploadNewMatch.dart';
import 'package:sep21/Services/Global_methods.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:icon_picker/icon_picker.dart';
import 'package:date_format/date_format.dart';
import 'package:sep21/Services/push_notification.dart';
import 'package:uuid/uuid.dart';

import 'feed.dart';

class MatchPreviewScreen extends StatefulWidget {

  static const routeName = '/MatchPreviewScreen';


  @override
  State<MatchPreviewScreen> createState() => _MatchPreviewScreenState();
}

class _MatchPreviewScreenState extends State<MatchPreviewScreen> {
  //const MatchPreview({Key? key}) : super(key: key);
  bool _isLoading = false;
  GlobalMethods gb = new GlobalMethods();
  var _uuid = Uuid();
  late String _url;
  FirebaseAuth _auth = FirebaseAuth.instance;

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

  Future<void> _trySubmit(MatchPreview newMatch) async{

      try{

          setState(() {
            _isLoading = true;
          });

          final matchId = _uuid.v4(); /// setting a unique id for each match
          final reference = FirebaseStorage.instance.ref('MatchImages').child(matchId + ".jpg");
          await reference.putFile(newMatch.PickedImage!);
          _url = await reference.getDownloadURL();

          final User? user = _auth.currentUser;
          final userId = user!.uid;




        var result =  await FirebaseFirestore.instance.collection('Matches').doc(matchId).set({
            'MatchId' : matchId,
            'MatchTitle': newMatch.HomeTeam + " vs " + newMatch.AwayTeam,
            'UserId': userId,
            'CreatedAt': Timestamp.now(),
            'Sport' : newMatch.SportType,
            'Competition': newMatch.MatchType,
            'HomeTeam' : newMatch.HomeTeam,
            'AwayTeam' : newMatch.AwayTeam,
            'DateAndTime': new DateTime(newMatch.Date.year, newMatch.Date.month, newMatch.Date.day, newMatch.Time.hour, newMatch.Time.minute).toString(),
            'Location' : newMatch.Location,
            'Sector A Student Ticket Quantity' : newMatch.SectorAStudentQuantity,
            'Sector A Student Ticket Price' :  newMatch.SectorAStudentPrice,
            'Sector A Regular Ticket Quantity' :  newMatch.SectorARegularQuantity,
            'Sector A Regular Ticket Price' : newMatch.SectorARegularPrice,
            'Sector B Student Ticket Quantity' : newMatch.SectorBStudentQuantity,
            'Sector B Student Ticket Price' : newMatch.SectorBStudentPrice,
            'Sector B Regular Ticket Quantity' : newMatch.SectorBRegularQuantity,
            'Sector B Regular Ticket Price' : newMatch.SectorBRegularPrice,
            'Sector C Student Ticket Quantity' : newMatch.SectorCStudentQuantity,
            'Sector C Student Ticket Price' : newMatch.SectorCStudentPrice,
            'Sector C Regular Ticket Quantity' : newMatch.SectorCRegularQuantity,
            'Sector C Regular Ticket Price' : newMatch.SectorCRegularPrice,
            'Image' : _url

          });
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Match is now available!')));
          //Navigator.pushNamed(context, Feed.routeName);
          PushNotification.sendPushNotification(newMatch.HomeTeam + " vs " + newMatch.AwayTeam);
          Navigator.canPop(context) ? Navigator.pop(context) : null;

        }



        catch(e){

        gb.authenticationErrorHandler(e.toString(), context);
        print('error occurred : ' + e.toString());
      }finally{
        setState(() {
          _isLoading = false;
        });
      }

    }

  @override
  Widget build(BuildContext context) {

    var isDark = Provider.of<DarkThemeProvider>(context);
    var _details = ModalRoute
        .of(context)!
        .settings
        .arguments as MatchPreview;


    return Scaffold(

      appBar: AppBar(
        //leading: Icon(My),
        title: Text('Preview new match'),
      ),
      bottomSheet: Container(

        height: kBottomNavigationBarHeight * 0.8,
        width: double.infinity,
        decoration: BoxDecoration(
          color: MyAppColor.white,
          border: Border(
            top: BorderSide(color: Colors.grey, width: 0.5),
          ),
        ),
        child: Material(
          color: Theme
              .of(context)
              .backgroundColor,
          child: InkWell(
            onTap: ()=>_trySubmit(_details),
            splashColor: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 2),
                  child: _isLoading ? Center(
                      child:
                      Container(
                          height: 40, width: 40
                          , child: CircularProgressIndicator())) : Text(
                    'Publish match',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                GradientIcon(
                  Feather.upload,
                  20,
                  LinearGradient(
                    colors: <Color>[
                      Colors.green,
                      Colors.yellow,
                      Colors.deepOrange,
                      Colors.orange,
                      Colors.yellow.shade800
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [



              /// ---- MATCH DETAILS --
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Container(

                  decoration: BoxDecoration(
                    color: Theme
                        .of(context)
                        .splashColor,
                    border: Border.all(
                      color: Colors.amber, width: 0.5,
                    ),
                  ),
                  child: Column(
                    children: [


                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            //  flex: 2,
                            _details.PickedImage == null
                                ? Container(
                              margin: EdgeInsets.all(10),
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                border: Border.all(width: 1),
                                borderRadius: BorderRadius.circular(4),
                                color: Theme.of(context).backgroundColor,
                              ),
                            )
                                : Container(
                              margin: EdgeInsets.all(10),
                              height: 200,
                              width: 200,
                              child: Container(
                                height: 200,
                                // width: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                  color:
                                  Theme.of(context).backgroundColor,
                                ),
                                child: Image.file(
                                  _details.PickedImage!,
                                  fit: BoxFit.contain,
                                  alignment: Alignment.center,
                                ),
                              ),
                            ),

                        ],
                      ),
                      SizedBox(height: 20,),
                      Divider(),
                      userTitle('MATCH DETAILS'),
                      Divider(),
                      /// ------------------------------------------------------
                      ///                    SPORT TYPE
                      /// ------------------------------------------------------
                      _detailsWidget(_details.SportType, context, _getSportIcon(_details.SportType)),
                      _detailsWidget(_details.MatchType, context, MyAppIcons.ballot),
                      _detailsWidget(_details.HomeTeam, context, Feather.home),
                      _detailsWidget(_details.AwayTeam, context, Feather.shuffle),
                      _detailsWidget(_details.Location, context, MyAppIcons.location_on),
                      _detailsWidget( Jiffy(_details.Date.toString()).yMMMd, context, MyAppIcons.date_range),
                      _detailsWidget(_details.Time.format(context), context, MyAppIcons.access_time),
                      SizedBox(
                        height: 25,
                      ),
                      Divider(),
                      /// ---- TICKETS DETAILS --
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: userTitle('TICKETS DETAILS'),
                      ),

                      _ticketsInformationWidget("SOUTH",_details.SectorAStudentPrice, _details.SectorAStudentQuantity, _details.SectorARegularPrice, _details.SectorARegularQuantity),
                      _ticketsInformationWidget( "EAST",_details.SectorBStudentPrice, _details.SectorBStudentQuantity, _details.SectorBRegularPrice, _details.SectorBRegularQuantity),
                      _ticketsInformationWidget("WEST",_details.SectorCStudentPrice, _details.SectorCStudentQuantity, _details.SectorCRegularPrice, _details.SectorCRegularQuantity),


                      SizedBox(
                        height: 35,
                      ),




                    ],
                  ),


                ),
              ),





            ],
          ),

        ),
      ),

    );
  }

  _ticketsInformationWidget(String sector ,String studentPrice, String studentQuantity, String regularPrice, String regularQuantity  ){
    return Container(
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor ,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5.0),
            bottomRight: Radius.circular(5.0)),

      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(


            children:[
              Padding(
                padding: const EdgeInsets.only(left: 13.0),
                child: userTitle('SECTOR: ${sector}'),
              ),
              Row(
                //crossAxisAlignment: CrossAxisAlignment.end,
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('REGULAR', style: TextStyle(fontSize: 15),),
                  ),
                  Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 9),
                        child: TextFormField(
                          initialValue: regularPrice,
                          enabled: false,
                          decoration: InputDecoration(
                            labelText: 'Price €',
                          ),
                        ),
                      )),
                  Flexible(
                      flex: 1,
                      child:Padding(
                        padding: const EdgeInsets.only(right: 9),
                        child: TextFormField(
                          initialValue: regularQuantity,
                          enabled: false,
                          key: ValueKey(regularQuantity),
                          decoration: InputDecoration(
                            labelText: 'Quantity',
                          ),
                        ),
                      ))

                ],
              ),
              /// ---------- STUDENT --------------
              Row(
                //crossAxisAlignment: CrossAxisAlignment.end,
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('STUDENT', style: TextStyle(fontSize: 15),),
                  ),
                  Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 9),
                        child: TextFormField(
                          enabled: false,
                          key: ValueKey('Price'),
                          initialValue: studentPrice,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Price €',
                          ),
                        ),
                      ))
                  ,Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 9),
                        child: TextFormField(
                          enabled: false,
                          key: ValueKey('Quantity'),
                          initialValue: studentQuantity,
                          decoration: InputDecoration(
                            labelText: 'Quantity',
                          ),
                        ),
                      ))
                ],
              ),
            ]
        ),
      ),
    );

  }

  _detailsWidget(String title, BuildContext context, IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        //color:  Colors.grey.shade100,
        child: InkWell(
          splashColor: Theme
              .of(context)
              .splashColor,
          child: ListTile(title: Text(title),
            //railing: Icon(Icons.chevron_right_rounded),
            //onTap: ()=> Navigator.of(context).pushNamed(Wishlist.routeName),
            leading: Icon(icon, color: MyAppColor.gradiendLStart,),
          ),
        ),
      ),
    );
  }
}



