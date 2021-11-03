// Stadium Class; takes 4 arguments
// for each stand separately
// @author: Alexandros Christou - 03Nov21

import 'package:flutter/cupertino.dart';

import 'Sector.dart';

class Stadium with ChangeNotifier{

  /// *******************
  /// Member variables
  /// *******************
  late String _name;
  late int _quantity;
  late Sector _north;
  late Sector _south;
  late Sector _west;
  late Sector _east;

  Stadium(this._name, this._quantity, this._north, this._south, this._west,
      this._east);




  /// ***************
  /// Setters & Getters
  /// ***************


  Sector get east => _east;

  Sector get west => _west;

  Sector get south => _south;

  Sector get north => _north;

  int get quantity => _quantity;

  String get name => _name;

  set quantity(int value) {
    _quantity = value;
  }

  set north(Sector value) {
    _north = value;
  }

  set south(Sector value) {
    _south = value;
  }

  set west(Sector value) {
    _west = value;
  }

  set east(Sector value) {
    _east = value;
  }
}
