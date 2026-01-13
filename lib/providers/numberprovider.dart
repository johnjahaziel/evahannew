import 'package:flutter/material.dart';

class Numberprovider with ChangeNotifier{
  String _numberid = '';

  String get numberId => _numberid;

  void setnumberId(String id) {
    _numberid = id;
    notifyListeners();
  }

  void logout() {
    _numberid = '';
    notifyListeners();
  }
}