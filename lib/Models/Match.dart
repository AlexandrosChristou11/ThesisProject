

import 'package:flutter/cupertino.dart';
import 'package:sep21/Models/Stadium.dart';

class Match with ChangeNotifier {
  final String id;
  final String title;
  final String type;
  final String sport;
  final double price;
  final String imageURL;
  //final String categoryName;
  final bool isPopular;
  final String homeTeam;
  final String AwayTeam;
  final String date;
  final String stadium;

  /// SECTOR A - SOUTH OR NORTH
  final int SectorA_StudentQuantity;
  final double SectorA_StudentPrice;
  final int SectorA_RegularQuantity;
  final double SectorA_RegularPrice;

  /// SECTOR B - EAST
  final int SectorB_StudentQuantity;
  final double SectorB_StudentPrice;
  final int SectorB_RegularQuantity;
  final double SectorB_RegularPrice;

  /// SECTOR C - WEST
  final int SectorC_StudentQuantity;
  final double SectorC_StudentPrice;
  final int SectorC_RegularQuantity;
  final double SectorC_RegularPrice;

  Match(
      this.id,
      this.title,
      this.type,
      this.sport,
      this.price,
      this.imageURL,
     //this.categoryName,
      this.isPopular,
      this.homeTeam,
      this.AwayTeam,
      this.date,
      this.stadium,
      this.SectorA_StudentQuantity,
      this.SectorA_StudentPrice,
      this.SectorA_RegularQuantity,
      this.SectorA_RegularPrice,
      this.SectorB_StudentQuantity,
      this.SectorB_StudentPrice,
      this.SectorB_RegularQuantity,
      this.SectorB_RegularPrice,
      this.SectorC_StudentQuantity,
      this.SectorC_StudentPrice,
      this.SectorC_RegularQuantity,
      this.SectorC_RegularPrice);
}