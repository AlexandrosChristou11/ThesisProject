
/// Sector class
/// @author: Alexandros Christou - 03Nov21
///

import 'package:flutter/cupertino.dart';

class Sector with ChangeNotifier{

  /// *****************
  /// Member Variables
  /// *****************
  String _name;
  int _quantity;

  Sector(this._name, this._quantity);

  /// ***************
  /// Setters & Getters
  /// ***************
  int get quantity => _quantity;

  String get name => _name;

  set quantity(int value) {
    _quantity = value;
  }

  set name(String value) {
    _name = value;
  }
}