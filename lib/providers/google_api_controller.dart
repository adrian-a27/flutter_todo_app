import 'package:flutter/material.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as gcal;
import '../widgets/event.dart';

class GoogleApiController {
  static final List<String> _scopes = [
    gcal.CalendarApi.calendarEventsScope,
    gcal.CalendarApi.calendarReadonlyScope
  ];

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: _scopes);
  gcal.CalendarApi? _calendarApi;

  /*
    Setup functions
  */

  GoogleApiController._create();

  static Future<GoogleApiController> create() async {
    GoogleApiController newGoogleApiController = GoogleApiController._create();
    await newGoogleApiController._signInWithGoogle();
    return newGoogleApiController;
  }

  Future<void> _signInWithGoogle() async {
    if (await _googleSignIn.signInSilently() == null) {
      try {
        // FIXME: This isn't good practice on the web, need to use renderButton
        await _googleSignIn.signIn();
      } catch (error) {
        print(error);
      }
      print("Sign in complete.");
    } else {
      // Use the cached access token to check if we have access to the scopes
      if (!(await _googleSignIn.canAccessScopes(_scopes))) {
        await _googleSignIn.requestScopes(_scopes);
      }

      print("Signed in silently");
    }
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

  // TODO: Handle potential error for this call
  // TODO: Add pagnation??
  Future<Map<DateTime, List<Event>>> getEvents(
      {DateTime? timeMin, DateTime? timeMax}) async {
    print("getEvents called for ${_googleSignIn.currentUser!.email}");

    // List to hold all the get event futures
    List<Future<List<(gcal.Event, String)>>> getEventFutures = [];

    // Map of calendarID to backgroundColor
    Map<String, Color> calendarIDToColorMapping = {};
    // Map of calendarID to name
    Map<String, String> calendarIDToNameMapping = {};

    List<gcal.CalendarListEntry> calListItems = await (await calendarApi)
        .calendarList
        .list()
        .then((gcal.CalendarList calList) => calList.items!);

    // Create a mapping of calendarID to name and calendarID to color
    // and await it because it sets up the get events futures
    for (gcal.CalendarListEntry cal in calListItems) {
      var colorString = "ff${cal.backgroundColor!.replaceAll('#', '')}";

      // Fill in mappings
      calendarIDToColorMapping[cal.id!] =
          Color(int.parse(colorString, radix: 16));
      calendarIDToNameMapping[cal.id!] = cal.summary!;

      // Set up event retrievals
      getEventFutures.add((await calendarApi)
          .events
          .list(cal.id!, timeMin: timeMin, timeMax: timeMax, singleEvents: true)
          .then((gcal.Events events) {
        // Return each event mapped to the calendarID of its calendar
        return [for (gcal.Event event in events.items!) (event, cal.id ?? "")];
      }));
    }

    // Combine all get event futures into one future
    List<(gcal.Event, String)> eventList =
        await Future.wait<List<(gcal.Event, String)>>(getEventFutures).then(
            (value) => value
                .expand((List<(gcal.Event, String)> eventList) => eventList)
                .toList());

    // Group each event into a list of other events that happen that day
    final Map<DateTime, List<Event>> groups = _convertGCalEventListToMap(
        eventList, calendarIDToNameMapping, calendarIDToColorMapping);

    return groups;
  }

  Map<DateTime, List<Event>> _convertGCalEventListToMap(
      List<(gcal.Event, String)> eventList,
      Map<String, String> calendarIDToNameMapping,
      Map<String, Color> calendarIDToColorMapping) {
    // Map to be returned
    Map<DateTime, List<Event>> groups = {};

    for (var (event, eventCalID) in eventList) {
      // Ex from the API: "it is not valid to specify start.date and end.dateTime"
      if (event.start!.dateTime == null && event.start!.date == null) {
        throw ErrorDescription(
            "ERROR: A Google Calendar event must either have date or dateTime as non-null");
      }

      // Either dateTime or date is non-null
      DateTime date = event.start!.dateTime ?? event.start!.date!;

      // Create event widget, but use the mapping to get the proper name.
      Event eventWidget = Event.fromGoogleCalendarEvent(event,
          calendarName: calendarIDToNameMapping[eventCalID] ?? "CAL_NAME",
          color: calendarIDToColorMapping[eventCalID]);

      if (groups.containsKey(date)) {
        groups[date]!.add(eventWidget);
      } else {
        groups[date] = [eventWidget];
      }
    }

    return groups;
  }
}
