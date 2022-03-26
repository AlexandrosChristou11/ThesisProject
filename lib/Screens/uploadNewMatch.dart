/// Alexandros Christou - 09Jan21
/// Implementation UploadNewMatch Screen
/// In the current screen, the user will be allowed to upload
/// a new match in the Firebase db.

import 'dart:io';
import 'package:badges/badges.dart';
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
import 'package:sep21/Consts/my_custom_icons/MyAppIcons.dart';
import 'package:sep21/Models/MatchPreview.dart';
import 'package:sep21/Screens/matchPreview.dart';
import 'package:sep21/Services/Global_methods.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:icon_picker/icon_picker.dart';
import 'package:date_format/date_format.dart';
import 'package:uuid/uuid.dart';

class UploadMatchForm extends StatefulWidget {
  static const routeName = '/UploadMatchForm';

  @override
  _UploadMatchFormState createState() => _UploadMatchFormState();
}

class _UploadMatchFormState extends State<UploadMatchForm> {
  final _formKey = GlobalKey<FormState>();

  /// ----------------------
  ///     MATCH DETAILS:
  /// ----------------------
  var _matchName = '';
  var _homeTeam = '';
  var _awayTeam = 'Default';
  var _dateAndTime = '';
  var _location = 'Default';
  var _sportType = 'Default';
  var _matchType = 'Default';

  var _sectorAStudentQuantity = '';
  var _sectorAStudentPrice = '';
  var _sectorARegularQuantity = '';
  var _sectorARegularPrice = '';
  var _sectorBStudentQuantity = '';
  var _sectorBStudentPrice = '';
  var _sectorBRegularQuantity = '';
  var _sectorBRegularPrice = '';
  var _sectorCStudentQuantity = '';
  var _sectorCStudentPrice = '';
  var _sectorCRegularQuantity = '';
  var _sectorCRegularPrice = '';

  late String _url;
  var _uuid = Uuid();
  late double _height;
  late double _width;
  late String _setTime, _setDate;
  late String _hour, _minute, _time;
  late String dateTime;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  /// --------------
  ///  CONTROLLERS:
  /// --------------
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  final TextEditingController _sportTypeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _matchTypeController = TextEditingController();
  final TextEditingController _awayTeamController = TextEditingController();

  List _listFootballClubs = ['Anorthosis FC', 'Apoel', 'Omonoia', 'Aek'];
  List _listBasketabllClubs = ['Anorthosis FC', 'KERAVNOS', 'Omonoia', 'Aek'];
  List _listHandballClubs = ['Anorthosis FC', 'Apoel', 'ARARAT', 'Aek'];
  List _listVolleyClubs = ['Anorthosis FC', 'SALAMINA', 'Omonoia', 'Aek'];
  List _defaultFootballClubsList = ['Default'];

  List _listFootballStadiums = [
    'Antonis Papadopoulos',
    'GSP',
    'GSZ',
    'AEK ARENA',
    'MAKARION',
    'STELIOS KYRIAKIDES'
  ];
  List _listBasketballStadiums = [
    'KITION',
    'ELEFTHERIA',
    'NIKOS SOLOMONIDES',
    'PAPHIAKO'
  ];
  List _listHandballStadiums = ['ATI', 'NIKOS SOLOMONIDES', 'ELEFTHERIA'];
  List _listVolleyStadiums = [
    'THEMISTOKLEIO',
    'ELEFTHERIA',
    'NIKOS SOLOMONIDES'
  ];
  List _defaultStadiumList = ['0'];

  GlobalMethods gb = new GlobalMethods();
  bool _isLoading = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String _userId = "";

