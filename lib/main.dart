import 'package:flutter/material.dart';
import 'package:journal/app.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitUp
  ]);
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp(
    preferences: await SharedPreferences.getInstance(),
  ));
}
