import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/tasks_page.dart';
import 'screens/agenda_page.dart';
import 'screens/calendar_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

const List<String> scopes = [calendar.CalendarApi.calendarEventsScope];
GoogleSignIn _googleSignIn = GoogleSignIn(scopes: scopes);

Future<void> _handleSignIn() async {
  try {
    await _googleSignIn.signIn();
  } catch (error) {
    print(error);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await _handleSignIn();
  print("Sign in complete.");

  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  TodoApp({super.key});

  final mainColor = Colors.indigo;

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      ColorScheme lightColorScheme;
      ColorScheme darkColorScheme;

      if (lightDynamic != null && darkDynamic != null) {
        // On Android S+ devices, use the provided dynamic color scheme.
        // (Recommended) Harmonize the dynamic color scheme' built-in semantic colors.
        lightColorScheme = lightDynamic.harmonized();

        // Repeat for the dark color scheme.
        darkColorScheme = darkDynamic.harmonized();
      } else {
        // Otherwise, use fallback schemes.
        lightColorScheme = ColorScheme.fromSeed(
            seedColor: mainColor, brightness: Brightness.light);
        darkColorScheme = ColorScheme.fromSeed(
            seedColor: mainColor, brightness: Brightness.light);
      }

      return MaterialApp(
        title: "Todo List",
        theme: ThemeData(
            useMaterial3: true,
            fontFamily: GoogleFonts.lexendDeca().fontFamily,
            colorScheme: lightColorScheme),
        darkTheme: ThemeData(
            useMaterial3: true,
            fontFamily: GoogleFonts.lexendDeca().fontFamily,
            colorScheme: darkColorScheme),
        themeMode: ThemeMode.system,
        home: PrimaryBody(),
        debugShowCheckedModeBanner: false,
      );
    });
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
        page = AgendaPage(_googleSignIn);
        break;

      case 1:
        page = TasksPage();
        break;

      case 2:
        page = CalendarPage(_googleSignIn);
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
