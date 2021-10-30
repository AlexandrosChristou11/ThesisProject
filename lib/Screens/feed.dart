

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:sep21/Provider/Matches.dart';
import 'package:sep21/Widgets/feeds_products.dart';
import 'package:sep21/Models/Match.dart';

class Feed extends StatelessWidget{


  static const routeName = '/feed';
  @override
  Widget build(BuildContext context) {

    final matchesProvider = Provider.of<Matches>(context);
    List<Match> matchesList = matchesProvider.matches;

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
      childAspectRatio: 240/420,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      children: List.generate(matchesList.length, (index) {
        return FeedProducts(
            id: matchesList[index].id,
            description:matchesList[index].description,
            price: matchesList[index].price,
            quantity: matchesList[index].quantity,
            imageURL: matchesList[index].imageURL,
            isFavorite: true

        );
      }),
      )
    );
  }

}