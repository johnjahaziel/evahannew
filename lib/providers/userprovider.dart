import 'package:flutter/cupertino.dart';

class Userprovider with ChangeNotifier{
  String _userid = '';
  String _roleid = '';

  String get userId => _userid;
  String get roleId => _roleid;

  void setUserId(String id, String role) {
    _userid = id;
    _roleid = role;
    notifyListeners();
  }

  void logout() {
    _userid = '';
    _roleid = '';
    notifyListeners();
  }
}