// This class is responsible to provide all matches
// to each call of FeedProduct() .file
// In order to avoid repeated & boilerplate code, this class
// is created !!
// @author: Alexandros Christou
// Date: 30 Oct 202

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sep21/Models/Match.dart';
import 'package:sep21/Models/Sector.dart';
import 'package:sep21/Models/Stadium.dart';
import 'package:sep21/Provider/PopulateStadiums.dart';

class Matches with ChangeNotifier {

  List<Match> _matches = [];

  List<Match> get matches {
    return _matches;
  }

  Future <void> FetchMatches() async{
    await FirebaseFirestore.instance.collection('Matches')
        //.where("DateAndTime", isGreaterThan:  DateTime.now())
        .get()
        .then((QuerySnapshot matchesSnapshots) => {
          _matches = [], /// We place this here to avoid re-initialization and duplication of content
          matchesSnapshots.docs.forEach((element) {
            _matches.insert(0, Match(
             element.get('MatchId'),
             element.get('MatchTitle'),
             element.get('Competition'),
             element.get('Sport'),
              0,
              element.get('Image'),
              true,
              element.get('HomeTeam'),
              element.get('AwayTeam'),
              element.get('DateAndTime'),
              element.get('Location'),
              int.parse( element.get('Sector A Student Ticket Quantity') ),
              double.parse( element.get('Sector A Student Ticket Price') ),
              int.parse( element.get('Sector A Regular Ticket Quantity') ),
              double.parse(element.get('Sector A Regular Ticket Price') ),
              int.parse( element.get('Sector B Student Ticket Quantity')),
              double.parse( element.get('Sector B Student Ticket Price') ),
              int.parse( element.get('Sector B Regular Ticket Quantity')),
              double.parse( element.get('Sector B Regular Ticket Price') ),
              int.parse (element.get('Sector C Student Ticket Quantity')),
              double.parse( element.get('Sector C Student Ticket Price')),
              int.parse(element.get('Sector C Regular Ticket Quantity')),
              double.parse(element.get('Sector C Regular Ticket Price'))

            ));
          })
    });
  }

  List<Match> get PopularMatches {
    return _matches.where((element) => element.isPopular).toList();
  }

  Match findByID(String mId) {
    return _matches.firstWhere((element) => element.id == mId);
  }

  List<Match> findByTeam(String teamName) {
    return (_matches
        .where((element) =>
            element.homeTeam.toLowerCase().contains(teamName.toLowerCase()))
        .toList());
  }

  List<Match> findBySport(String sport) {
    return _matches
        .where((element) =>
            element.sport.toLowerCase().contains(sport.toLowerCase()))
        .toList();
  }

  /// -----------------------
  ///  Returns the match that
  ///  has been searched by name
  ///  passed as argument
  /// -----------------------
  List<Match> searchQuery(String search) {
    return _matches
        .where((element) =>
        element.title.toLowerCase().contains(search.toLowerCase()))
        .toList();
  }

}


