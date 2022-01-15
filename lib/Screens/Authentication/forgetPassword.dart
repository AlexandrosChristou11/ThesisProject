/// @author: Alexandros Christou
/// Date: 15Jan21
/// Implementation of 'Forget Password' Screen
/// The current screen will be prompt when the 'forget password?'
/// textbutton will be pressed. The operations for retrieving the old password
/// will be handled in this class

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sep21/Consts/my_custom_icons/MyAppColors.dart';
import 'package:sep21/Services/Global_methods.dart';
import 'package:fluttertoast/fluttertoast.dart';


class ForgetPassword extends StatefulWidget {

  static const routeName = '/ForgetPassword';

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  String _emailAddress = '';
  final _formKey = GlobalKey<FormState>();
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
        await _auth.sendPasswordResetEmail(email: _emailAddress.trim().toLowerCase());
         Fluttertoast.showToast(
            msg: "An email has been sent",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0
        );
        await Navigator.canPop(context) ? Navigator.pop(context) : null;
      }catch(e){
        gb.authenticationErrorHandler(e.toString(), context);
      }finally{
        setState(() {
          _isLoading = false;
        });
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Forget Password',
                 style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          ),
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
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
      ),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: _isLoading ?
                Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(color: Colors.blue.shade800 ))
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
                                color: Theme.of(context).cardColor)))),
                onPressed: _submitForm,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Reset Password',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 17)),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Entypo.key,
                      size: 17,
                    )
                  ],
                )),
          ),

        ],
      ),
    );
  }
}
