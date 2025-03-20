import 'package:flutter/material.dart';

import 'main_page.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Katze',
      theme: ThemeData(
          primaryColor: Colors.brown,
          primarySwatch: Colors.brown,
          progressIndicatorTheme: ProgressIndicatorThemeData(
            color: Colors.brown,
          ),
          scaffoldBackgroundColor: Color.fromARGB(255, 244, 232, 193)),
      home: const MainPage(),
    );
  }
}
