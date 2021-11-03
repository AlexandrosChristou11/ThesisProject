/// @author: Alexandros Christou
/// 03Nov21

import 'package:flutter/cupertino.dart';
import 'package:sep21/Models/CartAttr.dart';

class CartProvider with ChangeNotifier{

  Map<String, CartAttr> _cartItems = {};

  Map<String,CartAttr> get getCartItems{
    return this._cartItems;
  }

  double get totalAmount{
    var total = 0.0;
    _cartItems.forEach((key, value) {total += value.price * value.quantity;});
    return total;
  }

  void addProductToCart(String matchID, double price, String title, String imageURL){
    if (_cartItems.containsKey(matchID)){
      _cartItems.update(matchID, (existingCart) => CartAttr(
        id: existingCart.id,
        title: existingCart.title,
        quantity: existingCart.quantity + 1,
        price: existingCart.price,
        imageUrl: existingCart.imageUrl
      ));
    }else{
      _cartItems.putIfAbsent(matchID, () => CartAttr(
          id: DateTime.now().toString(),
          title: title,
          quantity:  1,
          price: price,
          imageUrl: imageURL
      ));

    }
    notifyListeners();
  }


}