// lib/main.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/konstanta.dart'; // import baseUrl
import '/login/addpengguna.dart'; // import PenggunaForm

void main() {
  runApp(MaterialApp(
    home: PenggunaForm(),
    debugShowCheckedModeBanner: false,
  ));
}
