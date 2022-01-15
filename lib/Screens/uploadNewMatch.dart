/// Alexandros Christou - 09Jan21
/// Implementation UploadNewMatch Screen
/// In the current screen, the user will be allowed to upload
/// a new match in the Firebase db.

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
  var _awayTeam = '';
  var _dateAndTime = '';
  var _location = '';
  var _sportType = '';
  var _matchType = '';

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
  List _defaultFootballClubsList = ['0'];

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

  Future<void> _trySubmit() async{

    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();

      try{
        if (_pickedImage == null){
          gb.authenticationErrorHandler('Please pick an image', context);
        }else{
          setState(() {
            _isLoading = true;
          });
          final matchId = _uuid.v4(); /// setting a unique id for each match
          final reference = FirebaseStorage.instance.ref('MatchImages').child(matchId + ".jpg");
          await reference.putFile(_pickedImage!);
          _url = await reference.getDownloadURL();

          final User? user = _auth.currentUser;
          final userId = user!.uid;



          await FirebaseFirestore.instance.collection('Matches').doc(matchId).set({
            'MatchId' : matchId,
            'MatchTitle': _matchName,
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
          Navigator.canPop(context) ? Navigator.pop(context) : null;
        }



      }catch(e){

        gb.authenticationErrorHandler(e.toString(), context);
        print('error occurred : ' + e.toString());
      }finally{
        setState(() {
          _isLoading = false;
        });
      }

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
        print (selectedDate.toString());
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

        print (selectedTime.hour.toString() + ":" + selectedTime.minute.toString());
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
                  child: _isLoading ? Center(
                      child:
                      Container(
                          height: 40, width: 40
                          ,child: CircularProgressIndicator())) : Text(
                    'Upload',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                GradientIcon(
                  Feather.upload,
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
                margin: EdgeInsets.all(15),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        // Row(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Flexible(
                        //         flex: 3,
                        //         child: Padding(
                        //           padding: const EdgeInsets.only(right: 9),
                        //           child: TextFormField(
                        //             key: ValueKey('Title'),
                        //             validator: (value) {
                        //               if (!value!.isEmpty) {
                        //                 return 'Please enter a Title ...';
                        //               }
                        //               return null;
                        //             },
                        //             keyboardType: TextInputType.emailAddress,
                        //             decoration: InputDecoration(
                        //               labelText: 'Match Title',
                        //             ),
                        //             onSaved: (value) {
                        //               _matchName = value!;
                        //             },
                        //           ),
                        //         )),
                        //     Flexible(
                        //         flex: 1,
                        //         child: Padding(
                        //           padding: const EdgeInsets.only(right: 9),
                        //           child: TextFormField(
                        //             key: ValueKey('Price'),
                        //             validator: (value) {
                        //               if (!value!.isEmpty) {
                        //                 return 'Price is missing';
                        //               }
                        //               return null;
                        //             },
                        //             inputFormatters: <TextInputFormatter>[
                        //               FilteringTextInputFormatter.allow(
                        //                   RegExp(r'[0-9]')),
                        //             ],
                        //             keyboardType: TextInputType.emailAddress,
                        //             decoration: InputDecoration(
                        //               labelText: 'Price',
                        //             ),
                        //             onSaved: (value) {
                        //               _sectorARegularPrice = value!;
                        //             },
                        //           ),
                        //         ))
                        //   ],
                        // ),
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
                                        color: Theme.of(context).backgroundColor,
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
                                        color:
                                            Theme.of(context).textSelectionColor,
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
                                        color:
                                            Theme.of(context).textSelectionColor,
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

                        /// ------------------------------------------------------
                        ///                    SPORT TYPE
                        /// ------------------------------------------------------
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(

                                child: Padding(
                        padding: const EdgeInsets.only(right: 9),
                                  child: Container(
                              child: TextFormField(
                                  controller: _sportTypeController,
                                  key: ValueKey('Sport Type'),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter the sport type';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Add a new Sport Type',
                                  ),
                                  onSaved: (value) {
                                    _sportType = value!;
                                  },
                              ),
                            ),
                                )),
                            DropdownButton<String>(
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
                             // value: _sportType,
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 10,
                        ),

                        /// ------------------------------------------------------
                        ///                    MATCH TYPE
                        /// ------------------------------------------------------
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 9),
                                  child: Container(
                              child: TextFormField(
                                  controller: _matchTypeController,
                                  key: ValueKey('Match Type'),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter the match type';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Add a new match Type',
                                  ),
                                  onSaved: (value) {
                                    _matchType = value!;
                                  },
                              ),
                            ),
                                )),
                            DropdownButton<String>(
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
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _matchType = value!;
                                  _matchTypeController.text = value;
                                  print(_matchType);
                                });
                              },
                               hint: Text('Select match type'),

                            ),
                          ],
                        ),

                        SizedBox(
                          height: 10,
                        ),

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
                          ],
                        ),

                        SizedBox(
                          height: 10,
                        ),

                        /// ------------------------------------------------------
                        ///                    AWAY TEAM
                        /// ------------------------------------------------------
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Container(
                              child: TextFormField(
                                controller: _awayTeamController,
                                key: ValueKey('Away Team'),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter the away team';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Add away team',
                                ),
                                onSaved: (value) {
                                  _awayTeam = value!;
                                  _matchName = _homeTeam + " VS " + _awayTeam;
                                },
                              ),
                            )),
                            DropdownButton(
                              items: _defaultFootballClubsList
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
                              /// Disable button if the Sport & Match type are not selected
                              onChanged:
                              (_sportType == '' || _matchType == '') ? null
                               :
                                  (value) {
                                setState(() {
                                  _awayTeam = value.toString();
                                  _awayTeamController.text = value.toString();
                                  print(_matchType);
                                });
                              },
                              hint: Text('Select away team'),
                            ),
                          ],
                        ),

                        /// ------------------------------------------------------
                        ///                    LOCATION
                        /// ------------------------------------------------------
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                                flex: 3,
                                child: Container(
                              child: TextFormField(
                                controller: _locationController,
                                key: ValueKey('Location'),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter the location';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Add Stadium',
                                ),
                                onSaved: (value) {
                                  _location = value!;
                                },
                              ),
                            )),
                            DropdownButton(
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
                              onChanged: (value) {
                                setState(() {
                                  _location = value.toString();
                                  _locationController.text = value.toString();
                                  print(_location);
                                });
                              },
                              hint: Text('Select stadium'),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 40,
                        ),

                        /// ------------------------------------------------------
                        ///               DATE AND TIME PICKER
                        /// ------------------------------------------------------
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                                flex: 1,
                          child: Column(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text(
                                    'Choose Date',
                                    style: TextStyle(
                                        fontStyle: FontStyle.values.first,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      _selectDate(context);
                                    },
                                    child: Container(
                                      width: 130,//_width / 1.7,
                                      height: 50, //_height / 9,
                                      margin: EdgeInsets.only(top: 10),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(color: Colors.grey[200]),
                                      child: TextFormField(
                                        style: TextStyle(fontSize: 20),
                                        textAlign: TextAlign.center,
                                        enabled: false,
                                        keyboardType: TextInputType.text,
                                        controller: _dateController,
                                        onSaved: ( val) {
                                          _setDate = val!;
                                        },
                                        decoration: InputDecoration(
                                            disabledBorder:
                                            UnderlineInputBorder(borderSide: BorderSide.none),
                                            // labelText: 'Time',
                                            contentPadding: EdgeInsets.only(top: 0.0)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      'Choose Time',
                                      style: TextStyle(
                                          fontStyle: FontStyle.values.first,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.5),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        _selectTime(context);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(top: 10),
                                        width: 130,//_width / 1.7,
                                        height: 50,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(color: Colors.grey[200]),
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
                                              UnderlineInputBorder(borderSide: BorderSide.none),
                                              // labelText: 'Time',
                                              contentPadding: EdgeInsets.all(5)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                ]),


                        SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 6.0),
                          child: userTitle('TICKETS INFORMATION'),
                        ),
                        SizedBox(
                          height: 50,
                          child:  Divider(
                            color: Theme.of(context).disabledColor,
                            thickness: 10.0,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 3.0),
                          child: userTitle('SECTOR: SOUTH'),
                        ),


                        /// ------------------------------------------------------
                        ///                   SECTOR A TICKETS - SOUTCH
                        /// ------------------------------------------------------
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 1),
                                  child: TextFormField(
                                    initialValue: "REGULAR",
                                    showCursor: true,
                                    readOnly: true,
                                    key: ValueKey('Sector A'),
                                    decoration: InputDecoration(
                                      labelText: 'Ticket Type',
                                    ),

                                  ),
                                )),
                            Flexible(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 9),
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
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      labelText: 'Price €',
                                    ),
                                    onSaved: (value) {
                                      _sectorARegularPrice = value!;
                                    },
                                  ),
                                ))
                            ,Flexible(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 9),
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
                                    keyboardType: TextInputType.emailAddress,
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 1),
                                  child: TextFormField(
                                    initialValue: "STUDENT",
                                    showCursor: true,
                                    readOnly: true,
                                    key: ValueKey('Sector A'),
                                    decoration: InputDecoration(
                                      //labelText: 'Ticket Type',
                                    ),

                                  ),
                                )),
                            Flexible(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 9),
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
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      labelText: 'Price €',
                                    ),
                                    onSaved: (value) {
                                      _sectorAStudentPrice = value!;
                                    },
                                  ),
                                ))
                            ,Flexible(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 9),
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
                                    keyboardType: TextInputType.emailAddress,
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

                        SizedBox(
                          height: 50,
                          child:  Divider(
                            color: Colors.black54,
                            thickness: 2.0,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 3.0),
                          child: userTitle('SECTOR: EAST'),
                        ),


                        /// ------------------------------------------------------
                        ///                   SECTOR B -EAST TICKETS
                        /// ------------------------------------------------------
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 1),
                                  child: TextFormField(
                                    initialValue: "REGULAR",
                                    showCursor: true,
                                    readOnly: true,
                                    key: ValueKey('Sector B'),
                                    decoration: InputDecoration(
                                      labelText: 'Ticket Type',
                                    ),

                                  ),
                                )),
                            Flexible(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 9),
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
                                   // keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      labelText: 'Price €',
                                    ),
                                    onSaved: (value) {
                                      _sectorBRegularPrice = value!;
                                    },
                                  ),
                                ))
                            ,Flexible(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 9),
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
                                    keyboardType: TextInputType.emailAddress,
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 1),
                                  child: TextFormField(
                                    initialValue: "STUDENT",
                                    showCursor: true,
                                    readOnly: true,
                                    key: ValueKey('Sector A'),
                                    decoration: InputDecoration(
                                      //labelText: 'Ticket Type',
                                    ),

                                  ),
                                )),
                            Flexible(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 9),
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
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      labelText: 'Price €',
                                    ),
                                    onSaved: (value) {
                                      _sectorBStudentPrice = value!;
                                    },
                                  ),
                                ))
                            ,Flexible(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 9),
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
                                    keyboardType: TextInputType.emailAddress,
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

                        SizedBox(
                          height: 50,
                          child:  Divider(
                            color: Colors.black54,
                            thickness: 2.0,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 3.0),
                          child: userTitle('SECTOR: WEST'),
                        ),


                        /// ------------------------------------------------------
                        ///                   SECTOR C - WEST TICKETS
                        /// ------------------------------------------------------
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 1),
                                  child: TextFormField(
                                    initialValue: "REGULAR",
                                    showCursor: true,
                                    readOnly: true,
                                    key: ValueKey('Sector C'),
                                    decoration: InputDecoration(
                                      labelText: 'Ticket Type',
                                    ),

                                  ),
                                )),
                            Flexible(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 9),
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
                                    // keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      labelText: 'Price €',
                                    ),
                                    onSaved: (value) {
                                      _sectorCRegularPrice = value!;
                                    },
                                  ),
                                ))
                            ,Flexible(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 9),
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
                                    keyboardType: TextInputType.emailAddress,
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 1),
                                  child: TextFormField(
                                    initialValue: "STUDENT",
                                    showCursor: true,
                                    readOnly: true,
                                    key: ValueKey('Sector C'),
                                    decoration: InputDecoration(
                                      //labelText: 'Ticket Type',
                                    ),

                                  ),
                                )),
                            Flexible(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 9),
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
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      labelText: 'Price €',
                                    ),
                                    onSaved: (value) {
                                      _sectorCStudentPrice = value!;
                                    },
                                  ),
                                ))
                            ,Flexible(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 9),
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
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      labelText: 'Quantity',
                                    ),
                                    onSaved: (value) {
                                      _sectorCStudentQuantity = value!;
                                    },
                                  ),
                                )),
                            SizedBox(
                              height: 150,
                              child:  Divider(
                                color: Theme.of(context).disabledColor,
                                thickness: 10.0,
                              ),
                            ),
                          ],
                        ),


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



}

Widget userTitle (String title){
  return Padding(
    //padding: const EdgeInsets.all(5.0),
    padding: const EdgeInsets.only(right: 30.0, bottom: 10.0),
    child: Text(title,
      style: TextStyle (fontWeight: FontWeight.bold,fontSize: 22),
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

