import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as gcal;

// TODO: Handle potential error for this call
Future<List<gcal.Event>> getEvents(GoogleSignIn googleSignIn, String calendarId,
    {DateTime? timeMin, DateTime? timeMax}) async {
  print("Function called");
  var client = await googleSignIn.authenticatedClient();

  var calendarApi = gcal.CalendarApi(client!);
  var eventList = await calendarApi.events
      .list(calendarId,
          orderBy: "startTime",
          singleEvents: true,
          timeMin: timeMin,
          timeMax: timeMax)
      .then((events) => events.items);

  return eventList!;
}
