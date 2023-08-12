import 'package:flutter/material.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});
  var mainColor = Colors.deepPurple;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Todo List",
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: mainColor, brightness: Brightness.light),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: mainColor, brightness: Brightness.dark),
        ),
        themeMode: ThemeMode.system,
        home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            print('button pressed');
          },
          child: Text("Hello, world!"),
        ),
      ),
    );
  }
}
