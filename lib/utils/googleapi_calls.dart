import 'package:googleapis/calendar/v3.dart' as gcal;
import 'package:todo_app/providers/auth_manager.dart';

// TODO: Handle potential error for this call
Future<List<gcal.Event>> getEvents(AuthManager authManager, String calendarId,
    {DateTime? timeMin, DateTime? timeMax}) async {
  print("Function called");

  var calendarApi = await authManager.calendarApi;
  var eventList = await calendarApi.events
      .list(calendarId,
          orderBy: "startTime",
          singleEvents: true,
          timeMin: timeMin,
          timeMax: timeMax)
      .then((events) => events.items);

  return eventList!;
}
