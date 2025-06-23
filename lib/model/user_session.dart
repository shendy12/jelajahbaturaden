import 'package:flutter/material.dart';

class UserSession extends ChangeNotifier {
  int? _userId;
  String? _username;
  String? _role; 

  int? get userId => _userId;
  String? get username => _username;
  String? get role => _role;

  void setSession({required int id, required String name, String? userRole}) {
    _userId = id;
    _username = name;
    _role = userRole;
    notifyListeners(); 
  }

  void clearSession() {
    _userId = null;
    _username = null;
    _role = null;
    notifyListeners();
  }

  bool get isLoggedIn => _userId != null;
}