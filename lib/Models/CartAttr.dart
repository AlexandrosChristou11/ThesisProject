
import 'package:flutter/material.dart';
import 'package:sep21/Models/Stadium.dart';

class CartAttr with ChangeNotifier{

  final String id;
  final String title;
  final int quantity;
  final double price;
  final String imageUrl;
  final Stadium stadium;
  //final String ticketId;

  CartAttr({required this.id, required this.title, required this.quantity, required this.price, required this.imageUrl,required this.stadium,});


}
