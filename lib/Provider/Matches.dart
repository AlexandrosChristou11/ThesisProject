
// This class is responsible to provide all matches
// to each call of FeedProduct() .file
// In order to avoid repeated & boilerplate code, this class
// is created !!
// @author: Alexandros Christou
// Date: 30 Oct 202

import 'package:flutter/cupertino.dart';
import 'package:sep21/Models/Match.dart';

class Matches with ChangeNotifier{
  List <Match> _matches =[
    Match("match1", "Anorthosis VS Omonoia", "Championship", 10.0
        , "https://upload.wikimedia.org/wikipedia/en/thumb/5/50/Anorthosis_FC_logo.svg/1200px-Anorthosis_FC_logo.svg.png",
        "Cup", 7000, true, true, "Anorthosis", "Omonoia", "29 October 2021", "Football"),

    Match("match2", "AEL VS Aris", "Championship", 10.0
        , "https://seeklogo.com/images/A/AEL-logo-4FD3D4029E-seeklogo.com.png",
        "Championship", 4000, true, true, "AEL", "Aris", "30 October 2021", "Football"),

    Match("match3", "Doxa VS Apoel", "Championship", 10.0
        , "https://seeklogo.com/images/D/doxa-katokopias-fc-logo-4995917919-seeklogo.com.png",
        "Championship", 4000, true, true, "Doxa", "Apoel", "30 October 2021", "Football"),


    Match("match4", "AEK VS Ethnikos", "Championship", 10.0
        , "https://seeklogo.com/images/A/aek-larnaca-logo-A2A11BB75C-seeklogo.com.png",
        "Championship", 4000, true, true, "Aek", "Ethnikos", "31 October 2021", "Football"),

    Match("match5", "Olympiakos VS Apollon", "Championship", 10.0
        , "https://seeklogo.com/images/O/olympiakos-nicosia-logo-BE09F64A71-seeklogo.com.gif",
        "Championship", 4000, true, true, "Olympiakos", "Apollon", "31 October 2021", "Football"),

    Match("match6", "Anorthosis VS Apollon", "Championship", 10.0
        , "https://upload.wikimedia.org/wikipedia/en/thumb/5/50/Anorthosis_FC_logo.svg/1200px-Anorthosis_FC_logo.svg.png",
        "Championship", 7000, true, true, "Anorthosis", "Apollon", "31 October 2021", "Football"),

  ];

  List<Match> get matches{
    return _matches;
  }

  List <Match> findByTeam(String teamName){

    return (_matches.where((element) => element.homeTeam.toLowerCase().contains(teamName.toLowerCase())).toList()) ;

  }

  // List <Match> findBySport(String sport){
  //   return _matches.where((element) => element.type.toLowerCase().contains(sport.toLowerCase())).toList();
  //
  // }

}