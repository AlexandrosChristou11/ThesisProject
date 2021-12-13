// @Author: Alexandros Christou
// Date: 05Dec21
/// @author: Alexandros Christou
/// 03Nov21

import 'package:flutter/cupertino.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sep21/Models/FavoritesAttr.dart';
import 'package:sep21/Models/Sector.dart';
import 'package:sep21/Models/Stadium.dart';

class FavoritesProvider with ChangeNotifier{

  Map<String, FavoritestAttr> _FavoriteItems = {};

  Map<String,FavoritestAttr> get getFavoriteItems{
    return _FavoriteItems;
  }

  void AddAndRemoveFromFavorite(String matchID, double price, String title, String imageURL){
    if (_FavoriteItems.containsKey(matchID)){

      removeItem(matchID);
      
    }else{
      /// Add item for first time in the wishlist
      _FavoriteItems.putIfAbsent(matchID, () => FavoritestAttr(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          imageUrl: imageURL,
          stadium:  new Stadium("Antonis Papadopoulos", 7000,
            new Sector("SOUTH", 2400),
            new Sector("NORTH", 1200),
            new Sector("WEST", 3700),
            new Sector("EAST", 1500),
          )
      ));

    }
    notifyListeners();
  }


  ///  removeItem method is being called when the user
  ///  press the 'x' button in the cart screen.
  ///  Then the product/ticket will be deleted
  ///  from the list
  void removeItem(String matchId){
    _FavoriteItems.remove(matchId);
    notifyListeners();

  }

  /// when method clearCart  is invoked
  /// then the cart will be cleared.
  void clearFavorites(){
    _FavoriteItems.clear();
    notifyListeners();
  }

}