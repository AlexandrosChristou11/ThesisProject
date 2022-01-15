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
    await FirebaseFirestore.instance.collection('Matches').get()
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

/*
/// ********************************
  ///           MATCHES
  /// ********************************
  List<Match> _matches = [
    Match(
        "match1",
        "Anorthosis VS Omonoia",
        "Championship",
        10.0,
        "https://upload.wikimedia.org/wikipedia/en/thumb/5/50/Anorthosis_FC_logo.svg/1200px-Anorthosis_FC_logo.svg.png",
        "Cup",
        7000,
        true,
        true,
        "Anorthosis",
        "Omonoia",
        "29 October 2021",
        "Football",
        new Stadium(
          "Antonis Papadopoulos",
          7000,
          new Sector("SOUTH", 2400),
          new Sector("NORTH", 1200),
          new Sector("WEST", 3700),
          new Sector("EAST", 1500),
        )),
    Match(
        "match2",
        "AEL VS Aris",
        "Championship",
        10.0,
        "https://seeklogo.com/images/A/AEL-logo-4FD3D4029E-seeklogo.com.png",
        "Championship",
        4000,
        true,
        true,
        "AEL",
        "Aris",
        "30 October 2021",
        "Football",
        new Stadium(
          "Tsireion Stadium",
          8000,
          new Sector("SOUTH - N/A", 0),
          new Sector("NORTH - N/A", 0),
          new Sector("WEST", 4000),
          new Sector("EAST", 4000),
        )),
    Match(
      "match3",
      "Doxa VS Apoel",
      "Championship",
      10.0,
      "https://seeklogo.com/images/D/doxa-katokopias-fc-logo-4995917919-seeklogo.com.png",
      "Championship",
      4000,
      true,
      true,
      "Doxa",
      "Apoel",
      "30 October 2021",
      "Football",
      new Stadium(
        "Makarion Stadium",
        19000,
        new Sector("SOUTH", 4000),
        new Sector("NORTH", 4000),
        new Sector("WEST", 6000),
        new Sector("EAST", 6000),
      ),
    ),
    Match(
        "match4",
        "AEK VS Ethnikos",
        "Championship",
        10.0,
        "https://seeklogo.com/images/A/aek-larnaca-logo-A2A11BB75C-seeklogo.com.png",
        "Championship",
        4000,
        true,
        true,
        "Aek",
        "Ethnikos",
        "31 October 2021",
        "Football",
        new Stadium(
          "Aek Arena",
          7500,
          new Sector("SOUTH", 1200),
          new Sector("NORTH", 1200),
          new Sector("WEST", 3000),
          new Sector("EAST", 2000),
        )),
    Match(
      "match5",
      "Olympiakos VS Apollon",
      "Championship",
      10.0,
      "https://seeklogo.com/images/O/olympiakos-nicosia-logo-BE09F64A71-seeklogo.com.gif",
      "Championship",
      4000,
      false,
      false,
      "Olympiakos",
      "Apollon",
      "31 October 2021",
      "Football",
      new Stadium(
        "GSP Stadium",
        22000,
        new Sector("SOUTH", 4000),
        new Sector("NORTH", 4000),
        new Sector("WEST", 6000),
        new Sector("EAST", 6000),
      ),
    ),
    Match(
        "match6",
        "Anorthosis VS Apollon",
        "Championship",
        10.0,
        "https://upload.wikimedia.org/wikipedia/en/thumb/5/50/Anorthosis_FC_logo.svg/1200px-Anorthosis_FC_logo.svg.png",
        "Championship",
        7000,
        true,
        true,
        "Anorthosis",
        "Apollon",
        "31 October 2021",
        "Football",
        new Stadium(
          "Antonis Papadopoulos",
          7000,
          new Sector("SOUTH", 2400),
          new Sector("NORTH", 1200),
          new Sector("WEST", 3700),
          new Sector("EAST", 1500),
        )),
  ];
* */
