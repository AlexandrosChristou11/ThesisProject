/// The following widget wildget will be called
/// when the user press add to cart and will
///  display the available tickets for each sector

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppColors.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppIcons.dart';
import 'package:sep21/Inner%20Screens/match_details.dart';
import 'package:sep21/Models/CartAttr.dart';
import 'package:sep21/Models/Match.dart';
import 'package:sep21/Provider/Cart_Provider.dart';
import 'package:sep21/Provider/DarkTheme.dart';




import '../Services/Global_methods.dart';

class DisplayTickets extends StatefulWidget {
  //Match matchAttr;

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
  final _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    final cartProvider = Provider.of<CartProvider>(context);
    //final cartAttr = Provider.of<CartAttr>(context);
    final themeChange = Provider.of<DarkThemeProvider>(context);
    GlobalMethods globalMethods = GlobalMethods();

    bool _value = false;
    int? val = -1;
    bool _isLoading = false;

    int _availableTickets = 0;
    String _fanId;

    String _selectedGender = 'male';

    final _text = TextEditingController();
    bool _validate = false;
    return  SingleChildScrollView(
      child: Container(
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Text("Available Tickets :  " , textAlign: TextAlign.left,
                            style: TextStyle(

                                fontSize: 20
                            ),),
                        ),
                        Container(

                          decoration: BoxDecoration(
                            color: MyAppColor.starterColor,
                            borderRadius: BorderRadius.circular(9.0),

                        ),
                          child: Padding(
                            padding: const EdgeInsets.all( 5.0),
                            child: Text(
                              _getAvailableTickets(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                              ),),
                          ),
                        ),
                        Divider(
                          color: Colors.grey,
                          height: 10,
                        ),
                      ],
                    )


                  ],
                ),
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
            ///                 PRICE !!
            /// ------------------------------------------------------
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5.0),
                    bottomRight: Radius.circular(5.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Text("Price : " , textAlign: TextAlign.left,
                            style: TextStyle(

                                fontSize: 20
                            ),),
                        ),
                        Container(

                          decoration: BoxDecoration(
                            color: MyAppColor.starterColor,
                            borderRadius: BorderRadius.circular(9.0),

                          ),
                          child: Padding(
                            padding: const EdgeInsets.all( 5.0),
                            child: Text(
                                "€  ${_getPriceByTicket()} ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                              ),),
                          ),
                        ),
                        Divider(
                          color: Colors.grey,
                          height: 10,
                        ),
                      ],
                    )


                  ],
                ),
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
            ///                FANS DETAILS
            /// ------------------------------------------------------

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                          decoration: BoxDecoration(
                          color: Theme.of(context).dividerColor,
                          borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(5.0),
                          bottomRight: Radius.circular(5.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(

                        key: ValueKey('fan id'),
                        //focusNode: _emailFocusNode,
                        validator: (value) {
                          if (value!.isEmpty ) {
                            return 'Please enter a valid Fan Id';
                          } else {
                            return null;
                          }
                        },
                        textInputAction: TextInputAction.next,
                        // onEditingComplete: () => FocusScope.of(context)
                        //     .requestFocus(_passwordFocusNode),

                        /// allows the  user to move directly to the password field.
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          filled: true,
                          prefixIcon: Icon(MyAppIcons.card_membership_sharp),
                          labelText: 'Fan Id',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          fillColor: themeChange.darkTheme
                              ? Theme.of(context).splashColor
                              : Colors.white,
                        ),
                        onSaved: (value) {
                         _fanId = value!;
                        },
                      ),
                    ),
            ),


                    SizedBox(
                      height: 30,
                      child: Divider(
                        color: Theme.of(context).disabledColor,
                        thickness: 1.0,
                      ),
                    ),

                    Container(
                        height: 50,
                        child:
                        ///  Progress bar indicator
                        _isLoading
                            ? CircularProgressIndicator() :
                        RaisedButton(
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(side: BorderSide.none),
                            color: Colors.redAccent.shade400,
                            onPressed: (){

                              bool isValid = _formKey.currentState!.validate();
                              FocusScope.of(context).unfocus();
                              double price = _getPriceByTicket();
                              setState(() {
                                _isLoading = true;
                              });

                              try {
                                /// return true if the form is valid ..

                                if (isValid) {
                                  //_formKey.currentState!.save();

                                  /// create new variable that will represent ticket type and sector..
                                  cartProvider.addProductToCart(
                                      widget.matchAttr.id,
                                      price, widget.matchAttr.title,
                                      widget.matchAttr.imageURL,
                                      _ticketType.toString(),
                                      _sector.toString());

                                  Navigator.canPop(context) ? Navigator.pop(
                                      context) : null;
                                }
                              }catch(e){
                                print("ERROR | $e");
                              }
                              finally{
                                setState(() {
                                  _isLoading = false;

                                });
                              }


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

              ),





          ],







        ),
      ),
    );


  }

  String _getAvailableTickets() {

    if (this._ticketType == TicketTypesEnum.regular){
      if (this._sector == SectorsEnum.west){
        return widget.matchAttr.SectorA_RegularQuantity.toString();
      }
      else if (this._sector == SectorsEnum.east){
        return widget.matchAttr.SectorB_RegularQuantity.toString();
      }
      else{
        return widget.matchAttr.SectorC_RegularQuantity.toString();
      }
    }
    else{
      if (this._sector == SectorsEnum.west){
        return widget.matchAttr.SectorA_StudentQuantity.toString();
      }
      else if (this._sector == SectorsEnum.east){
        return widget.matchAttr.SectorB_StudentQuantity.toString();
      }
      else{
        return widget.matchAttr.SectorC_StudentQuantity.toString();
      }

    }

    return "";
  }
  double _getPriceByTicket() {

    if (this._ticketType == TicketTypesEnum.regular){
      if (this._sector == SectorsEnum.west){
        return widget.matchAttr.SectorA_RegularPrice;
      }
      else if (this._sector == SectorsEnum.east){
        return widget.matchAttr.SectorB_RegularPrice;
      }
      else{
        return widget.matchAttr.SectorC_RegularPrice;
      }
    }
    else{
      if (this._sector == SectorsEnum.west){
        return widget.matchAttr.SectorA_StudentPrice;
      }
      else if (this._sector == SectorsEnum.east){
        return widget.matchAttr.SectorB_StudentPrice;
      }
      else{
        return  widget.matchAttr.SectorB_StudentPrice;
      }

    }


  }

}



