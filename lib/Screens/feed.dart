

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sep21/Widgets/feeds_products.dart';
import 'package:sep21/Models/Match.dart';

class Feed extends StatelessWidget{
  List <Match> _matches =[
    Match("match1", "Anorthosis VS Omonoia", "Championship Game", 10.0
        , "https://upload.wikimedia.org/wikipedia/en/thumb/5/50/Anorthosis_FC_logo.svg/1200px-Anorthosis_FC_logo.svg.png",
        "Cup", 7000, true, true, "Anorthosis", "Omonoia", "29 October 2021"),

    Match("match2", "AEL VS Aris", "Championship Game", 10.0
        , "https://seeklogo.com/images/A/AEL-logo-4FD3D4029E-seeklogo.com.png",
        "Championship", 4000, true, true, "AEL", "Aris", "30 October 2021"),

    Match("match3", "Doxa VS Apoel", "Championship Game", 10.0
        , "https://seeklogo.com/images/D/doxa-katokopias-fc-logo-4995917919-seeklogo.com.png",
        "Championship", 4000, true, true, "Doxa", "Apoel", "30 October 2021"),


    Match("match4", "AEK VS Ethnikos", "Championship Game", 10.0
        , "https://seeklogo.com/images/A/aek-larnaca-logo-A2A11BB75C-seeklogo.com.png",
        "Championship", 4000, true, true, "Aek", "Ethnikos", "31 October 2021"),

    Match("match5", "Olympiakos VS Apollon", "Championship Game", 10.0
        , "https://seeklogo.com/images/O/olympiakos-nicosia-logo-BE09F64A71-seeklogo.com.gif",
        "Championship", 4000, true, true, "Olympiakos", "Apollon", "31 October 2021"),

  ];

  static const routeName = '/feed';
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      // List with all the available matches.
      body:
      // StaggeredGridView.countBuilder(
      //   crossAxisCount: 6,
      //   itemCount: 8,
      //   itemBuilder: (BuildContext context, int index) => FeedProducts(),
      //   staggeredTileBuilder: (int index) =>
      //   new StaggeredTile.count(3, index.isEven ? 4 : 5),
      //   mainAxisSpacing: 8.0,
      //   crossAxisSpacing: 6.0,
      // )
      GridView.count(crossAxisCount: 2,
      childAspectRatio: 240/600,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      children: List.generate(_matches.length, (index) {
        return FeedProducts(
            id: _matches[index].id,
            description:_matches[index].description,
            price: _matches[index].price,
            quantity: _matches[index].quantity,
            imageURL: _matches[index].imageURL,
            isFavorite: true

        );
      }),
      )
    );
  }

}