/// @Author: Alexandros Christou
/// Date: 18Dec21
/// Implementation of Login Screen ..

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppColors.dart';
import 'package:sep21/Provider/DarkTheme.dart';
import 'package:sep21/Services/Global_methods.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import 'forgetPassword.dart';

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

  void _submitForm() async {
    bool isValid = _formKey.currentState!.validate();

    /// return true if the form is valid ..
    FocusScope.of(context).unfocus();

    /// deactivate focus when the user attepmts to click directly to login button ..
    if (isValid) {
      setState(() {
        _isLoading = true;
      });

      _formKey.currentState!.save();
      try {
        await _auth
            .signInWithEmailAndPassword(
                email: _emailAddress.toLowerCase().trim(),
                password: _password.trim())
            .then((value) =>
                Navigator.canPop(context) ? Navigator.pop(context) : null);
      }  on FirebaseAuthException catch (e) {
        gb.authenticationErrorHandler( e.message.toString() , context);
        print('error occured: ' + e.toString());
      } catch(error){
        gb.authenticationErrorHandler( error.toString() , context);
        print('error occured: ' + error.toString());
      }
      finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future <void> _GoogleSignIn() async{
    final gooleSignIn = GoogleSignIn();
    final goolgeAccount = await gooleSignIn.signIn();

    // check if google account is not empty
    if (goolgeAccount != null) {
      // get credentials
      final googleAuthentication = await goolgeAccount.authentication;
      if (googleAuthentication.accessToken != null && googleAuthentication.idToken != null){
        try{
          var date = DateTime.now().toString();
          var dateParse = DateTime.parse(date);
          var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";

          final authResult = await _auth.signInWithCredential(GoogleAuthProvider.credential(
              idToken:  googleAuthentication.idToken, accessToken: googleAuthentication.accessToken));


          await FirebaseFirestore.instance.collection('Users').doc(authResult.user!.uid).set({
            'id': authResult.user!.uid,
            'name': authResult.user!.displayName,
            'email' : authResult.user!.email,
            'phoneNumber' : authResult.user!.phoneNumber,
            'ImageUrl': authResult.user!.photoURL,
            'joinedAt' : formattedDate,

          });
        }
        catch (e){
          gb.authenticationErrorHandler(e.toString(), context);
        }
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
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        //padding: EdgeInsets.all(8.0),
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
                    colors: [Colors.white, MyAppColor.gradiendLStart, MyAppColor.selected, Colors.grey.shade900 ],
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
                // Container(
                //   margin: EdgeInsets.only(top: 80),
                //   height: 120.0,
                //   width: 120,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(20),
                //     image: DecorationImage(
                //       image: NetworkImage(
                //         "https://image.flaticon.com/icons/png/128/869/869636.png"
                //       ),
                //       fit: BoxFit.fill,
                //     ),
                //     shape: BoxShape.rectangle
                //   ),
                // ),

                SizedBox(
                  height: 70,
                ),

                ///  (i) Email Login Form ...
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Center(
                            child:
                                Text('Login', style: TextStyle(fontSize: 65, color:  Colors.white))),
                        SizedBox(
                          height: 60,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextFormField(
                            key: ValueKey('email'),
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
                              // border: const UnderlineInputBorder(),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              filled: true,
                              prefixIcon: Icon(Icons.email),
                              labelText: 'Email Address',
                              fillColor: themeChange.darkTheme ? Theme.of(context).splashColor : Colors.white
                            ),
                            onSaved: (value) {
                              _emailAddress = value!;
                            },
                          ),
                        ),

                        ///  (ii) Password - Login Form ...
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
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
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
                                fillColor: themeChange.darkTheme ? Theme.of(context).splashColor : Colors.white),
                            onSaved: (value) {
                              _password = value!;
                            },
                            obscureText: _obscureText,

                            /// Hide password ..
                            onEditingComplete: _submitForm,
                          ),
                        ),

                        /// ----------------------------------------------------
                        ///                     FORGET PASSWORD
                        /// ----------------------------------------------------
                        Padding(
                          padding: const EdgeInsets.only(left:8.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: TextButton(
                              onPressed: (){ Navigator.pushNamed(context, ForgetPassword.routeName); },
                              child: Text('Forgot password?',
                                  style: TextStyle(
                                      color: themeChange.darkTheme ? Colors.blue.shade100 : Colors.blue.shade900,
                                      decoration: TextDecoration.underline)),
                            ),
                          ),
                        ),
                        // Align(
                        //   alignment: Alignment.topLeft,
                        //   child: Padding(
                        //     //padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                        //     padding: const EdgeInsets.all(5),
                        //     child: TextButton(
                        //       onPressed: (){ Navigator.pushNamed(context, ForgetPassword.routeName); },
                        //       child: Text('Forget password?',
                        //               style: TextStyle(color: Colors.blue.shade900, decoration: TextDecoration.underline)),
                        //     ),
                        //   ),
                        // ),

                        Row(children: [
                          SizedBox(
                            width: 135,
                          ),

                          /// Progress bar indicator
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
                                      Text('Login',
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
                              //style: TextStyle(color: Colors.black54),
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
                                borderSide: BorderSide(width: 2, color: Colors.red),
                                child: Text("Google +"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
