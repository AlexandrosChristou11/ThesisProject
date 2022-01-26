

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:sep21/Provider/Matches.dart';
import 'package:sep21/Widgets/feeds_products.dart';
import 'package:sep21/Models/Match.dart';

class CategoriesFeedsScreen extends StatelessWidget{


  static const routeName = '/categories_feeds';
  @override
  Widget build(BuildContext context) {

    final matchesProvider = Provider.of<Matches>(context, listen: false);
    final categoryName = ModalRoute.of(context)!.settings.arguments as String;
    print (categoryName);
    final List<Match> matchesList = matchesProvider.findBySport(categoryName);

    return Scaffold(

      // List with all the available matches.
        body: matchesList.isEmpty?
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Feather.database, size: 100,),
              SizedBox(height: 40,),
              Text('No matches available for sport ${categoryName}', textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
            ],
          ),
        ) :
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
            return ChangeNotifierProvider.value(
              value: matchesList[index],
              child: FeedProducts(


              ),
            );
          }),
        )
    );
  }

}