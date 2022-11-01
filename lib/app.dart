import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:journal/screens/new.dart';
import 'package:journal/screens/view.dart';
import 'package:journal/screens/list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatefulWidget {
  final SharedPreferences preferences;
  const MyApp({Key? key, required this.preferences}) : super(key: key);

  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);

  static final routes = {
    '/': (context) => JournalEntryListScreen(),
    '/newEntry': (context) => NewEntry(),
    '/viewEntry': (context) => EntryDetailView(),
  };
  @override
  State<MyApp> createState() => _AppState();
}

class _AppState extends State<MyApp> {
  static const THEME_KEY = 'true';
  String get themeKey => widget.preferences.getString(THEME_KEY) ?? 'true';

  void setTheme() {
    setState(() {
      if (MyApp.themeNotifier.value == ThemeMode.dark) {
        widget.preferences.setString(THEME_KEY, 'true');
      } else {}
      MyApp.themeNotifier.value =
          THEME_KEY == 'true' ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      saveThemesOnChange: true,
      loadThemeOnInit: true,
      themes: [
        AppTheme.light(id: 'light'),
        AppTheme.dark(id: 'dark'),
      ],
      child: ThemeConsumer(
        child: Builder(
            builder: (themeContext) => MaterialApp(
                  theme: ThemeProvider.themeOf(themeContext).data,
                  debugShowCheckedModeBanner: false,
                  title: 'Journal',
                  routes: MyApp.routes,
                )),
      ),
    );
  }
}
