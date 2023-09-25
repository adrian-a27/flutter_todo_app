import 'package:flutter/material.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as gcal;
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/event_widget.dart';
import '../models/event.dart';

class GoogleApiController {
  static final List<String> _scopes = [
    gcal.CalendarApi.calendarEventsScope,
    gcal.CalendarApi.calendarReadonlyScope
  ];

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: _scopes);
  late GoogleSignInAccount? _googleUser;
  UserCredential? _userCredential;
  late Future<UserCredential> _userCredentialFuture;
  gcal.CalendarApi? _calendarApi;

  /*
    Setup functions
  */

  GoogleApiController._create();

  static Future<GoogleApiController> create() async {
    GoogleApiController googleApiController = GoogleApiController._create();

    // Trigger the authentication flow
    await googleApiController._signInWithGoogle();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleApiController._googleUser?.authentication;

    print(googleAuth?.accessToken ?? "No accessToken");
    print(googleAuth?.idToken ?? "No idToken");

    // Create a new credential
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    googleApiController._userCredentialFuture =
        FirebaseAuth.instance.signInWithCredential(credential);

    return googleApiController;
  }

  Future<void> _signInWithGoogle() async {
    _googleUser = await _googleSignIn.signInSilently();
    if (_googleUser == null) {
      // FIXME: This isn't good practice on the web, need to use renderButton
      _googleUser = await _googleSignIn.signIn();

      print("Sign in complete.");
    } else {
      // Use the cached access token to check if we have access to the scopes
      if (!(await _googleSignIn.canAccessScopes(_scopes))) {
        await _googleSignIn.requestScopes(_scopes);
      }

      print("Signed in silently");
    }
  }

  Future<UserCredential> get userCredential async {
    // Derives the userCredential from the GoogleApiController
    _userCredential ??= await _userCredentialFuture;
    print("USER_CRED: $_userCredential");
    return _userCredential!;
  }

  /*
    Calendar functions
  */

  Future<gcal.CalendarApi> get calendarApi async {
    if (_calendarApi == null) {
      var client = await _googleSignIn.authenticatedClient();
      if (client == null) print("Null client!");

      // Cache the client
      _calendarApi = gcal.CalendarApi(client!);
    }

    return _calendarApi!;
  }

  Future<List<Event>> getAllEvents() async {
    // Only need events from now onwards
    print("getAllEvents called for ${_googleSignIn.currentUser!.email}");

    // List to hold all the get event futures
    List<Future<List<Event>>> getEventFutures = [];

    List<gcal.CalendarListEntry> calListItems = await (await calendarApi)
        .calendarList
        .list()
        .then((gcal.CalendarList calList) => calList.items!);

    // Set up the get events futures
    for (gcal.CalendarListEntry cal in calListItems) {
      var colorString = "ff${cal.backgroundColor!.replaceAll('#', '')}";

      // Set up event retrievals
      getEventFutures.add((await calendarApi)
          .events
          .list(cal.id!, timeMin: DateTime.now(), singleEvents: true)
          .then((gcal.Events events) {
        List<Event> eventList = [
          for (gcal.Event event in events.items!)
            Event.fromGoogleCalendarEvent(event)
        ];

        for (Event event in eventList) {
          event.calendarName = cal.summary!;
          event.eventColor = Color(int.parse(colorString, radix: 16));
        }

        return eventList;
      }));
    }

    // Combine all get event futures into one future
    List<Event> eventList = await Future.wait<List<Event>>(getEventFutures)
        .then((List<List<Event>> value) =>
            value.expand((List<Event> eventList) => eventList).toList());

    return eventList;
  }

  // TODO: Handle potential error for this call
  // TODO: Add pagnation??
  Future<Map<DateTime, List<EventWidget>>> getEvents(
      {DateTime? timeMin, DateTime? timeMax}) async {
    print("getEvents called for ${_googleSignIn.currentUser!.email}");

    // List to hold all the get event futures
    List<Future<List<Event>>> getEventFutures = [];

    List<gcal.CalendarListEntry> calListItems = await (await calendarApi)
        .calendarList
        .list()
        .then((gcal.CalendarList calList) => calList.items!);

    // Set up the get events futures
    for (gcal.CalendarListEntry cal in calListItems) {
      var colorString = "ff${cal.backgroundColor!.replaceAll('#', '')}";

      // Set up event retrievals
      getEventFutures.add((await calendarApi)
          .events
          .list(cal.id!, timeMin: DateTime.now(), singleEvents: true)
          .then((gcal.Events events) {
        List<Event> eventList = [
          for (gcal.Event event in events.items!)
            Event.fromGoogleCalendarEvent(event)
        ];

        for (Event event in eventList) {
          event.calendarName = cal.summary!;
          event.eventColor = Color(int.parse(colorString, radix: 16));
        }

        return eventList;
      }));
    }

    // Combine all get event futures into one future
    List<Event> eventList = await Future.wait<List<Event>>(getEventFutures)
        .then((List<List<Event>> value) =>
            value.expand((List<Event> eventList) => eventList).toList());

    // Group each event into a list of other events that happen that day
    final Map<DateTime, List<EventWidget>> groups = _groupByDate(eventList);

    return groups;
  }

  Map<DateTime, List<EventWidget>> _groupByDate(List<Event> eventList) {
    // Map to be returned
    Map<DateTime, List<Event>> groups = {};

    for (Event event in eventList) {
      DateTime eventStartDate = event.start.toLocal();
      DateTime date = DateTime(
          eventStartDate.year, eventStartDate.month, eventStartDate.day);

      // // Create event widget, but use the mapping to get the proper name.
      // EventWidget eventWidget = EventWidget(event);

      if (groups.containsKey(date)) {
        groups[date]!.add(event);
      } else {
        groups[date] = [event];
      }
    }

    groups.forEach(
        (key, value) => value.sort((a, b) => a.start.compareTo(b.start)));

    Map<DateTime, List<EventWidget>> widgetGroups = {};

    for (var entry in groups.entries) {
      List<EventWidget> newValue =
          entry.value.map((Event event) => EventWidget(event)).toList();
      widgetGroups[entry.key] = newValue;
    }

    return widgetGroups;
  }
}
