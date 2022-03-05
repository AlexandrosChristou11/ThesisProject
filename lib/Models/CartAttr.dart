
import 'package:flutter/material.dart';
import 'package:sep21/Models/Stadium.dart';

class CartAttr with ChangeNotifier{

  final String ticketId;
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String imageUrl;
  //final Stadium stadium;
  //final String ticketId;
  final String matchId;
  final String ticketType;
  final String sector;
  final String stadium;
  final String date;
  final String fanId;



  CartAttr({required this.ticketId, required this.id, required this.title, required this.quantity, required this.price,
  required this.imageUrl, /*required this.stadium*/ required this.matchId, required this.sector, required this.ticketType,
    required this.stadium, required this.date, required this.fanId
  });


}
