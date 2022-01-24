/// The following widget wildget will be called
/// when the user press add to cart and will
///  display the available tickets for each sector

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

class DisplayTickets extends StatefulWidget {
  //Match matchAttr;

  final Match matchAttr;
  const DisplayTickets(this.matchAttr);


  @override
  _DisplayTicketsState createState() => _DisplayTicketsState();
}

class _DisplayTicketsState extends State<DisplayTickets> {

  @override
  Widget build(BuildContext context) {
    final themeChanged = Provider.of<DarkThemeProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    //final cartAttr = Provider.of<CartAttr>(context);




   // Match match = Provider.of<Match>(context);
    print(widget.matchAttr.title + ' | ' + widget.matchAttr.id);
    return Scaffold(
      body: ListView(
        children: [
/// **************************************
///            WEST SECTOR
/// **************************************
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.arrow_drop_down_circle),
                  //title: Text(widget.matchAttr.stadium.west.name.toString()),
                  subtitle: Text(
                    'Available Tickets:' + ( widget.matchAttr.SectorA_StudentQuantity + widget.matchAttr.SectorA_RegularQuantity).toString(),
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(16.0),
                //   child: Text(
                //     'Greyhound divisively hello coldly wonderfully marginally far upon excluding.',
                //     style: TextStyle(color: Colors.black.withOpacity(0.6)),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                    Text(
                    'Regular',
                    style: TextStyle(
                        color: themeChanged.darkTheme
                            ? Colors.brown.shade900
                            : Theme.of(context).accentColor),
                  ),
                  Spacer(),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(4),
                      onTap: () {},
                      child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Icon(Entypo.minus,
                                color: Colors.red, size: 23),
                          )),
                    ),
                  ), Card(
                        elevation: 12,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.12,
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              MyAppColor.gradiendLStart,
                              MyAppColor.blueGrey,
                            ], stops: [
                              0.0,
                              0.7
                            ],),
                          ),
                          // ** BOX TO DISPLAY THE NUMBER OF QUANTITY **
                          child: Text('0',//widget.matchAttr.SectorA_RegularQuantity.toString(),
                            textAlign: TextAlign.center,),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(4),
                          onTap: () {},
                          child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Icon(Entypo.plus,
                                    color: Colors.green, size: 23),
                              )),
                        ),
                      ),

                  ]),),
                  Divider(),
                  Row(
                      children: [
                        Text(
                          'Student',
                          style: TextStyle(
                              color: themeChanged.darkTheme
                                  ? Colors.brown.shade900
                                  : Theme.of(context).accentColor),
                        ),
                        Spacer(),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(4),
                            onTap: () {},
                            child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(Entypo.minus,
                                      color: Colors.red, size: 23),
                                )),
                          ),
                        ), Card(
                          elevation: 12,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.12,
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                MyAppColor.gradiendLStart,
                                MyAppColor.blueGrey,
                              ], stops: [
                                0.0,
                                0.7
                              ],),
                            ),
                            // ** BOX TO DISPLAY THE NUMBER OF QUANTITY **
                            child: Text( '0',//widget.matchAttr.SectorA_StudentQuantity.toString(),
                              //cartAttr.quantity.toString(),
                              textAlign: TextAlign.center,),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(4),
                            onTap: () {},
                            child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(Entypo.plus,
                                      color: Colors.green, size: 23),
                                )),
                          ),
                        ),

                      ]),



                // ButtonBar(
                //   alignment: MainAxisAlignment.start,
                //   children: [
                //     FlatButton(
                //       onPressed: () {
                //         // Perform some action
                //       },
                //       child: const Text('ACTION 1'),
                //     ),
                //     FlatButton(
                //       onPressed: () {
                //         // Perform some action
                //       },
                //       child: const Text('ACTION 2'),
                //     ),
                //   ],
                // ),
                //Image.asset('assets/card-sample-image.jpg'),
              ],
            ),
          ),
          /// **************************************
          ///            SOUTH SECTOR
          /// **************************************
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ListTile(
                  //leading: Icon(Icons.arrow_drop_down_circle),
                  //title: Text(widget.matchAttr.stadium.east.name.toString()),
                  subtitle: Text(
                    'Available Tickets: ' + (widget.matchAttr.SectorB_StudentQuantity + widget.matchAttr.SectorB_RegularQuantity).toString(),
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(16.0),
                //   child: Text(
                //     'Greyhound divisively hello coldly wonderfully marginally far upon excluding.',
                //     style: TextStyle(color: Colors.black.withOpacity(0.6)),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                      children: [
                        Text(
                          'Regular',
                          style: TextStyle(
                              color: themeChanged.darkTheme
                                  ? Colors.brown.shade900
                                  : Theme.of(context).accentColor),
                        ),
                        Spacer(),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(4),
                            onTap: () {},
                            child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(Entypo.minus,
                                      color: Colors.red, size: 23),
                                )),
                          ),
                        ), Card(
                          elevation: 12,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.12,
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                MyAppColor.gradiendLStart,
                                MyAppColor.blueGrey,
                              ], stops: [
                                0.0,
                                0.7
                              ],),
                            ),
                            // ** BOX TO DISPLAY THE NUMBER OF QUANTITY **
                            child: Text('0',//widget.matchAttr.SectorB_RegularQuantity.toString(),
                              textAlign: TextAlign.center,),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(4),
                            onTap: () {},
                            child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(Entypo.plus,
                                      color: Colors.green, size: 23),
                                )),
                          ),
                        ),

                      ]),),
                Divider(),
                Row(
                    children: [
                      Text(
                        'Student',
                        style: TextStyle(
                            color: themeChanged.darkTheme
                                ? Colors.brown.shade900
                                : Theme.of(context).accentColor),
                      ),
                      Spacer(),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(4),
                          onTap: () {},
                          child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Icon(Entypo.minus,
                                    color: Colors.red, size: 23),
                              )),
                        ),
                      ), Card(
                        elevation: 12,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.12,
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              MyAppColor.gradiendLStart,
                              MyAppColor.blueGrey,
                            ], stops: [
                              0.0,
                              0.7
                            ],),
                          ),
                          // ** BOX TO DISPLAY THE NUMBER OF QUANTITY **
                          child: Text('0',//widget.matchAttr.SectorB_StudentQuantity.toString(),
                            textAlign: TextAlign.center,),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(4),
                          onTap: () {},
                          child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Icon(Entypo.plus,
                                    color: Colors.green, size: 23),
                              )),
                        ),
                      ),

                    ],

                ),


              ],
            ),
          ),

      /// **************************************
          ///       SOUTH SECTOR
      /// **************************************
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ListTile(
                  //leading: Icon(Icons.arrow_drop_down_circle),
                  //title: Text(widget.matchAttr.stadium.south.name.toString()),
                  subtitle: Text(
                    'Available Tickets:' + (widget.matchAttr.SectorC_RegularQuantity + widget.matchAttr.SectorC_StudentQuantity).toString(),
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(16.0),
                //   child: Text(
                //     'Greyhound divisively hello coldly wonderfully marginally far upon excluding.',
                //     style: TextStyle(color: Colors.black.withOpacity(0.6)),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                      children: [
                        Text(
                          'Regular',
                          style: TextStyle(
                              color: themeChanged.darkTheme
                                  ? Colors.brown.shade900
                                  : Theme.of(context).accentColor),
                        ),
                        Spacer(),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(4),
                            onTap: () {},
                            child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(Entypo.minus,
                                      color: Colors.red, size: 23),
                                )),
                          ),
                        ),

                        Card(
                          elevation: 12,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.12,
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                MyAppColor.gradiendLStart,
                                MyAppColor.blueGrey,
                              ], stops: [
                                0.0,
                                0.7
                              ],),
                            ),
                            // ** BOX TO DISPLAY THE NUMBER OF QUANTITY **
                            child: Text('0',//widget.matchAttr.SectorC_RegularQuantity.toString(),
                              textAlign: TextAlign.center,),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(4),
                            onTap: () {},
                            child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(Entypo.plus,
                                      color: Colors.green, size: 23),
                                )),
                          ),
                        ),

                      ]),),
                Divider(),
                Row(
                  children: [
                    Text(
                      'Student',
                      style: TextStyle(
                          color: themeChanged.darkTheme
                              ? Colors.brown.shade900
                              : Theme.of(context).accentColor),
                    ),
                    Spacer(),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(4),
                        onTap: () {},
                        child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Icon(Entypo.minus,
                                  color: Colors.red, size: 23),
                            )),
                      ),
                    ), Card(
                      elevation: 12,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.12,
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            MyAppColor.gradiendLStart,
                            MyAppColor.blueGrey,
                          ], stops: [
                            0.0,
                            0.7
                          ],),
                        ),
                        // ** BOX TO DISPLAY THE NUMBER OF QUANTITY **
                        child: Text( '0',//widget.matchAttr.SectorC_RegularQuantity.toString(),
                          textAlign: TextAlign.center,),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(4),
                        onTap: () {},
                        child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Icon(Entypo.plus,
                                  color: Colors.green, size: 23),
                            )),
                      ),
                    ),

                  ],

                ),


              ],
            ),
          ),
          Column(

            children: [
              Container(
                  height: 50,
                  child: RaisedButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(side: BorderSide.none),
                      color: Colors.redAccent.shade400,
                      onPressed: (){
                        //ShowTicketOptions(matcAtrr, context);
                        cartProvider.addProductToCart(widget.matchAttr.id, widget.matchAttr.SectorB_RegularPrice, widget.matchAttr.title, widget.matchAttr.imageURL);
                        cartProvider.addProductToCart(widget.matchAttr.id, widget.matchAttr.SectorA_RegularPrice, widget.matchAttr.title, widget.matchAttr.imageURL);

                        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        //   content: Text("Tickes added to your basket!"),
                        // ));
                      },
                      child: Text(
                          'Add to Card'.toUpperCase(),
                          style: TextStyle(
                              fontSize: 16, color: Colors.white
                          )
                      )
                  )
              ),
            ],
          ),

        ],
      ),

    );
  }
}



