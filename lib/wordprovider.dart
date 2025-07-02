import 'package:flutter/material.dart';
import 'package:ouroboros/userinfo.dart';
import 'package:provider/provider.dart';

class WordProvider extends ChangeNotifier{
  UserInfo? _user=null;

  String? _accessToken= null;
  String? _refreshToken= null;

  String _selectedTheme="snake";

  String get accessToken => _accessToken!;

  set accessToken(String value) {
    _accessToken = value;
  }

  String get refreshToken => _refreshToken!;

  set refreshToken(String value) {
    _refreshToken = value;
  }

  UserInfo get user => _user!;

  set user(UserInfo value) {
    _user = value;
  }


  String get selectedTheme => _selectedTheme;

  set selectedTheme(String value) {
    _selectedTheme = value;
  }

  void reset() {
    _user = null;
    _accessToken = null;
    _refreshToken = null;
    notifyListeners();
  }

  void changeTheme(String theme) {
    _selectedTheme = theme;
    notifyListeners();
  }

}
