import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sep21/Provider/Cart_Provider.dart';
import 'package:sep21/consts/my_custom_icons/MyAppColors.dart';
import 'package:sep21/consts/my_custom_icons/MyAppIcons.dart';
import '../bottom_bar.dart';
import '../Widgets/cart_empty.dart';
import '../Widgets/cart_full.dart';

class Cart extends StatelessWidget {

  static const routeName = '/cart';


  @override
  Widget build(BuildContext context) {

    Future<void> _showDialogForRemoveItem(String title, String subtitle, VoidCallback  fct) async {
      showDialog(context: context, builder: (BuildContext ctx){
        return AlertDialog(
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 6.0),
                child: Icon(MyAppIcons.warning,size: 24,),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(title ),
              )
            ],
          ),
          content: Text(subtitle),
          actions: [
            TextButton(onPressed: ()=> Navigator.pop(context), child: Text('Cancel')),
            TextButton(onPressed: (){
              fct();
              Navigator.pop(context);
            }, child: Text('OK')),
          ],
        );

      });
    }


    /// ************
    ///  PROVIDERS:
    /// ************
    final cartProvider = Provider.of<CartProvider>(context);


    return cartProvider.getCartItems.isEmpty
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
              title: Text('Cart (${cartProvider.getCartItems.length}) '),
              actions: [
                IconButton(
                  onPressed: () { _showDialogForRemoveItem('Clear Cart', 'Do you want to clear your cart?',
                          ()=> {cartProvider.clearCart() }
                  ); },
                  icon: Icon(MyAppIcons.trash),
                )
              ],
            ),
            body: Container(
              margin: EdgeInsets.only(bottom: 60),
              child: ListView.builder(itemCount:cartProvider.getCartItems.length,
                  itemBuilder: (BuildContext ctx, int index){
                return ChangeNotifierProvider.value(
                value: cartProvider.getCartItems.values.toList()[index]
                ,child: CartFull(
                     matchId:cartProvider.getCartItems.keys.toList()[index] ,
                    // id: cartProvider.getCartItems.values.toList()[index].id,// cast to list cause is of type 'Map'
                    // matchId: cartProvider.getCartItems.keys.toList()[index],
                    // price: cartProvider.getCartItems.values.toList()[index].price,
                    // title: cartProvider.getCartItems.values.toList()[index].title,
                    // imageUrl: cartProvider.getCartItems.values.toList()[index].imageUrl,
                    // quantity: cartProvider.getCartItems.values.toList()[index].quantity,
                    // stadium: cartProvider.getCartItems.values.toList()[index].stadium ,
                  ),
                );
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

