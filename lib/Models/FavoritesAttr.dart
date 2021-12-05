
// @Author: Alexandros Christou
// Date : 05Dec21
// Model class for favorites


import 'package:flutter/material.dart';

import 'Stadium.dart';

class FavoritestAttr with ChangeNotifier{

  final String id;
  final String title;
  final double price;
  final String imageUrl;
  final Stadium stadium;

  FavoritestAttr({required this.id, required this.title, required this.price, required this.imageUrl,required this.stadium,});


}
