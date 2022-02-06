/// Alexandros Christou - 09Feb21
/// Implementation Match Preview screen
/// In the current screen, the admin users will preview
/// the match details before uploading it!


import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppColors.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:sep21/Models/MatchPreview.dart';
import 'package:sep21/Services/Global_methods.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:icon_picker/icon_picker.dart';
import 'package:date_format/date_format.dart';
import 'package:uuid/uuid.dart';

class MatchPreviewScreen extends StatelessWidget {

  static const routeName = '/MatchPreviewScreen';
  //const MatchPreview({Key? key}) : super(key: key);

  //@override
  //_MatchPreviewState createState() => _MatchPreviewState();



  @override
  Widget build(BuildContext context) {
    var _details = ModalRoute.of(context)!.settings.arguments as String;
    print('NEW MATCH TO UPLOAD ' + _details);
   return Scaffold();
  }
}



