

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:sep21/Models/OrdersAttr.dart';
import 'package:sep21/Screens/Orders/order.dart';

class OrderProvider with ChangeNotifier{

  List<OrdersAttr> _orders = [];

  List<OrdersAttr> get getOrders {
    return _orders;
  }

  Future <void> FetchOrders() async{
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? _user = _auth.currentUser;
    try{
      await FirebaseFirestore.instance.collection('Order')
          .where('userId', isEqualTo: _user?.uid.toString())
          .get()
          .then((QuerySnapshot ordersSnapshots) => {
        _orders.clear(), /// We place this here to avoid re-initialization and duplication of content
        ordersSnapshots.docs.forEach((element) {
          _orders.insert(0, OrdersAttr(
            element.get('orderId'),
            element.get('userId'),
            element.get('matchId'),
            element.get('title'),
            element.get('imageUrl'),
            element.get('quantity').toString(),
            element.get('orderDate'),
          ));
        })
      });

    }catch(e){
      print('Error occured while fetching orders: ${e.toString()} ');

    }
    notifyListeners();
  }


}