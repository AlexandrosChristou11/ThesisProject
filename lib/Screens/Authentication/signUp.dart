
/// @author: Alexandros Christou
/// Date: 19Dec21
/// Implementation of basic Sign up page for the user
/// In this screen the user will be able to register using
/// his credentials  or by using his/her Google account ..

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppColors.dart';
import 'package:sep21/Services/Global_methods.dart';
import 'package:sep21/Services/Global_methods.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';


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
  GlobalMethods gb = new GlobalMethods();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;


  void _submitForm() async{
    bool isValid = _formKey.currentState!.validate(); /// return true if the form is valid ..
    FocusScope.of(context).unfocus(); /// deactivate focus when the user attepmts to click directly to login button ..
    if (isValid){
      setState(() {
        _isLoading = true;
      });

      _formKey.currentState!.save();
      try{
       await _auth.createUserWithEmailAndPassword(email: _emailAddress.toLowerCase().trim(), password: _password.trim());
      }catch(e){

        gb.authenticationErrorHandler(e.toString(), context);
        print('error occured: ' + e.toString());
      }finally{
        setState(() {
          _isLoading = false;
        });
      }

    }
  }

  void _pickAvatarCamera() async{
      final picker = ImagePicker();
      final pickedImg = await picker.pickImage(source: ImageSource.camera);
      final pickedImgFile = File(pickedImg!.path);
      setState(() {
        _pickedImage = pickedImgFile;
      });

      Navigator.pop(context);
  }

  void _pickAvatarGallery() async{
    final picker = ImagePicker();
    final pickedImg = await await picker.pickImage(source: ImageSource.gallery);
    final pickedImgFile = File(pickedImg!.path);
    setState(() {
      _pickedImage = pickedImgFile;
    });
    Navigator.pop(context);
  }

  void  _removeAvatar(){
    setState(() {
      _pickedImage = null;
    });

    Navigator.pop(context);
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

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:
      SingleChildScrollView(
        child: Stack(
          children: [
            /// ------------------------
            ///  (1) Background Wave ..
            /// ------------------------
            Container(
              height: MediaQuery.of(context).size.height * 0.95,
              child: RotatedBox(
                quarterTurns: 2,
                child: WaveWidget(
                  config: CustomConfig(
                    gradients: [
                      [MyAppColor.gradiendFStart, MyAppColor.gradiendLStart],
                      [MyAppColor.gradiendFEnd, MyAppColor.gradiendLEnd],
                    ],
                    durations: [19440, 10800],
                    heightPercentages: [0.20, 0.25],
                    blur: MaskFilter.blur(BlurStyle.solid, 10),
                    gradientBegin: Alignment.bottomLeft,
                    gradientEnd: Alignment.topRight,

                  ),
                  waveAmplitude: 0,
                  size: Size(
                      double.infinity,
                      double.infinity
                  ),
                ),

              ),
            ),

            SingleChildScrollView(
              child: Column(
                children: [

                  SizedBox(height: 30,),
                  /// ------------------------
                  ///  (2) PROFILE PICTURE
                  /// ------------------------
                  Stack(children: [

                    Container(
                      margin: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                      child: CircleAvatar(radius: 71,
                            backgroundColor: MyAppColor.gradiendLEnd,
                            child: CircleAvatar(
                              radius: 69,
                              /// Determine whether the image avatar is null and display
                              /// the appropriate icon
                              backgroundImage: _pickedImage==null ? null : FileImage(_pickedImage!),
                                backgroundColor: MyAppColor.gradiendFEnd
                            ),
                      ),
                    ),
                    Positioned(
                        top: 120,
                        left: 110,
                        child: RawMaterialButton(
                          elevation: 10,
                          fillColor: MyAppColor.gradiendLEnd,
                          child: Icon(Icons.add_a_photo, color: Colors.white,),
                          padding: EdgeInsets.all(15),
                          shape: CircleBorder(),
                          onPressed: () { 
                            showDialog(context: context, builder:(BuildContext ctx){
                              return AlertDialog(title: Text('Choose Option',
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
                                        onTap: _removeAvatar,
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
                          },))

                  ],),

                  Form(
                      key: _formKey,
                      child:Column(children: [

                        ///  (b) Name signup Form ...
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextFormField(
                            key: ValueKey('name'),
                            validator:
                                (value){
                              if (value!.isEmpty){
                                return 'Name field can not be empty';
                              }else{
                                return null;
                              }
                            },
                            textInputAction: TextInputAction.next,
                            onEditingComplete: ()=> FocusScope.of(context).requestFocus(_emailFocusNode), /// allows the  user to move directly to the email field.
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                border: const UnderlineInputBorder(), filled: true,
                                prefixIcon: Icon(Icons.person),
                                labelText: 'Full Name',
                                fillColor: Theme.of(context).backgroundColor ),
                            onSaved: (value){
                              _fullName = value!;
                            } ,
                          ),
                        ),

                        ///  (b) Email signup Form ...
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextFormField(
                            key: ValueKey('email'),
                            focusNode: _emailFocusNode,
                            validator:
                                (value){
                              if (value!.isEmpty || !value.contains('@')){
                                return 'Please enter a valid email';
                              }else{
                                return null;
                              }
                            },
                            textInputAction: TextInputAction.next,
                            onEditingComplete: ()=> FocusScope.of(context).requestFocus(_passwordFocusNode), /// allows the  user to move directly to the password field.
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                border: const UnderlineInputBorder(), filled: true,
                                prefixIcon: Icon(Icons.email),
                                labelText: 'Email Address',
                                fillColor: Theme.of(context).backgroundColor ),
                            onSaved: (value){
                              _emailAddress = value!;
                            } ,
                          ),
                        ),
                        ///  (c) Password - Signup Form ...
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextFormField(
                            key: ValueKey('password'),
                            validator:
                                (value){
                              if (value!.isEmpty || value.length <7 ){
                                return 'Please enter a valid password';
                              }else{
                                return null;
                              }
                            },
                            keyboardType: TextInputType.emailAddress,
                            focusNode: _passwordFocusNode,
                            decoration: InputDecoration(
                                border: const UnderlineInputBorder(), filled: true,
                                prefixIcon: Icon(Icons.lock),
                                suffixIcon: GestureDetector(onTap:
                                    (){
                                  setState(() {
                                    _obscureText= !_obscureText; /// change the value the boolean expression to hide/show the password
                                  });
                                },
                                  child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off ), /// determine the value of _obscureText varibale and show the appropriate icon
                                ),
                                labelText: 'Password',
                                fillColor: Theme.of(context).backgroundColor ),
                            onSaved: (value){
                              _password = value!;
                            } ,
                            obscureText: _obscureText, /// Hide password ..
                            onEditingComplete: _submitForm,
                          ),
                        ),

                        /// (d) Phone Number - Signup form ..
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextFormField(
                            key: ValueKey('phone'),
                            focusNode: _phoneFocusNode,
                            validator:
                                (value){
                              if (value!.isEmpty){
                                return 'Please enter a valid phone number';
                              }else{
                                return null;
                              }
                            },
                            textInputAction: TextInputAction.next,
                            onEditingComplete: ()=> FocusScope.of(context).requestFocus(_phoneFocusNode), /// allows the  user to move directly to the submit field.
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                border: const UnderlineInputBorder(), filled: true,
                                prefixIcon: Icon(Icons.phone_android),
                                labelText: 'Phone Number',
                                fillColor: Theme.of(context).backgroundColor ),
                            onSaved: (value){
                              _phoneNumber = value! ;
                            } ,
                          ),
                        ),

                        Row(children: [
                          SizedBox(
                            width: 10,
                          ),
                         ///  Progress bar indicator
                         _isLoading ?
                             CircularProgressIndicator()
                             : ElevatedButton(

                            /// Button's rounded border ..
                              style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all(Colors.blue.shade300),
                                  shape:
                                  MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          side: BorderSide(
                                              color: MyAppColor.backgroundColor)))),
                              onPressed: _submitForm,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('Sign up',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600, fontSize: 17)),
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
                              style: TextStyle(color: Colors.black54),
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

                      ],) )
                ],
              ),
            )

          ],
        ),
      )
      ,
    );
  }
}