  File? _pickedImage;
  showAlertDialog(BuildContext ctx, String title, String body) {
    showDialog(
        context: ctx,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text(title),
            content: Text(body),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"))
            ],
          );
        });
  }

  Future<void> _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid && validateMatchDetailsFields()) {
      _formKey.currentState!.save();

      try {
        if (_pickedImage == null) {
          gb.authenticationErrorHandler('Please pick an image', context);
        } else {
          setState(() {
            _isLoading = true;
          });

          /// Parsing the model to the MatchPreviewScreen ..
          MatchPreview newMatch = new MatchPreview(
              _pickedImage,
              _matchName,
              _homeTeam,
              _awayTeam,
              selectedDate,
              selectedTime,
              _location,
              _sportType,
              _matchType,
              _sectorAStudentQuantity,
              _sectorAStudentPrice,
              _sectorARegularQuantity,
              _sectorARegularPrice,
              _sectorBStudentQuantity,
              _sectorBStudentPrice,
              _sectorBRegularQuantity,
              _sectorBRegularPrice,
              _sectorCStudentQuantity,
              _sectorCStudentPrice,
              _sectorCRegularQuantity,
              _sectorCRegularPrice);
          print("NEW MATCH HAS DATA location? : ${newMatch.Location}");
          Navigator.pushNamed(context, MatchPreviewScreen.routeName,
              arguments: newMatch);

          /*
          final matchId = _uuid.v4(); /// setting a unique id for each match
          final reference = FirebaseStorage.instance.ref('MatchImages').child(matchId + ".jpg");
          await reference.putFile(_pickedImage!);
          _url = await reference.getDownloadURL();

          final User? user = _auth.currentUser;
          final userId = user!.uid;



          await FirebaseFirestore.instance.collection('Matches').doc(matchId).set({
            'MatchId' : matchId,
            'MatchTitle': _homeTeam + " vs " + _awayTeam,
            'UserId': userId,
            'CreatedAt': Timestamp.now(),
            'Sport' : _sportType,
            'Competition': _matchType,
            'HomeTeam' : _homeTeam,
            'AwayTeam' : _awayTeam,
            'DateAndTime': new DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.hour, selectedTime.minute).toString(),
            'Location' : _location,
            'Sector A Student Ticket Quantity' : _sectorAStudentQuantity,
            'Sector A Student Ticket Price' : _sectorAStudentPrice,
            'Sector A Regular Ticket Quantity' : _sectorARegularQuantity,
            'Sector A Regular Ticket Price' : _sectorARegularPrice,
            'Sector B Student Ticket Quantity' : _sectorBStudentQuantity,
            'Sector B Student Ticket Price' : _sectorBStudentPrice,
            'Sector B Regular Ticket Quantity' : _sectorBRegularQuantity,
            'Sector B Regular Ticket Price' : _sectorBRegularPrice,
            'Sector C Student Ticket Quantity' : _sectorCStudentQuantity,
            'Sector C Student Ticket Price' : _sectorCStudentPrice,
            'Sector C Regular Ticket Quantity' : _sectorCRegularQuantity,
            'Sector C Regular Ticket Price' : _sectorCRegularPrice,
            'Image' : _url

         // print(_dateAndTime);


          });

        */
          //Navigator.canPop(context) ? Navigator.pop(context) : null;
        }
      } catch (e) {
        gb.authenticationErrorHandler(e.toString(), context);
        print('error occurred : ' + e.toString());
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }else{
      gb.authenticationErrorHandler('Please fill missing values', context);
    }
  }

  Future<void> _pickImageCamera() async {
    final picker = ImagePicker();
    final pickedImage =
        await picker.getImage(source: ImageSource.camera, imageQuality: 40);
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
  }

  void _pickImageGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    final pickedImageFile = pickedImage == null ? null : File(pickedImage.path);

    setState(() {
      _pickedImage = pickedImageFile!;
    });
    // widget.imagePickFn(pickedImageFile);
  }

  void _removeImage() {
    setState(() {
      _pickedImage = null;
    });
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(selectedDate);
        print(selectedDate.toString());
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();

        print(selectedTime.hour.toString() +
            ":" +
            selectedTime.minute.toString());
      });
  }

  @override
  void initState() {
    _dateController.text = DateFormat.yMd().format(DateTime.now());

    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    _userId = user!.uid;
    AssignUsersTeam(user);
    RemoveTeamAsAway();
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    dateTime = DateFormat.yMd().format(DateTime.now());

    return Scaffold(
      bottomSheet: Container(
        height: kBottomNavigationBarHeight * 0.8,
        width: double.infinity,
        decoration: BoxDecoration(
          color: MyAppColor.white,
          border: Border(
            top: BorderSide(color: Colors.grey, width: 0.5),
          ),
        ),
        child: Material(
          color: Theme.of(context).backgroundColor,
          child: InkWell(
            onTap: _trySubmit,
            splashColor: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 2),
                  child: _isLoading
                      ? Center(
                          child: Container(
                              height: 40,
                              width: 40,
                              child: CircularProgressIndicator()))
                      : Text(
                          'Preview new match',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                ),
                GradientIcon(
                  MyAppIcons.arrow_forward,
                  20,
                  LinearGradient(
                    colors: <Color>[
                      Colors.green,
                      Colors.yellow,
                      Colors.deepOrange,
                      Colors.orange,
                      Colors.yellow.shade800
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Card(
                margin: EdgeInsets.all(8),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      //mainAxisSize: MainAxisSize.min,
                      children: <Widget>[

                        SizedBox(
                          height: 10,
                        ),

                        /// ------------------------------------------------------
                        ///                      IMAGE PICKER
                        /// ------------------------------------------------------
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              //  flex: 2,
                              child: this._pickedImage == null
                                  ? Container(
                                      margin: EdgeInsets.all(10),
                                      height: 200,
                                      width: 200,
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 1),
                                        borderRadius: BorderRadius.circular(4),
                                        color:
                                            Theme.of(context).backgroundColor,
                                      ),
                                    )
                                  : Container(
                                      margin: EdgeInsets.all(10),
                                      height: 200,
                                      width: 200,
                                      child: Container(
                                        height: 200,
                                        // width: 200,
                                        decoration: BoxDecoration(
                                          // borderRadius: BorderRadius.only(
                                          //   topLeft: const Radius.circular(40.0),
                                          // ),
                                          color:
                                              Theme.of(context).backgroundColor,
                                        ),
                                        child: Image.file(
                                          this._pickedImage!,
                                          fit: BoxFit.contain,
                                          alignment: Alignment.center,
                                        ),
                                      ),
                                    ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FittedBox(
                                  child: FlatButton.icon(
                                    textColor: Colors.white,
                                    onPressed: _pickImageCamera,
                                    icon: Icon(Icons.camera,
                                        color: Colors.purpleAccent),
                                    label: Text(
                                      'Camera',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context)
                                            .textSelectionColor,
                                      ),
                                    ),
                                  ),
                                ),
                                FittedBox(
                                  child: FlatButton.icon(
                                    textColor: Colors.white,
                                    onPressed: _pickImageGallery,
                                    icon: Icon(Icons.image,
                                        color: Colors.purpleAccent),
                                    label: Text(
                                      'Gallery',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context)
                                            .textSelectionColor,
                                      ),
                                    ),
                                  ),
                                ),
                                FittedBox(
                                  child: FlatButton.icon(
                                    textColor: Colors.white,
                                    onPressed: _removeImage,
                                    icon: Icon(
                                      Icons.remove_circle_rounded,
                                      color: Colors.red,
                                    ),
                                    label: Text(
                                      'Remove',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 5,
                        ),
                        Divider(),

                        /// ------------------------------------------------------
                        ///                    SPORT TYPE
                        /// ------------------------------------------------------
                        Center(
                          child: Card(
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            child: Row(
                              children: [
                                Flexible(
                                  flex: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left:2.0),
                                      child: _sportType == 'Default'
                                          ? Icon(Feather.x_circle,
                                              color: Colors.red)
                                          : Icon(
                                              MyAppIcons.check_circle,
                                              color: Colors.green,
                                            ),
                                    ),
                                  ),

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Sport:',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 58.0),
                                  child: DropdownButton<String>(
                                    items: [
                                      DropdownMenuItem<String>(
                                        child: Text('Football'),
                                        value: 'Football',
                                      ),
                                      DropdownMenuItem<String>(
                                        child: Text('Basketball'),
                                        value: 'Basketball',
                                      ),
                                      DropdownMenuItem<String>(
                                        child: Text('Handball'),
                                        value: 'Handball',
                                      ),
                                      DropdownMenuItem<String>(
                                        child: Text('Volley'),
                                        value: 'Volley',
                                      ),
                                      _sportType == 'Default'
                                          ? DropdownMenuItem<String>(
                                              enabled: false,
                                              child: Text('Select Sport ..'),
                                              value: 'Default',
                                            )
                                          : DropdownMenuItem<String>(
                                              enabled: false,
                                              child: Text('Select Sport ..'),
                                              value: '',
                                            ),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        _sportType = value!;
                                        _sportTypeController.text = value;
                                        _defaultFootballClubsList =
                                            DisplayAppropriateClubList();
                                        _defaultStadiumList =
                                            DisplayAppropriateStadiumList();

                                        print(_sportType);
                                      });
                                    },
                                    hint: Text('Select sport type'),
                                    value: _sportType,
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 10,
                        ),
                        Divider(),

                        /// ------------------------------------------------------
                        ///                    MATCH TYPE
                        /// ------------------------------------------------------
                        Center(
                          child: Card(
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            child: Row(
                              children: [
                                Flexible(
                                  flex: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left:2.0),

                                      child: _matchType == 'Default'
                                          ? Icon(Feather.x_circle,
                                          color: Colors.red)
                                          : Icon(
                                        MyAppIcons.check_circle,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),

                                Padding(
                                  padding: const EdgeInsets.only(left:8.0),
                                  child: Text(
                                    'Competition:',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: DropdownButton<String>(
                                    items: [
                                      DropdownMenuItem<String>(
                                        child: Text('Championship'),
                                        value: 'Championship',
                                      ),
                                      DropdownMenuItem<String>(
                                        child: Text('Cup'),
                                        value: 'Cup',
                                      ),
                                      DropdownMenuItem<String>(
                                        child: Text('Friendly'),
                                        value: 'Friendly',
                                      ),
                                      DropdownMenuItem<String>(
                                        child: Text('European'),
                                        value: 'European',
                                      ),
                                      _matchType == 'Default'
                                          ? DropdownMenuItem<String>(
                                              enabled: false,
                                              child:
                                                  Text('Select Competition ..'),
                                              value: 'Default',
                                            )
                                          : DropdownMenuItem<String>(
                                              enabled: false,
                                              child:
                                                  Text('Select Competition ..'),
                                              value: '',
                                            ),
                                    ],
                                    // onTap: ,
                                    onChanged: previewsFieldIsNotNull(_sportType)
                                        ? null
                                        : (value) {
                                            setState(() {
                                              _matchType = value!;
                                              _matchTypeController.text = value;
                                              print(_matchType);
                                            });
                                          },
                                    hint: Text('Select match type'),
                                    value: _matchType,
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 10,
                        ),
                        Divider(),

                        /// ------------------------------------------------------
                        ///                    HOME TEAM
                        /// ------------------------------------------------------
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                child: TextFormField(
                                  initialValue: _homeTeam,
                                  showCursor: true,
                                  readOnly: true,
                                  key: ValueKey(_homeTeam),
                                  decoration: InputDecoration(
                                    labelText: 'Home Team',
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: _homeTeam == 'Default'
                                  ? Icon(Feather.x_circle, color: Colors.red)
                                  : Icon(
                                      MyAppIcons.check_circle,
                                      color: Colors.green,
                                    ),
                            )
                          ],
                        ),

                        SizedBox(
                          height: 10,
                        ),
                        Divider(),

                        /// ------------------------------------------------------
                        ///                    AWAY TEAM
                        /// ------------------------------------------------------
                        Center(
                          child: Card(
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            child: Row(

                              children: [
                                Flexible(
                                  flex: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left:2.0),
                                      child: _awayTeam == 'Default'
                                          ? Icon(Feather.x_circle,
                                          color: Colors.red)
                                          : Icon(
                                        MyAppIcons.check_circle,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Away Team:',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: DropdownButton(
                                    items: _defaultFootballClubsList
                                        .map(
                                          (e) => DropdownMenuItem<String>(
                                            value: e.toString(),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Text(e)
                                              ],
                                            ),
                                          ),
                                        )
                                        .toList(),

                                    /// Disable button if the Sport & Match type are not selected
                                    onChanged:
                                      previewsFieldIsNotNull(_matchType)
                                      ? null
                                        : (value) {
                                            setState(() {
                                              _awayTeam = value.toString();
                                              _awayTeamController.text =
                                                  value.toString();
                                              print(_matchType);
                                            });
                                          },
                                    hint: Text('Select away team'),
                                    //value: _awayTeam
                                    // value: _GetAwayTeamValue,
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 10,
                        ),
                        Divider(),

                        /// ------------------------------------------------------
                        ///                    LOCATION
                        /// ------------------------------------------------------
                        Center(
                          child: Card(
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            child: Row(

                              children: [
                                Flexible(
                                  flex: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left:2.0),
                                      child: _location == 'Default'
                                          ? Icon(Feather.x_circle,
                                          color: Colors.red)
                                          : Icon(
                                        MyAppIcons.check_circle,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Stadium:',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 6.0),
                                  child: DropdownButton(
                                    items: _defaultStadiumList
                                        .map((e) => DropdownMenuItem<String>(
                                              value: e.toString(),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                  Text(e)
                                                ],
                                              ),
                                            ))
                                        .toList(),
                                    onChanged:
                                    previewsFieldIsNotNull(_awayTeam) ? null :
                                        (value) {
                                      setState(() {
                                        _location = value.toString();
                                        _locationController.text =
                                            value.toString();
                                        print(_location);
                                      });
                                    },
                                    hint: Text('Select stadium'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 10,
                        ),

                        Divider(),

                        /// ------------------------------------------------------
                        ///               DATE AND TIME PICKER
                        /// ------------------------------------------------------
                        Center(
                          child: Card(
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            child: Row(

                              children: [
                                Flexible(
                                  flex: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left:2.0),
                                      child: selectedDate == DateTime.now()
                                          ? Icon(Feather.x_circle,
                                          color: Colors.red)
                                          : Icon(
                                        MyAppIcons.check_circle,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Date:',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, top: 5.0, bottom: 5.0),
                                  child: InkWell(
                                    onTap: () {
                                      _selectDate(context);
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 68.0),
                                      child: Container(
                                        width: 110, //_width / 1.7,
                                        height: 40, //_height / 9,
                                        //margin: EdgeInsets.only(top: 10, bottom: 10),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.amber,
                                            width: 0.5,
                                          ),
                                          color: Theme.of(context).accentColor,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: TextFormField(
                                          style: TextStyle(fontSize: 20),
                                          textAlign: TextAlign.center,
                                          enabled: false,
                                          keyboardType: TextInputType.text,
                                          controller: _dateController,
                                          onSaved: (val) {
                                            _setDate = val!;
                                          },
                                          decoration: InputDecoration(
                                              disabledBorder:
                                                  UnderlineInputBorder(
                                                      borderSide:
                                                          BorderSide.none),
                                              // labelText: 'Time',
                                              contentPadding:
                                                  EdgeInsets.only(top: 0.0)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),

                        Center(
                          child: Card(
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            child: Row(
                              children: [
                                Flexible(
                                  flex: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left:2.0),
                                      child: selectedTime == TimeOfDay(hour: 00, minute: 00)
                                          ? Icon(Feather.x_circle,
                                          color: Colors.red)
                                          : Icon(
                                        MyAppIcons.check_circle,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Time:',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 80.0, top: 5.0, bottom: 5.0),
                                  child: InkWell(
                                    onTap: () {
                                      _selectTime(context);
                                    },
                                    child: Container(
                                      //margin: EdgeInsets.only(top: 10),
                                      width: 110, //_width / 1.7,
                                      height: 40,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.amber,
                                          width: 0.5,
                                        ),
                                        color: Theme.of(context).accentColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: TextFormField(
                                        style: TextStyle(fontSize: 20),
                                        textAlign: TextAlign.center,
                                        enabled: false,
                                        onSaved: (val) {
                                          _setTime = val!;
                                        },
                                        keyboardType: TextInputType.text,
                                        controller: _timeController,
                                        decoration: InputDecoration(
                                            disabledBorder:
                                                UnderlineInputBorder(
                                                    borderSide:
                                                        BorderSide.none),
                                            // labelText: 'Time',
                                            contentPadding: EdgeInsets.all(5)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 10,
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.only(left: 6.0),
                          child: userTitle('TICKETS INFORMATION'),
                        ),
                        SizedBox(
                          height: 50,
                          child: Divider(
                            color: Theme.of(context).disabledColor,
                            thickness: 10.0,
                          ),
                        ),

                        /// ------------------------------------------------------
                        ///                   SECTOR A TICKETS - SOUTH
                        /// ------------------------------------------------------

                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).dividerColor,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(5.0),
                                bottomRight: Radius.circular(5.0)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 3.0),
                                child: userTitle('SECTOR: SOUTH'),
                              ),
                              Row(
                                //crossAxisAlignment: CrossAxisAlignment.end,
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'REGULAR',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  Flexible(
                                      flex: 1,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 9),
                                        child: TextFormField(
                                          key: ValueKey('Price'),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Price is missing';
                                            }
                                            return null;
                                          },
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]')),
                                          ],
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                            labelText: 'Price €',
                                          ),
                                          onSaved: (value) {
                                            _sectorARegularPrice = value!;
                                          },
                                        ),
                                      )),
                                  Flexible(
                                      flex: 1,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 9),
                                        child: TextFormField(
                                          key: ValueKey('Quantity'),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Quantity is missing';
                                            }
                                            return null;
                                          },
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]')),
                                          ],
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                            labelText: 'Quantity',
                                          ),
                                          onSaved: (value) {
                                            _sectorARegularQuantity = value!;
                                          },
                                        ),
                                      ))
                                ],
                              ),

                              /// ---------- STUDENT --------------
                              Row(
                                //crossAxisAlignment: CrossAxisAlignment.end,
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'STUDENT',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  Flexible(
                                      flex: 1,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 9),
                                        child: TextFormField(
                                          key: ValueKey('Price'),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Price is missing';
                                            }
                                            return null;
                                          },
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]')),
                                          ],
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                            labelText: 'Price €',
                                          ),
                                          onSaved: (value) {
                                            _sectorAStudentPrice = value!;
                                          },
                                        ),
                                      )),
                                  Flexible(
                                      flex: 1,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 9),
                                        child: TextFormField(
                                          key: ValueKey('Quantity'),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Quantity is missing';
                                            }
                                            return null;
                                          },
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]')),
                                          ],
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                            labelText: 'Quantity',
                                          ),
                                          onSaved: (value) {
                                            _sectorAStudentQuantity = value!;
                                          },
                                        ),
                                      ))
                                ],
                              ),
                            ]),
                          ),
                        ),

                        SizedBox(
                          height: 50,
                          child: Divider(
                            color: Colors.black54,
                            thickness: 2.0,
                          ),
                        ),

                        /// ------------------------------------------------------
                        ///                   SECTOR B -EAST TICKETS
                        /// ------------------------------------------------------

                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).dividerColor,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(5.0),
                                bottomRight: Radius.circular(5.0)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 3.0),
                                child: userTitle('SECTOR: EAST'),
                              ),
                              Row(
                                //crossAxisAlignment: CrossAxisAlignment.end,
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'REGULAR',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  Flexible(
                                      flex: 1,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 9),
                                        child: TextFormField(
                                          key: ValueKey('Price'),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Price is missing';
                                            }
                                            return null;
                                          },
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]')),
                                          ],
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                            labelText: 'Price €',
                                          ),
                                          onSaved: (value) {
                                            _sectorBRegularPrice = value!;
                                          },
                                        ),
                                      )),
                                  Flexible(
                                      flex: 1,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 9),
                                        child: TextFormField(
                                          key: ValueKey('Quantity'),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Quantity is missing';
                                            }
                                            return null;
                                          },
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]')),
                                          ],
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                            labelText: 'Quantity',
                                          ),
                                          onSaved: (value) {
                                            _sectorBRegularQuantity = value!;
                                          },
                                        ),
                                      ))
                                ],
                              ),

                              /// ---------- STUDENT --------------
                              Row(
                                //crossAxisAlignment: CrossAxisAlignment.end,
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'STUDENT',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  Flexible(
                                      flex: 1,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 9),
                                        child: TextFormField(
                                          key: ValueKey('Price'),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Price is missing';
                                            }
                                            return null;
                                          },
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]')),
                                          ],
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                            labelText: 'Price €',
                                          ),
                                          onSaved: (value) {
                                            _sectorBStudentPrice = value!;
                                          },
                                        ),
                                      )),
                                  Flexible(
                                      flex: 1,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 9),
                                        child: TextFormField(
                                          key: ValueKey('Quantity'),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Quantity is missing';
                                            }
                                            return null;
                                          },
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]')),
                                          ],
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                            labelText: 'Quantity',
                                          ),
                                          onSaved: (value) {
                                            _sectorBStudentQuantity = value!;
                                          },
                                        ),
                                      ))
                                ],
                              ),
                            ]),
                          ),
                        ),

                        SizedBox(
                          height: 50,
                          child: Divider(
                            color: Colors.black54,
                            thickness: 2.0,
                          ),
                        ),

                        /// ------------------------------------------------------
                        ///                   SECTOR C - WEST TICKETS
                        /// ------------------------------------------------------

                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).dividerColor,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(5.0),
                                bottomRight: Radius.circular(5.0)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 3.0),
                                child: userTitle('SECTOR: WEST'),
                              ),
                              Row(
                                //crossAxisAlignment: CrossAxisAlignment.end,
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'REGULAR',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  Flexible(
                                      flex: 1,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 9),
                                        child: TextFormField(
                                          key: ValueKey('Price'),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Price is missing';
                                            }
                                            return null;
                                          },
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]')),
                                          ],
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                            labelText: 'Price €',
                                          ),
                                          onSaved: (value) {
                                            _sectorCRegularPrice = value!;
                                          },
                                        ),
                                      )),
                                  Flexible(
                                      flex: 1,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 9),
                                        child: TextFormField(
                                          key: ValueKey('Quantity'),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Quantity is missing';
                                            }
                                            return null;
                                          },
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]')),
                                          ],
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                            labelText: 'Quantity',
                                          ),
                                          onSaved: (value) {
                                            _sectorCRegularQuantity = value!;
                                          },
                                        ),
                                      ))
                                ],
                              ),

                              /// ---------- STUDENT --------------
                              Row(
                                //crossAxisAlignment: CrossAxisAlignment.end,
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'STUDENT',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  Flexible(
                                      flex: 1,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 9),
                                        child: TextFormField(
                                          key: ValueKey('Price'),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Price is missing';
                                            }
                                            return null;
                                          },
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]')),
                                          ],
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                            labelText: 'Price €',
                                          ),
                                          onSaved: (value) {
                                            _sectorCStudentPrice = value!;
                                          },
                                        ),
                                      )),
                                  Flexible(
                                      flex: 1,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 9),
                                        child: TextFormField(
                                          key: ValueKey('Quantity'),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Quantity is missing';
                                            }
                                            return null;
                                          },
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]')),
                                          ],
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                            labelText: 'Quantity',
                                          ),
                                          onSaved: (value) {
                                            _sectorCStudentQuantity = value!;
                                          },
                                        ),
                                      ))
                                ],
                              ),
                            ]),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  AssignUsersTeam(User user) {
    if (user.displayName == 'admin') _homeTeam = 'Anorthosis FC';
    print(_homeTeam);
  }

  void RemoveTeamAsAway() {
    _listFootballClubs.remove(_homeTeam);
    _listBasketabllClubs.remove(_homeTeam);
    _listHandballClubs.remove(_homeTeam);
    _listVolleyClubs.remove(_homeTeam);
  }

  List DisplayAppropriateClubList() {
    List n = ['1'];

    if (_sportType == "Football") {
      return _listFootballClubs;
    } else if (_sportType == "Basketball")
      return _listBasketabllClubs;
    else if (_sportType == "Handball")
      return _listHandballClubs;
    else if (_sportType == "Volley") return _listVolleyClubs;
    return n;
  }

  List DisplayAppropriateStadiumList() {
    List n = ['1'];

    if (_sportType == "Football") {
      return _listFootballStadiums;
    } else if (_sportType == "Basketball")
      return _listBasketballStadiums;
    else if (_sportType == "Handball")
      return _listHandballStadiums;
    else if (_sportType == "Volley") return _listVolleyStadiums;
    return n;
  }

  bool validateMatchDetailsFields() {
    String defaultValue = "Default";
    return ( _sportType != defaultValue && _matchType != defaultValue && _awayTeam != defaultValue
            && _location != defaultValue && selectedDate != DateTime.now() && selectedTime != TimeOfDay(hour: 00, minute: 00) );

  }

  previewsFieldIsNotNull(String previousField) {
    return (previousField == 'Default');
  }
}

Widget userTitle(String title) {
  return Padding(
    //padding: const EdgeInsets.all(5.0),
    padding: const EdgeInsets.only(right: 30.0, bottom: 10.0),
    child: Text(
      title,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
    ),
  );
}

class GradientIcon extends StatelessWidget {
  GradientIcon(
    this.icon,
    this.size,
    this.gradient,
  );

  final IconData icon;
  final double size;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      child: SizedBox(
        width: size * 1.2,
        height: size * 1.2,
        child: Icon(
          icon,
          size: size,
          color: Colors.white,
        ),
      ),
      shaderCallback: (Rect bounds) {
        final Rect rect = Rect.fromLTRB(0, 0, size, size);
        return gradient.createShader(rect);
      },
    );
  }
}
