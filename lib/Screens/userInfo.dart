

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sep21/Provider/DarkTheme.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppColors.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppIcons.dart';
import 'package:list_tile_switch/list_tile_switch.dart';
import 'package:sep21/Screens/Wishlist/wishlist.dart';
import 'package:sep21/Screens/Card/cart.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'Orders/order.dart';


class UserInfo extends StatefulWidget{
  static const routeName = '/userInfo';
  @override
  _UserInfoState createState() => _UserInfoState();

}

class _UserInfoState extends State<UserInfo> {

  late ScrollController _scrollController;
  var top = 0.0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController =ScrollController();
    _scrollController.addListener(() {setState(() {

    });});
    GetData();
  }
  FirebaseAuth _auth = FirebaseAuth.instance;
  String _userId = "";
  String _name = "";
  String _email = "";
  String _joinedAt = "";
  String _phoneNumber = "";
  String _imageUrl = "";

  void GetData() async{
    User? user = _auth.currentUser;
    _userId = user!.uid;
    final DocumentSnapshot userDocuments =
          await FirebaseFirestore.instance.collection('Users').doc(_userId).get();

    //print ("user name: " + user.);
    print ("image url: " + user.photoURL.toString());
    print ("email " + user.email.toString());

    setState(() {
      _name = userDocuments.get('name');
      _email = user.email!;
      _phoneNumber = userDocuments.get('phoneNumber');
      _joinedAt = userDocuments.get('joinedAt');
      _imageUrl = userDocuments.get('ImageUrl');

      // _name = user.displayName!;
      // _email = user.email!;
      // _phoneNumber = user.phoneNumber!;
      // _joinedAt = userDocuments.get('joinedAt');
      // _imageUrl = user.photoURL!;
    });


  }

  @override
  Widget build(BuildContext context) {

    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
    body:
    Stack(
      children: [
      CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
      SliverAppBar(
      automaticallyImplyLeading: false,
      elevation: 4,
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            top = constraints.biggest.height;
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      MyAppColor.starterColor,
                      MyAppColor.endColor,
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
              child: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                centerTitle: true,
                title: Row(
                  //  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AnimatedOpacity(
                      duration: Duration(milliseconds: 300),
                      opacity: top <= 110.0 ? 1.0 : 0,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 12,
                          ),
                          Container(
                            height: kToolbarHeight / 1.8,
                            width: kToolbarHeight / 1.8,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white,
                                  blurRadius: 1.0,
                                ),
                              ],
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(
                                    _imageUrl),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            // 'top.toString()',
                            _name==null ? 'Guest' : _name,
                            style: TextStyle(
                                fontSize: 20.0, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                background: Image(
                  image: NetworkImage(
                      _imageUrl),
                  fit: BoxFit.fill,
                ),
              ),
            );
          }),
    ),

      SliverToBoxAdapter(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,

          // -- USER INFORMATION --
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: userTitle('User Bag'),
            ),
            Divider(thickness: 1, color: Colors.grey),
            Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: Theme.of(context).splashColor,
                child: ListTile(title: Text('Wishlist'),
                  trailing: Icon(Icons.chevron_right_rounded),
                  onTap: ()=> Navigator.of(context).pushNamed(Wishlist.routeName),
                  leading: Icon(MyAppIcons.wishlist),
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: Theme.of(context).splashColor,
                child: ListTile(title: Text('My Tickets'),
                  trailing: Icon(Icons.chevron_right_rounded),
                  onTap: ()=> Navigator.of(context).pushNamed(Order.routeName),
                  leading: Icon(MyAppIcons.seat),
                ),
              ),
            ),

            Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: Theme.of(context).splashColor,
                child: ListTile(title: Text('Cart'),
                  trailing: Icon(Icons.chevron_right_rounded),
                  onTap: ()=> Navigator.of(context).pushNamed(Cart.routeName),
                  leading: Icon(MyAppIcons.cart),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: userTitle('User Information'),
          ),
      Divider(thickness: 1, color: Colors.grey),
            userListTile("Username" , _name ?? '', 0 ,context),
      userListTile("Email" , _email ?? '', 1 ,context),
      userListTile("Phone" , _phoneNumber.toString()?? '', 2 ,context),
      //userListTile("Local Ship" , "sub", 2 ,context),
      userListTile("Joined Date" , _joinedAt ?? '', 3 ,context),
      userListTile("Fan Card" , "id", 4 ,context),


          Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: userTitle('User Settings'),
          ),
          Divider(thickness: 1, color: Colors.grey),

          // -- USER SETTINGS --
          ListTileSwitch(
            value: themeChange.darkTheme,
            leading: Icon(MyAppIcons.darkMode),
            onChanged: (value) {
              setState(() {
                themeChange.darkTheme = value;
              });
            },
            visualDensity: VisualDensity.comfortable,
            switchType: SwitchType.cupertino,
            switchActiveColor: Colors.indigo,
            title: Text('Dark Theme'),

          ), Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Theme.of(context).splashColor,
                  child:  ListTile(title: Text('Logout'),
                    onTap: () async{
                      // Navigator.canPop(context)? Navigator.pop(context):null;
                      showDialog(
                          context: context,
                          builder: (BuildContext ctx) {
                            return AlertDialog(
                              title: Row(
                                children: [
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(right: 6.0),
                                    child: Icon(MyAppIcons.logout,size: 24, color: Colors.red,),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Sign out'),
                                  ),
                                ],
                              ),
                              content: Text('Do you wanna Sign out?'),
                              actions: [
                                TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Cancel')),
                                TextButton(
                                    onPressed: () async {
                                      await _auth.signOut().then((value) => Navigator.pop(context));
                                    },
                                    child: Text('OK', style: TextStyle(color: Colors.red),))
                              ],
                            );
                          });
                    },
                    leading: Icon(MyAppIcons.exit ),
        ),
      ),
    ),
          ],
      ),
      )
      ],
      ),
        _buildFab()
      ],
    ),
    );
  }

  Widget _buildFab() {
    //starting fab position
    final double defaultTopMargin = 200.0 - 4.0;
    //pixels from top where scaling should start
    final double scaleStart = 160.0;
    //pixels from top where scaling should end
    final double scaleEnd = scaleStart / 2;

    double top = defaultTopMargin;
    double scale = 1.0;
    if (_scrollController.hasClients) {
      double offset = _scrollController.offset;
      top -= offset;
      if (offset < defaultTopMargin - scaleStart) {
        //offset small => don't scale down
        scale = 1.0;
      } else if (offset < defaultTopMargin - scaleEnd) {
        //offset between scaleStart and scaleEnd => scale down
        scale = (defaultTopMargin - scaleEnd - offset) / scaleEnd;
      } else {
        //offset passed scaleEnd => hide fab
        scale = 0.0;
      }
    }

    return  Positioned(
      top: top,
      right: 16.0,
      child:  Transform(
        transform:  Matrix4.identity()..scale(scale),
        alignment: Alignment.center,
        child:  FloatingActionButton(
          backgroundColor: Colors.blue,
          heroTag: "btn1",
          onPressed: (){},
          child:  Icon(MyAppIcons.camera),
        ),
      ),
    );
  }

  List<IconData> _userTileIcons = [
    MyAppIcons.email, MyAppIcons.phone, MyAppIcons.local_ship, MyAppIcons.watch_later, MyAppIcons.exit ];

  Widget userListTile (String title, String sub, int index, BuildContext context){
    return   Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Theme.of(context).splashColor,
        child: ListTile(title: Text(title),
          onTap: (){},
          subtitle: Text(sub),
          leading: Icon(_userTileIcons[index]),
        ),
      ),
    );
  }





  Widget userTitle (String title){
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Text(title,
        style: TextStyle (fontWeight: FontWeight.bold,fontSize: 22),
      ),
    );
  }

  Future <void> SignOut(BuildContext context) async {
    showDialog(context: context, builder: (BuildContext ctx){
      return AlertDialog(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 6.0),
              child: Icon(MyAppIcons.logout,size: 24, color: Colors.red,),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Log out' ),
            )
          ],
        ),
        content: Text('Do you want to log out?'),
        actions: [



           TextButton(onPressed: () async{
            Navigator.pop(context);
          },
              child: Text('Cancel', style: TextStyle(color: MyAppColor.favColor),)),



          TextButton(onPressed: () async{

            Navigator.pop(context);
            await _auth.signOut().then( (value)=> Navigator.pop(context) );
          },
              child: Text('OK', style: TextStyle(color: MyAppColor.favColor),)),
        ],
      );

    });
}}