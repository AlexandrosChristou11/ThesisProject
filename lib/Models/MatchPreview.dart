import 'dart:io';

import 'package:flutter/material.dart';

/// @author: Alexandros Christou
/// Date: 06Feb21
/// MatchPreview model


class MatchPreview{
  File? PickedImage;
  String MatchName;
  String HomeTeam ;
  String AwayTeam;
  DateTime Date;
  TimeOfDay Time;
  String Location ;
  String SportType ;
  String MatchType ;

  String SectorAStudentQuantity ;
  String SectorAStudentPrice ;
  String SectorARegularQuantity ;
  String SectorARegularPrice ;
  String SectorBStudentQuantity ;
  String SectorBStudentPrice ;
  String SectorBRegularQuantity ;
  String SectorBRegularPrice ;
  String SectorCStudentQuantity ;
  String SectorCStudentPrice ;
  String SectorCRegularQuantity ;
  String SectorCRegularPrice;

  MatchPreview(this.PickedImage,this.MatchName, this.HomeTeam, this.AwayTeam,
      this.Date, this.Time, this.Location, this.SportType, this.MatchType,
      this.SectorAStudentQuantity, this.SectorAStudentPrice,
      this.SectorARegularQuantity, this.SectorARegularPrice,
      this.SectorBStudentQuantity, this.SectorBStudentPrice,
      this.SectorBRegularQuantity, this.SectorBRegularPrice,
      this.SectorCStudentQuantity, this.SectorCStudentPrice,
      this.SectorCRegularQuantity, this.SectorCRegularPrice);

}