
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppColors.dart';
import 'package:sep21/Models/Match.dart';
import 'package:sep21/Provider/Matches.dart';
import 'package:sep21/Services/Global_methods.dart';
import 'package:sep21/Widgets/feeds_products.dart';
import 'package:sep21/Widgets/searchByHeader.dart';


class Search extends StatefulWidget {

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late TextEditingController _searchTextController;
  final FocusNode _node = FocusNode();
  void initState(){
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_UpdateConnectionState);

    _searchTextController = TextEditingController();
    _searchTextController.addListener(() { setState(() {

    });});
  }
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription< ConnectivityResult > _connectivitySubscription;
  static bool isConnected = false;



  Future< void > initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print("Error Occurred: ${e.toString()} ");
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _UpdateConnectionState(result);
  }

  Future<void> _UpdateConnectionState(ConnectivityResult result) async {
    if ((result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi ) ) {
      if (!GlobalMethods.isConnected){
        GlobalMethods.isConnected = true;
      }

    } else if (result == ConnectivityResult.none && GlobalMethods.isConnected) {
      GlobalMethods.isConnected = false;
      GlobalMethods.showStatus(result, false, context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _connectivitySubscription.cancel();
    _node.dispose();
    _searchTextController.dispose();
  }

  List<Match> _searchList =[];
  @override
  Widget build(BuildContext context) {
    final matchData = Provider.of<Matches>(context);
    final matchesList = matchData.matches;
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
        /// --------------------------
          /// Handling search bar actions ..
        /// --------------------------
        SliverPersistentHeader(
        floating: true,
        pinned: true,
        delegate: SearchByHeader(
          stackPaddingTop: 175,
          titlePaddingTop: 50,
          title: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Search",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: MyAppColor.white,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          stackChild: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 1,
                  blurRadius: 3,
                ),
              ],
            ),
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchTextController,
              minLines: 1,
              focusNode: _node,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    width: 0,
                    style: BorderStyle.solid,
                  ),
                ),
                prefixIcon: Icon(
                  Icons.search,
                ),
                hintText: 'Search',
                filled: true,
                fillColor: Theme.of(context).cardColor,
                suffixIcon: IconButton(
                  onPressed: _searchTextController.text.isEmpty
                      ? null
                      : () {
                    _searchTextController.clear();
                    _node.unfocus();
                  },
                  icon: Icon(Feather.x,
                      color: _searchTextController.text.isNotEmpty
                          ? Colors.red
                          : Colors.grey),
                ),
              ),
              onChanged: (value) {
                _searchTextController.text.toLowerCase();
                setState(() {
                  _searchList = matchData.searchQuery(value);
                });
              },
            ),
          ),
        ),
      ),


          /// -------------------------
          ///  Widget for handling empty results
          ///  (No match-team exist with such a searched name)
          /// -------------------------
          SliverToBoxAdapter(
            child: _searchTextController.text.isNotEmpty && _searchList.isEmpty
            ? Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Icon(
                  Feather.search,
                  size: 60
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  'No results found',
                  style: TextStyle(
                    fontSize: 30, fontWeight:  FontWeight.w700
                  ),
                )
              ],
            )
                : GridView.count(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                childAspectRatio: 240/420,
                crossAxisSpacing: 8,
                children: List.generate(
                    _searchTextController.text.isEmpty
                    ? matchesList.length
                    : _searchList.length, (index){
                      return ChangeNotifierProvider.value(value: _searchTextController.text.isEmpty
                      ? matchesList [index]
                          : _searchList[index],
                        child: FeedProducts(),
                      );
                },
                )
            ),
          )
        ],
      ),

    );
  }
}
