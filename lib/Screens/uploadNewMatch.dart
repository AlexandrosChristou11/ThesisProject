/// Alexandros Christou - 09Jan21
/// Implementation UploadNewMatch Screen
/// In the current screen, the user will be allowed to upload
/// a new match in the Firebase db.

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppColors.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

class UploadMatchForm extends StatefulWidget {
  static const routeName = '/UploadMatchForm';

  @override
  _UploadMatchFormState createState() => _UploadMatchFormState();
}

class _UploadMatchFormState extends State<UploadMatchForm> {
  final _formKey = GlobalKey<FormState>();

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

  final TextEditingController _sportTypeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _matchTypeController = TextEditingController();
  final TextEditingController _awayTeamController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;
  String _userId = "";

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

  File? _picketImage;
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

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      print(_matchName);
      print(_homeTeam);
      print(_awayTeam);
      print(_dateAndTime);
      print(_location);
      print(_sectorAStudentQuantity);
      print(_sectorAStudentPrice);
      print(_sectorARegularQuantity);
      print(_sectorARegularPrice);
    }
  }

  void _pickImageCamera() async {
    final picker = ImagePicker();
    final pickedImage =
        await picker.getImage(source: ImageSource.camera, imageQuality: 40);
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      _picketImage = pickedImageFile;
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
      _picketImage = pickedImageFile!;
    });
    // widget.imagePickFn(pickedImageFile);
  }

  void _removeImage() {
    setState(() {
      _picketImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    _userId = user!.uid;
    AssignUsersTeam(user);
    RemoveTeamAsAway();

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
                  child: Text(
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 9),
                                child: TextFormField(
                                  key: ValueKey('Title'),
                                  validator: (value) {
                                    if (!value!.isEmpty) {
                                      return 'Please enter a Title ...';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    labelText: 'Match Title',
                                  ),
                                  onSaved: (value) {
                                    _matchName = value!;
                                  },
                                ),
                              )),
                          Flexible(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 9),
                                child: TextFormField(
                                  key: ValueKey('Price'),
                                  validator: (value) {
                                    if (!value!.isEmpty) {
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
                                    labelText: 'Price',
                                  ),
                                  onSaved: (value) {
                                    _sectorARegularPrice = value!;
                                  },
                                ),
                              ))
                        ],
                      ),
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
                            child: this._picketImage == null
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
                                        this._picketImage!,
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
                            value: _sportType,
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
                                  if (!value!.isEmpty) {
                                    return 'Please enter the match type';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Add a new match Type',
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
                            // hint: Text('Select sport type'),

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
                                if (!value!.isEmpty) {
                                  return 'Please enter the away team';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Add away team',
                              ),
                              onSaved: (value) {
                                _awayTeam = value!;
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
                            onChanged: (value) {
                              setState(() {
                                _awayTeam = value.toString();
                                _awayTeamController.text = value.toString();
                                print(_matchType);
                              });
                            },
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
                                if (!value!.isEmpty) {
                                  return 'Please enter the location';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Add Stadium',
                              ),
                              onSaved: (value) {
                                _awayTeam = value!;
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
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 9),
                                child: TextFormField(
                                  key: ValueKey('Title'),
                                  validator: (value) {
                                    if (!value!.isEmpty) {
                                      return 'Please enter a Title ...';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    labelText: 'Match Title',
                                  ),
                                  onSaved: (value) {
                                    _matchName = value!;
                                  },
                                ),
                              )),
                          Flexible(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 9),
                                child: TextFormField(
                                  key: ValueKey('Price'),
                                  validator: (value) {
                                    if (!value!.isEmpty) {
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
                                    labelText: 'Price',
                                  ),
                                  onSaved: (value) {
                                    _sectorARegularPrice = value!;
                                  },
                                ),
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      )
                    ],
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
