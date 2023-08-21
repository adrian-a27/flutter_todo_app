import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as gcal;
import '../widgets/page_header.dart';
import '../widgets/task_group.dart';
import '../widgets/task.dart';
import '../widgets/event_stream.dart';
import '../widgets/event.dart';
import '../utils/googleapi_calls.dart';

class AgendaPage extends StatefulWidget {
  AgendaPage(this.googleSignIn);
  final GoogleSignIn googleSignIn;

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  late Future<List<gcal.Event>> _eventList;

  final tempEvents = EventStream(heading: "Today's Event's", events: [
    Event(
        calendarName: 'Bluestreaks',
        eventName: '2019 BAC Holiday Splash',
        eventTime: 'All Day',
        eventDescription: 'Description'),
    Event(
        calendarName: 'Wayne Valley Events',
        eventName: 'Jazz Band',
        eventTime: '6:00 PM - 9:00 PM',
        eventDescription: 'Description'),
    Event(
        calendarName: 'Holidays in United States',
        eventName: "New Year's Day",
        eventTime: 'All Day',
        eventDescription: 'Description')
  ]);
  @override
  void initState() {
    super.initState();

    var now = DateTime.now();
    var yesterday =
        DateTime(now.year, now.month, now.day).subtract(Duration(days: 1));
    var tomorrow =
        DateTime(now.year, now.month, now.day).add(Duration(days: 4)); // FIXME: Change date to 1 day

    _eventList = getEvents(widget.googleSignIn, "primary", timeMin: yesterday, timeMax: tomorrow);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PageHeader(
          title: "Agenda",
          subtitile: DateFormat.MMMMd().format(DateTime.now()),
        ),
        TaskGroup(heading: "Today", tasks: [
          Task(name: "This is a task"),
          Task(name: "This is another task"),
          Task(name: "Finish the other tasks")
        ]),
        Expanded(
          child: FutureBuilder(
            future: _eventList,
            builder: (BuildContext context,
                AsyncSnapshot<List<gcal.Event>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  // TODO: Put in a proper error screen
                  return ErrorWidget(snapshot.error!);
                }

                return EventStream(heading: "Today's Event's", events: [
                  for (var event in snapshot.data!)
                    Event.fromGoogleCalendarEvent(event)
                ]);
              } else {
                return Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator.adaptive(),
                );
              }
            },
          ),
        )
      ],
    );
  }
}
