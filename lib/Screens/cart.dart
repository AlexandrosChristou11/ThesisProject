import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sep21/consts/my_custom_icons/MyAppColors.dart';
import 'package:sep21/consts/my_custom_icons/MyAppIcons.dart';
import '../bottom_bar.dart';
import '../Widgets/cart_empty.dart';
import '../Widgets/cart_full.dart';

class Cart extends StatelessWidget {

  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    List products = [];
    return !products.isEmpty
    // (a) In case that 'Cart' is empty (No tickets selected)
    // -> then appear a different screen !
        ? Scaffold(
            body: CartEmpty(),
          )

    // (b) in case that 'Cart' is not empty (Tickets are selected)
    // -> then show 'Basket'
        : Scaffold(
            bottomSheet: checkoutSection(context),
            appBar: AppBar(
              title: Text('Number of Tickets'),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(MyAppIcons.trash),
                )
              ],
            ),
            body: Container(
              margin: EdgeInsets.only(bottom: 60),
              child: ListView.builder(itemCount:5 ,
                  itemBuilder: (BuildContext ctx, int index){
                return CartFull();
                  }

              ),
            ));
    }
  }

  Widget checkoutSection(BuildContext ctx) {
    return Container(

      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 0.5))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  gradient: LinearGradient(colors: [
                    MyAppColor.gradiendLStart,
                    MyAppColor.blueGrey,
                  ], stops: [
                    0.0,
                    0.7
                  ],),
                ),
                child: Material(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.transparent ,
                    child: InkWell(
                        borderRadius: BorderRadius.circular(30.0),
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Checkout',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Theme.of(ctx).textSelectionColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600)),
                        ))),
              ),
            ),
            Spacer(),
            Text('Total',
                style: TextStyle(
                    color: Theme.of(ctx).textSelectionColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600)),
            Text('120\$',
               // textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

