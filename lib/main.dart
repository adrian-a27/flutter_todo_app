import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/tasks_page.dart';
import 'screens/agenda_page.dart';
import 'screens/calendar_page.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});
  final mainColor = Colors.deepPurple;

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

    return MaterialApp(
      title: "Todo List",
      theme: themeLight,
      darkTheme: themeDark,
      themeMode: ThemeMode.system,
      home: PrimaryBody(),
    );
  }
}

class PrimaryBody extends StatefulWidget {
  @override
  State<PrimaryBody> createState() => _PrimaryBodyState();
}

class _PrimaryBodyState extends State<PrimaryBody> {
  int selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = AgendaPage();
        break;

      case 1:
        page = TasksPage();
        break;

      case 2:
        page = CalendarPage();
        break;

      case 3:
        page = Placeholder();
        break;

      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return AdaptiveScaffold(
      destinations: [
        NavigationDestination(
            icon: Icon(Icons.view_agenda_outlined),
            selectedIcon: Icon(Icons.view_agenda),
            label: 'Agenda'),
        NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            selectedIcon: Icon(Icons.list_alt),
            label: 'Tasks'),
        NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today),
            label: 'Calendar'),
        NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings')
      ],
      onSelectedIndexChange: (value) {
        setState(() {
          selectedIndex = value;
        });
      },
      selectedIndex: selectedIndex,
      internalAnimations: false,
      body: (_) => SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          color: Theme.of(context).colorScheme.surface,
          child: page,
        ),
      ),
      useDrawer: false,
    );
  }
}
