import 'dart:async';
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart' as gcal;
import '../providers/auth_manager.dart';
import '../widgets/event.dart';
import '../widgets/event_stream.dart';

// TODO: Handle potential error for this call
// TODO: Add pagnation??
Future<List<EventStream>> getEvents(AuthManager authManager,
    {DateTime? timeMin, DateTime? timeMax}) async {
  print("getEvents called");

  gcal.CalendarApi calendarApi = await authManager.googleApiController.then(
      (googleApiController) async => await googleApiController.calendarApi);

  print("here!");

  // List to hold all the get request futures
  List<Future<List<(gcal.Event, String)>>> getEventFutures = [];

  // Map of calendarID to backgroundColor
  Map<String, Color> calendarIDToColorMapping = {};
  // Map of calendarID to name
  Map<String, String> calendarIDToNameMapping = {};

  // Create a mapping of calendarID to name and calendarID to color
  // and await it because it sets up the get events futures
  await calendarApi.calendarList
      .list()
      .then((gcal.CalendarList calList) => calList.items!)
      .then((List<gcal.CalendarListEntry> calListItems) {
    for (gcal.CalendarListEntry cal in calListItems) {
      var colorString = "ff${cal.backgroundColor!.replaceAll('#', '')}";

      // Fill in mappings
      calendarIDToColorMapping[cal.id!] =
          Color(int.parse(colorString, radix: 16));
      calendarIDToNameMapping[cal.id!] = cal.summary!;

      // Set up event retrievals
      getEventFutures.add(calendarApi.events
          .list(cal.id!, timeMin: timeMin, timeMax: timeMax, singleEvents: true)
          .then((gcal.Events events) {
        // Return each event mapped to the calendarID of its calendar
        return [for (gcal.Event event in events.items!) (event, cal.id ?? "")];
      }));
    }
  });

  // Combine all get event futures into one future
  List<(gcal.Event, String)> eventList =
      await Future.wait<List<(gcal.Event, String)>>(getEventFutures).then(
          (value) => value
              .expand((List<(gcal.Event, String)> eventList) => eventList)
              .toList());

  // Group each event into a list of other events that happen that day
  final Map<DateTime, List<Event>> groups = _convertGCalEventListToMap(
      eventList, calendarIDToNameMapping, calendarIDToColorMapping);

  // Make the EventStream for each group
  List<EventStream> eventGroups = [
    for (MapEntry<DateTime, List<Event>> group in groups.entries)
      EventStream.withDate(date: group.key, events: group.value)
  ];

  // Sort the groups so the stream is ordered on the page
  eventGroups.sort((group1, group2) => group1.date!.compareTo(group2.date!));

  print("Events sorted!");
  return eventGroups;
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
