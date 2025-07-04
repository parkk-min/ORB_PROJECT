import 'package:flutter/material.dart';
import 'package:ouroboros/userinfo.dart';

class WordProvider extends ChangeNotifier{
  List<Map<String, dynamic>>? _history;

  bool _loginFlag=false;
  String? _fakeUser;

  UserInfo? _user;

  String? _accessToken;
  String? _refreshToken;

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


  bool get loginFlag => _loginFlag;

  set loginFlag(bool value) {
    _loginFlag = value;
  }

  void loginFlagFalse() {
    _loginFlag = false;
    notifyListeners();
  }

  void loginFlagTrue() {
    _loginFlag = true;
    notifyListeners();
  }

  String get fakeUser => _fakeUser!;

  set fakeUser(String value) {
    _fakeUser = value;
  }

  List<Map<String, dynamic>> get history => _history!;

  set history(List<Map<String, dynamic>> value) {
    _history = value;
  }

  void updateHistory(List<Map<String, dynamic>> newHistory) {
    _history = newHistory;
    notifyListeners();
  }

}
