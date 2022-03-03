
import 'package:flutter/cupertino.dart';

class Ticket with ChangeNotifier{

  String matchId;
  String ticketType;
  String sectorSeating;
  String credentials;
  int fanId;

  Ticket({required this.matchId, required this.ticketType, required this.sectorSeating, required this.credentials,
      required this.fanId});
}
