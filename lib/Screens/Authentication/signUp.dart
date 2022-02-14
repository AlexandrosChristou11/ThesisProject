/// @author: Alexandros Christou
/// Date: 19Dec21
/// Implementation of basic Sign up page for the user
/// In this screen the user will be able to register using
/// his credentials  or by using his/her Google account ..

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppColors.dart';
import 'package:sep21/Provider/DarkTheme.dart';
import 'package:sep21/Screens/Authentication/Policy.dart';
import 'package:sep21/Services/Global_methods.dart';
import 'package:sep21/Services/Global_methods.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart' show rootBundle;

class SingUpScreen extends StatefulWidget {
  static const routName = '\SingUpScreen';
  const SingUpScreen({Key? key}) : super(key: key);

  @override
  _SingUpScreenState createState() => _SingUpScreenState();
}

class _SingUpScreenState extends State<SingUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String _emailAddress = '';
  String _password = '';
  String _fullName = '';
  late String _phoneNumber;
  bool _obscureText = true;
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  File? _pickedImage;
  late String _url;
  GlobalMethods gb = new GlobalMethods();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool _agree = false;

  void _submitForm() async {
    bool isValid = _formKey.currentState!.validate();

    /// return true if the form is valid ..
    FocusScope.of(context).unfocus();

    /// deactivate focus when the user attempts to click directly to login button ..
    var date = DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
    if (isValid) {
      _formKey.currentState!.save();
      try {
        /// Image validator
        if (_pickedImage == null) {
          gb.authenticationErrorHandler('Please pick an image', context);
        } else {
          setState(() {
            _isLoading = true;
          });

          /// Checkbox validator - Agree Terms & Conditions
          if (_agree == false) {
            gb.authenticationErrorHandler(
                'You need to agree the Terms & Conditions of CY-Seating in order to use the application.',
                context);
          } else {
            final reference = FirebaseStorage.instance
                .ref('UsersImages')
                .child(_fullName + ".jpg");
            await reference.putFile(_pickedImage!);
            _url = await reference.getDownloadURL();

            await _auth.createUserWithEmailAndPassword(
                email: _emailAddress.toLowerCase().trim(),
                password: _password.trim());
            final User? user = _auth.currentUser;
            final userId = user!.uid;
            user.updateProfile(displayName: _fullName, photoURL: _url);
            // user.updatePhotoURL(_url);
            user.reload();
            await FirebaseFirestore.instance.collection('Users')
                .doc(userId)
                .set({
              'id': userId,
              'name': _fullName,
              'email': _emailAddress,
              'phoneNumber': _phoneNumber,
              'ImageUrl': _url,
              'joinedAt': formattedDate,
            });
            Navigator.canPop(context) ? Navigator.pop(context) : null;
          }
          }
        } catch (e) {
        gb.authenticationErrorHandler(e.toString(), context);
        print('error occurred : ' + e.toString());
      } finally {
        setState(() {
          _isLoading = false;
        });
      }

    }
  }

  void _pickAvatarCamera() async {
    final picker = ImagePicker();
    final pickedImg = await picker.pickImage(source: ImageSource.camera);
    final pickedImgFile = File(pickedImg!.path);
    setState(() {
      _pickedImage = pickedImgFile;
    });

    Navigator.pop(context);
  }

  void _pickAvatarGallery() async {
    final picker = ImagePicker();
    final pickedImg = await await picker.pickImage(source: ImageSource.gallery);
    final pickedImgFile = File(pickedImg!.path);
    setState(() {
      _pickedImage = pickedImgFile;
    });
    Navigator.pop(context);
  }

  void _removeAvatar() {
    setState(() {
      _pickedImage = null;
    });

    Navigator.pop(context);
  }
  String dataFromFile = "";
  Future<void> readText() async {
    final String response;
    response = await rootBundle.loadString('assets/Policy/policy.txt');
    setState(() {
      dataFromFile = response;
    });
  }
  Future<void> _GoogleSignIn() async {
    final gooleSignIn = GoogleSignIn();
    final goolgeAccount = await gooleSignIn.signIn();

    // check if google account is not empty
    if (goolgeAccount != null) {
      // get credentials
      final googleAuthentication = await goolgeAccount.authentication;
      if (googleAuthentication.accessToken != null &&
          googleAuthentication.idToken != null) {
        try {
          var date = DateTime.now().toString();
          var dateParse = DateTime.parse(date);
          var formattedDate =
              "${dateParse.day}-${dateParse.month}-${dateParse.year}";

          final authResult = await _auth.signInWithCredential(
              GoogleAuthProvider.credential(
                  idToken: googleAuthentication.idToken,
                  accessToken: googleAuthentication.accessToken));

          await FirebaseFirestore.instance
              .collection('Users')
              .doc(authResult.user!.uid)
              .set({
            'id': authResult.user!.uid,
            'name': authResult.user!.displayName,
            'email': authResult.user!.email,
            'phoneNumber': authResult.user!.phoneNumber,
            'ImageUrl': authResult.user!.photoURL,
            'joinedAt': formattedDate,
          });
        } catch (e) {
          gb.authenticationErrorHandler(e.toString(), context);
        }
      }
    }
  }


  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    GlobalMethods globalMethods = GlobalMethods();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            /// ------------------------
            ///  (1) Background Wave ..
            /// ------------------------
            Container(
              height: MediaQuery.of(context).size.height / 0.82,
              child: RotatedBox(
                quarterTurns: 10,
                child: WaveWidget(
                  config: CustomConfig(
                    colors: [
                      Colors.white,
                      MyAppColor.gradiendLStart,
                      MyAppColor.selected,
                      Colors.grey.shade900
                    ],
                    // gradients: [
                    //   [MyAppColor.gradiendFStart, MyAppColor.gradiendLStart],
                    //   [MyAppColor.gradiendFEnd, MyAppColor.gradiendLEnd],
                    // ],
                    // durations: [19440, 10800],
                    durations: [35000, 11000, 10800, 6000],
                    //  heightPercentages: [0.20, 0.25],
                    heightPercentages: [0.01, 0.02, 0.03, 0.1],
                    blur: MaskFilter.blur(BlurStyle.solid, 10),

                    // gradientBegin: Alignment.bottomLeft,
                    //gradientEnd: Alignment.topRight,
                  ),
                  heightPercentange: 0.2,
                  waveAmplitude: 0,
                  size: Size(double.infinity, double.infinity),
                ),
              ),
            ),

            SingleChildScrollView(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),

                  /// ------------------------
                  ///  (2) PROFILE PICTURE
                  /// ------------------------
                  Stack(
                    children: [
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                        child: CircleAvatar(
                          radius: 71,
                          backgroundColor: MyAppColor.gradiendLEnd,
                          child: CircleAvatar(
                              radius: 69,

                              /// Determine whether the image avatar is null and display
                              /// the appropriate icon
                              backgroundImage: _pickedImage == null
                                  ? null
                                  : FileImage(_pickedImage!),
                              backgroundColor: MyAppColor.white),
                        ),
                      ),
                      Positioned(
                          top: 120,
                          left: 110,
                          child: RawMaterialButton(
                            elevation: 10,
                            fillColor: MyAppColor.gradiendLEnd,
                            child: Icon(
                              Icons.add_a_photo,
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.all(15),
                            shape: CircleBorder(),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext ctx) {
                                    return AlertDialog(
                                      backgroundColor: themeChange.darkTheme
                                          ? Colors.white
                                          : Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                      title: Text(
                                        'Choose Option',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: MyAppColor.gradiendLStart),
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
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Icon(
                                                      Icons.camera,
                                                      color: Colors.blueGrey,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Camera',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: MyAppColor.title,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  )
                                                ],
                                              ),
                                            ),

                                            /// (2) Select from Gallery ...
                                            InkWell(
                                              onTap: _pickAvatarGallery,
                                              splashColor: Colors.blueGrey,
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Icon(
                                                      Icons.image,
                                                      color: Colors.blueGrey,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Gallery',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: MyAppColor.title,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  )
                                                ],
                                              ),
                                            ),

                                            /// (3) Remove Avatar Image ..
                                            InkWell(
                                              onTap: _removeAvatar,
                                              splashColor: Colors.red,
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Icon(
                                                      Icons.remove_circle,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Remove',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: MyAppColor.title,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            },
                          ))
                    ],
                  ),

                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          ///  (b) Name signup Form ...
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: TextFormField(
                              key: ValueKey('name'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Name field can not be empty';
                                } else {
                                  return null;
                                }
                              },
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => FocusScope.of(context)
                                  .requestFocus(_emailFocusNode),

                              /// allows the  user to move directly to the email field.
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                filled: true,
                                prefixIcon: Icon(Icons.person),
                                labelText: 'Full Name',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                fillColor: themeChange.darkTheme
                                    ? Theme.of(context).splashColor
                                    : Colors.white,
                              ),
                              onSaved: (value) {
                                _fullName = value!;
                              },
                            ),
                          ),

                          ///  (b) Email signup Form ...
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: TextFormField(
                              key: ValueKey('email'),
                              focusNode: _emailFocusNode,
                              validator: (value) {
                                if (value!.isEmpty || !value.contains('@')) {
                                  return 'Please enter a valid email';
                                } else {
                                  return null;
                                }
                              },
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => FocusScope.of(context)
                                  .requestFocus(_passwordFocusNode),

                              /// allows the  user to move directly to the password field.
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                filled: true,
                                prefixIcon: Icon(Icons.email),
                                labelText: 'Email Address',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                fillColor: themeChange.darkTheme
                                    ? Theme.of(context).splashColor
                                    : Colors.white,
                              ),
                              onSaved: (value) {
                                _emailAddress = value!;
                              },
                            ),
                          ),

                          ///  (c) Password - Signup Form ...
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: TextFormField(
                              key: ValueKey('password'),
                              validator: (value) {
                                if (value!.isEmpty || value.length < 7) {
                                  return 'Please enter a valid password';
                                } else {
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.emailAddress,
                              focusNode: _passwordFocusNode,
                              decoration: InputDecoration(
                                filled: true,
                                prefixIcon: Icon(Icons.lock),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _obscureText = !_obscureText;

                                      /// change the value the boolean expression to hide/show the password
                                    });
                                  },
                                  child: Icon(_obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off),

                                  /// determine the value of _obscureText varibale and show the appropriate icon
                                ),
                                labelText: 'Password',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                fillColor: themeChange.darkTheme
                                    ? Theme.of(context).splashColor
                                    : Colors.white,
                              ),
                              onSaved: (value) {
                                _password = value!;
                              },
                              obscureText: _obscureText,

                              /// Hide password ..
                              onEditingComplete: _submitForm,
                            ),
                          ),

                          /// (d) Phone Number - Signup form ..
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: TextFormField(
                              key: ValueKey('phone'),
                              focusNode: _phoneFocusNode,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a valid phone number';
                                } else {
                                  return null;
                                }
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],

                              /// restricts phone number fields only as numbers ..
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => FocusScope.of(context)
                                  .requestFocus(_phoneFocusNode),

                              /// allows the  user to move directly to the submit field.
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                filled: true,
                                prefixIcon: Icon(Icons.phone_android),
                                labelText: 'Phone Number',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                fillColor: themeChange.darkTheme
                                    ? Theme.of(context).splashColor
                                    : Colors.white,
                              ),
                              onSaved: (value) {
                                _phoneNumber = value!;
                              },
                            ),
                          ),
                          Row(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Theme(
                                  data: ThemeData(
                                    primarySwatch: Colors.blue,
                                    unselectedWidgetColor: Colors.white, // Your color
                                  ),
                                  child: Checkbox(
                                    checkColor: Colors.white,
                                    activeColor: Colors.blue,
                                    value: _agree,

                                    onChanged: (value) {
                                      setState(() {
                                        _agree = value ?? false;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextButton(
                                  onPressed: (){
                                    globalMethods.getApplicationTermsAndPolicy(context);},
                                  child: Text(
                                    'I Agree to the Terms of Service and Privacy Policy of CY-Seating',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.blue.shade100,
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Row(children: [
                            SizedBox(
                              width: 120,
                              height: 50,
                            ),

                            ///  Progress bar indicator
                            _isLoading
                                ? CircularProgressIndicator()
                                : ElevatedButton(

                                    /// Button's rounded border ..
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.blue.shade300),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                side: BorderSide(
                                                    color: MyAppColor
                                                        .backgroundColor)))),
                                    onPressed: _submitForm,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text('Sign up',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 17)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Feather.user,
                                          size: 17,
                                        )
                                      ],
                                    )),
                            SizedBox(
                              width: 10,
                            ),

                            SizedBox(
                              width: 10,
                            ),
                          ]),
                          SizedBox(height: 40),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Divider(
                                    color: Colors.white,
                                    thickness: 2,
                                  ),
                                ),
                              ),
                              Text(
                                "Or continue with",
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Divider(
                                    color: Colors.white,
                                    thickness: 2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              /// (3) Google sign in ...
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: OutlineButton(
                                  onPressed: _GoogleSignIn,
                                  shape: StadiumBorder(),
                                  highlightedBorderColor: Colors.red.shade200,

                                  /// Border color will change once its clicked. .
                                  borderSide:
                                      BorderSide(width: 2, color: Colors.red),
                                  child: Text("Google +"),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }


}
