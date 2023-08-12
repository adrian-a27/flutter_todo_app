import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:todo_app/widgets/task_group.dart';
import './widgets/page_header.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});
  var mainColor = Colors.purple;

  @override
  Widget build(BuildContext context) {
    var themeLight = ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.lexendDeca().fontFamily,
      colorScheme: ColorScheme.fromSeed(
          seedColor: mainColor, brightness: Brightness.light),
    );
    var themeDark = ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.lexendDeca().fontFamily,
      colorScheme: ColorScheme.fromSeed(
          seedColor: mainColor, brightness: Brightness.dark),
    );

    // var flag = ThemeMode.system;

    return MaterialApp(
        title: "Todo List",
        theme: themeLight,
        darkTheme: themeDark,
        themeMode: ThemeMode.system,
        home: AdaptiveScaffold(
          destinations: [
            NavigationDestination(
                icon: Icon(Icons.view_agenda_outlined), label: 'Agenda'),
            NavigationDestination(icon: Icon(Icons.list_alt), label: 'Tasks'),
            NavigationDestination(
                icon: Icon(Icons.calendar_today), label: 'Calendar'),
            NavigationDestination(
                icon: Icon(Icons.settings_outlined), label: 'Settings')
          ],
          selectedIndex: 1,
          body: (_) => Container(
              color: themeDark.colorScheme.surface,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: TasksPage(),
              )),
          useDrawer: false,
        ));
  }
}

class TasksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PageHeader(text: "Tasks"),
        TaskGroup(heading: "Today", tasks: [
          "This is a task",
          "This is another task",
          "Finish the other tasks"
        ]),
        TaskGroup(
            heading: "Tomorrow",
            tasks: ["Just do the other stuff first", "Don't worry about this"])
      ],
    );
  }
}
