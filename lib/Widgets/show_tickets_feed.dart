/// The following widget wildget will be called
/// when the user press add to cart and will
///  display the available tickets for each sector

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:sep21/Inner%20Screens/match_details.dart';
import 'package:sep21/Models/CartAttr.dart';
import 'package:sep21/Models/Match.dart';
import 'package:sep21/Provider/Cart_Provider.dart';
import 'package:sep21/Provider/DarkTheme.dart';
import 'package:sep21/consts/my_custom_icons/MyAppColors.dart';
import 'package:sep21/consts/my_custom_icons/MyAppIcons.dart';

import '../Services/Global_methods.dart';

class DisplayTickets extends StatefulWidget {
  //Match matchAttr;
  final _formKey = GlobalKey<FormState>();

  bool _obscureText = true;
  final FocusNode _credentials = FocusNode();
  final FocusNode _fanId = FocusNode();

  GlobalMethods gb = new GlobalMethods();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool _agree = false;
  final Match matchAttr;

   DisplayTickets(this.matchAttr);


  @override
  _DisplayTicketsState createState() => _DisplayTicketsState();
}

enum TicketTypesEnum { regular, student }
enum SectorsEnum { west, east, south }

class _DisplayTicketsState extends State<DisplayTickets> {
  TicketTypesEnum? _ticketType = TicketTypesEnum.regular;
  SectorsEnum? _sector = SectorsEnum.west;

  @override
  Widget build(BuildContext context) {

    final cartProvider = Provider.of<CartProvider>(context);
    //final cartAttr = Provider.of<CartAttr>(context);
    final themeChange = Provider.of<DarkThemeProvider>(context);
    GlobalMethods globalMethods = GlobalMethods();

    bool _value = false;
    int? val = -1;

   // Match match = Provider.of<Match>(context);
    print(widget.matchAttr.title + ' | ' + widget.matchAttr.id);

    String _selectedGender = 'male';
    return  SingleChildScrollView(
      child: Center(
        child: Column(
          children: <Widget>[


            /// ------------------------------------------------------
            ///                   TICKET TYPE !!
            /// ------------------------------------------------------

            Container(

              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5.0),
                    bottomRight: Radius.circular(5.0)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 3.0),
                    child: Text("Specify ticket type:", style: TextStyle(
                      fontSize: 20
                    ),),
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 10,
                  ),
                  ListTile(
                    title: const Text('Regular'),
                    leading: Radio<TicketTypesEnum>(
                      value: TicketTypesEnum.regular,
                      groupValue: _ticketType,
                      onChanged: (TicketTypesEnum? value) {
                        setState(() {
                          _ticketType = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Student'),
                    leading: Radio<TicketTypesEnum>(
                      value: TicketTypesEnum.student,
                      groupValue: _ticketType,
                      onChanged: (TicketTypesEnum? value) {
                        setState(() {
                          _ticketType = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 30,
              child: Divider(
                color: Theme.of(context).disabledColor,
                thickness: 1.0,
              ),
            ),

            /// ------------------------------------------------------
            ///                  SECTOR SELECTION !!
            /// ------------------------------------------------------
            Container(

              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5.0),
                    bottomRight: Radius.circular(5.0)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 3.0),
                    child: Text("Select seating sector:", style: TextStyle(
                        fontSize: 20
                    ),),
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 10,
                  ),
                  ListTile(
                    title: const Text('West'),
                    leading: Radio<SectorsEnum>(
                      value: SectorsEnum.west,
                      groupValue: _sector,
                      onChanged: (SectorsEnum? value) {
                        setState(() {
                          _sector = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('East'),
                    leading: Radio<SectorsEnum>(
                      value: SectorsEnum.east,
                      groupValue: _sector,
                      onChanged: (SectorsEnum? value) {
                        setState(() {
                          _sector = value;
                        });
                      },
                    ),
                  ),

                  ListTile(
                    title: const Text('South'),
                    leading: Radio<SectorsEnum>(
                      value: SectorsEnum.south,
                      groupValue: _sector,
                      onChanged: (SectorsEnum? value) {
                        setState(() {
                          _sector = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 30,
              child: Divider(
                color: Theme.of(context).disabledColor,
                thickness: 1.0,
              ),
            ),

            /// ------------------------------------------------------
            ///                 Availability !!
            /// ------------------------------------------------------
            Container(

              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5.0),
                    bottomRight: Radius.circular(5.0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text("Available Tickets : ", textAlign: TextAlign.left,
                      style: TextStyle(

                        fontSize: 20
                    ),),
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 10,
                  ),

                ],
              ),
            ),



          ],


                    // Form(
                    //   key: widget._formKey,
                    //
                    //   child: Column(
                    //     children: [
                    //
                    //       // Row(
                    //       //   children: [
                    //           ListTile(
                    //             title: Text("Male"),
                    //             leading: Radio(
                    //               value: 1,
                    //               groupValue: val,
                    //               onChanged: (value) {
                    //                 setState(() {
                    //                   val = value as int?;
                    //                 });
                    //               },
                    //               activeColor: Colors.green,
                    //             ),
                    //           ),
                    //           ListTile(
                    //             title: Text("Female"),
                    //             leading: Radio(
                    //               value: 2,
                    //               groupValue: val,
                    //               onChanged: (value) {
                    //                 setState(() {
                    //                   val = value as int?;
                    //                 });
                    //               },
                    //               activeColor: Colors.green,
                    //             ),
                    //           ),
                    //       //   ],
                    //       // ),
                    //
                    //       Container(
                    //           height: 50,
                    //           child: RaisedButton(
                    //               materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    //               shape: RoundedRectangleBorder(side: BorderSide.none),
                    //               color: Colors.redAccent.shade400,
                    //               onPressed: (){
                    //
                    //                 /// create new variable that will represent ticket type and sector..
                    //                 cartProvider.addProductToCart(widget.matchAttr.id,
                    //                     widget.matchAttr.SectorB_RegularPrice, widget.matchAttr.title,
                    //                     widget.matchAttr.imageURL, "Regular", "West");
                    //
                    //               },
                    //               child: Text(
                    //                   'Add to Card'.toUpperCase(),
                    //                   style: TextStyle(
                    //                       fontSize: 16, color: Colors.white
                    //                   )
                    //               )
                    //           )
                    //       ),
                    //
                    //     ],
                    //   ),
                    //
                    // ),






        ),
      ),
    );


  }
}



