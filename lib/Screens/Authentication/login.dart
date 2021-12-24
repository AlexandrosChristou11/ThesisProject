/// @Author: Alexandros Christou
/// Date: 18Dec21
/// Implementation of Login Screen ..

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppColors.dart';
import 'package:sep21/Services/Global_methods.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class LoginScreen extends StatefulWidget {

  static const routName = '\LoginScreen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _emailAddress = '';
  String _password = '';
  bool _obscureText = true;
  final FocusNode _passwordFocusNode = FocusNode();
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
        await _auth.
        signInWithEmailAndPassword(email: _emailAddress.toLowerCase().trim(), password: _password.trim());
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

  @override
  void dispose() {
    _passwordFocusNode.dispose();
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
              /// ------------------------
              ///  (2) Image Login ..
              /// ------------------------
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 80),
                    height: 120.0,
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: NetworkImage(
                          "https://image.flaticon.com/icons/png/128/869/869636.png"
                        ),
                        fit: BoxFit.fill,
                      ),
                      shape: BoxShape.rectangle
                    ),
                  ),
                  SizedBox(height: 30,),
                  ///  (i) Email Login Form ...
                  Form(
                      key: _formKey,
                      child:Column(children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextFormField(
                            key: ValueKey('email'),
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
                        ///  (ii) Password - Login Form ...
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
                        Row(children: [
                          SizedBox(
                            width: 10,
                          ),

                          /// Progress bar indicator
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
                                      Text('Login',
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
              )

            ],
          ),
        )
      ,
    );
  }
}
