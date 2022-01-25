import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sep21/Models/Stadium.dart';

class OrdersAttr with ChangeNotifier {

  final String orderId;
  final String userId;
  final String matchId;
  final String title;
  final String imageUrl;
  final String quantity;
  final Timestamp orderDate;

  OrdersAttr(this.orderId, this.userId, this.matchId, this.title, this.imageUrl,
      this.quantity, this.orderDate);

// final String ticketId

}
