import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:journal/app.dart';
import 'package:theme_provider/theme_provider.dart';

Widget settingsDrawer(BuildContext context) {
  final SharedPreferences preferences;
  var controller = ThemeProvider.controllerOf(context);

  bool isDarkMode = false;
  return Drawer(
      child: ListView(children: [
    const SizedBox(
      height: 50,
      child: DrawerHeader(
        child: Text('Settings'),
      ),
    ),
    ListTile(
        leading: Icon(Icons.nightlight_round),
        title: Text('Dark Theme'),
        trailing: Switch(
          value: isDarkMode,
          onChanged: (value) {
            ThemeProvider.controllerOf(context).nextTheme();
          },
          activeTrackColor: Colors.lightGreen,
          activeColor: Colors.green,
        ))
  ]));
}
