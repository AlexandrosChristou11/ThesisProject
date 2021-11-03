

import 'package:flutter/cupertino.dart';

class Match with ChangeNotifier {
  final String id;
  final String title;
  final String type;
  final String sport;
  final double price;
  final String imageURL;
  final String categoryName;
  final int quantity;
  final bool isFavorite;
  final bool isPopular;
  final String homeTeam;
  final String AwayTeam;
  final String date;

  Match(this.id, this.title, this.type, this.price, this.imageURL, this.categoryName, this.quantity, this.isFavorite, this.isPopular, this.homeTeam, this.AwayTeam, this.date, this.sport);


}