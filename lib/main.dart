// lib/main.dart
import 'package:flutter/material.dart';
import 'package:jelajahbaturaden/login/reset.dart';
import '/login/addpengguna.dart'; // import PenggunaForm
import '/konstanta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
void main() {
  runApp(MaterialApp(
    home: ResetPasswordForm(),
    debugShowCheckedModeBanner: false,
  ));
}
