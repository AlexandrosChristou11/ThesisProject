

import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sep21/Provider/DarkTheme.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppColors.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppIcons.dart';
import 'package:list_tile_switch/list_tile_switch.dart';
import 'package:sep21/Screens/Wishlist/wishlist.dart';
import 'package:sep21/Screens/Card/cart.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sep21/Services/Global_methods.dart';
import 'package:sep21/Services/push_notification.dart';
import 'package:wiredash/wiredash.dart';

import 'Orders/order.dart';


class _UserInfoState extends State<UserInfo> {

  late ScrollController _scrollController;
  var top = 0.0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_UpdateConnectionState);

    _scrollController =ScrollController();
    _scrollController.addListener(() {setState(() {

    });});
    GetData();
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
    _connectivitySubscription.cancel();

    super.dispose();
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  String _userId = "";
  String _name = "";
  String _email = "";
  String _joinedAt = "";
  String _phoneNumber = "";
  String? _imageUrl;
  File? _pickedImage;

  Future<void> GetData() async{
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
      _imageUrl =   userDocuments.get('ImageUrl');

      // _name = user.displayName!;
      // _email = user.email!;
      // _phoneNumber = user.phoneNumber!;
      // _joinedAt = userDocuments.get('joinedAt');
      // _imageUrl = user.photoURL!;
    });


  }

  void _pickAvatarCamera() async{
    final picker = ImagePicker();
    final pickedImg = await picker.pickImage(source: ImageSource.camera);
    final pickedImgFile = File(pickedImg!.path);
    setState(() {
      _pickedImage = pickedImgFile;
    });

    UpdateImageOnFirebaseCloud();

    Navigator.pop(context);
  }

  void _pickAvatarGallery() async{
    final picker = ImagePicker();
    final pickedImg = await await picker.pickImage(source: ImageSource.gallery);
    final pickedImgFile = File(pickedImg!.path);
    setState(() {
      _pickedImage = pickedImgFile;
    });

    UpdateImageOnFirebaseCloud();

    Navigator.pop(context);
  }

  void  _removeAvatar(){
    setState(() {
      _pickedImage = null;
    });

    Navigator.pop(context);
  }

  void UpdateImageOnFirebaseCloud() async{
    /// Get avatar of user & check if exists ni firestorage
    var currentImage = FirebaseStorage.instance.ref('UsersImages').child( _name + ".jpg").getDownloadURL();
    final ref = FirebaseStorage.instance.ref('UsersImages').child(_name + ".jpg").delete();

    /// Insert new picture in firestorage for current user
    final reference = FirebaseStorage.instance.ref('UsersImages').child(
        _name + ".jpg");
    await reference.putFile(_pickedImage!);
    _imageUrl = await reference.getDownloadURL();
    var collection = FirebaseFirestore.instance.collection('Users');
    collection
        .doc(_userId) // <-- Doc ID where data should be updated.
        .update({'ImageUrl': _imageUrl});


  }

  @override
  Widget build(BuildContext context) {

    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
    body:

    RefreshIndicator(

      onRefresh: _GetUserDetails,
      child: Stack(
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
                                      _imageUrl.toString() ?? "https://cdn1.vectorstock.com/i/thumb-large/62/60/default-avatar-photo-placeholder-profile-image-vector-21666260.jpg"),
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
                  background: CachedNetworkImage(
                    imageUrl: _imageUrl ?? "",
                    placeholder: (context, url) => new CircularProgressIndicator(),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
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
                child:
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                    //color:  Colors.grey.shade100,
                    child: InkWell(
                      splashColor: Theme.of(context).splashColor,
                      child: ListTile(title: Text('Wishlist'),
                        trailing: Icon(Icons.chevron_right_rounded),
                        onTap: ()=> Navigator.of(context).pushNamed(Wishlist.routeName),
                        leading: Icon(MyAppIcons.favorite, color: Colors.red,),
                      ),
                    ),
                  ),

              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Theme.of(context).splashColor,
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    child: ListTile(title: Text('My Tickets'),
                      trailing: Icon(Icons.chevron_right_rounded),
                      onTap: ()=> Navigator.of(context).pushNamed(Order.routeName),
                      leading: Icon(MyAppIcons.seat, color: Colors.green.shade300,),
                    ),
                  ),
                ),
              ),

              Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Theme.of(context).splashColor,
                  child: Card(
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                    child: ListTile(title: Text('Cart'),
                      trailing: Icon(Icons.chevron_right_rounded),
                      onTap: ()=> Navigator.of(context).pushNamed(Cart.routeName),
                      leading: Icon(MyAppIcons.cart, color: Colors.deepPurpleAccent.shade400,),
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: userTitle('User Information'),
            ),
        Divider(thickness: 1, color: Colors.grey),
              Card(shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),child: userListTile("Username" , _name ?? '', 0 ,context)),
        Card(shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),child: userListTile("Email" , _email ?? '', 1 ,context)),
        Card(shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),child: userListTile("Phone" , _phoneNumber.toString()?? '', 2 ,context)),
        Card(shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),child: userListTile("Joined Date" , _joinedAt ?? '', 3 ,context)),


            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: userTitle('User Settings'),
            ),
            Divider(thickness: 1, color: Colors.grey),

            // -- USER SETTINGS --
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTileSwitch(
                value: themeChange.darkTheme,
                leading: themeChange.darkTheme ?  Icon(MyAppIcons.darkMode, color: Colors.amber.shade800,): Icon(MyAppIcons.lightMode, color: Colors.amber.shade800) ,
                onChanged: (value) {
                  setState(() {
                    themeChange.darkTheme = value;
                  });
                },
                visualDensity: VisualDensity.comfortable,
                switchType: SwitchType.cupertino,
                switchActiveColor: Colors.indigo,
                title: themeChange.darkTheme ? Text('Dark Mode') :Text('Light Mode'),

              ),
            ),


              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ListTileSwitch(
                  value: PushNotification.recieveNotifications,
                  leading: Icon(MyAppIcons.notifications, color: Colors.green.shade100,) ,
                  onChanged: (value) {
                    setState(() {
                      print('NEW VALUE FOR NOTITIFICATIONS: ${value}');
                      PushNotification.recieveNotifications = value;
                      if (!value) {
                        PushNotification.unsubscrbeFromTopic();
                      }else{
                        PushNotification.subscrbeToTopic();
                      }
                    });
                  },
                  visualDensity: VisualDensity.comfortable,
                  switchType: SwitchType.cupertino,
                  switchActiveColor: Colors.indigo,
                  title: Text('Notifications'),

                ),
              ),


              Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Theme.of(context).splashColor,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(title: Text('Rate our application'),
                      trailing: Icon(Icons.chevron_right_rounded),
                      onTap: ()=> Wiredash.of(context)?.show(),
                      leading: Icon(MyAppIcons.feedback_outlined, color: Colors.amberAccent,),
                    ),
                  ),
                ),
              ),
              Material(
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
          onPressed: (){
            showDialog(context: context, builder:(BuildContext ctx){
              return AlertDialog(
                //backgroundColor: .darkTheme ?  Colors.white : Colors.white,
                shape: RoundedRectangleBorder(borderRadius:
                BorderRadius.all(Radius.circular(15))),
                title: Text('Choose Option',
                  style: TextStyle(fontWeight: FontWeight.w600, color: MyAppColor.gradiendLStart),

                ),
                /// ----------------
                ///  Dialog options
                /// ----------------
                content: SingleChildScrollView(
                  child: ListBody(

                    children: [

                      /// (1) Take from camera..
                      InkWell(
                        onTap: _pickAvatarCamera,
                        splashColor: Colors.blueGrey,
                        child:
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.camera, color:Colors.blueGrey ,),
                            ),
                            Text('Camera', style: TextStyle(fontSize: 18, color: MyAppColor.title, fontWeight: FontWeight.w500),)
                          ],

                        ),
                      ),

                      /// (2) Select from Gallery ...
                      InkWell(
                        onTap: _pickAvatarGallery,
                        splashColor: Colors.blueGrey,
                        child:
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.image, color:Colors.blueGrey ,),
                            ),
                            Text('Gallery', style: TextStyle(fontSize: 18, color: MyAppColor.title, fontWeight: FontWeight.w500),)
                          ],

                        ),
                      ),

                      /// (3) Remove Avatar Image ..
                      InkWell(
                        onTap: (){},
                        splashColor: Colors.red,
                        child:
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.remove_circle, color:Colors.red ,),
                            ),
                            Text('Remove', style: TextStyle(fontSize: 18, color: MyAppColor.title, fontWeight: FontWeight.w500),)
                          ],

                        ),
                      )

                    ],
                  ),
                ),
              );
            } );
          },
          child:  Icon(MyAppIcons.camera),
        ),
      ),
    );
  }

  List<IconData> _userTileIcons = [
    MyAppIcons.user,MyAppIcons.email, MyAppIcons.phone, MyAppIcons.watch_later, MyAppIcons.exit ];


  Widget userListTile (String title, String sub, int index, BuildContext context){
    return   Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Theme.of(context).splashColor,
        child: ListTile(title: Text(title),
          onTap: (){},
          subtitle: Text(sub),
          leading: Icon(_userTileIcons[index], color: Colors.blueAccent.shade100,),
        ),
      ),
    );
  }


  Widget userTitle (String title){
    return Padding(
      padding: const EdgeInsets.all(14.0),
     // padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
}
  Future<void> _GetUserDetails() async {

  }
}



class UserInfo extends StatefulWidget{
  static const routeName = '/userInfo';
  @override
  _UserInfoState createState() => _UserInfoState();
}
