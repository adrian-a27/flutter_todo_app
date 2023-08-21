import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart' as gcal;
import 'package:provider/provider.dart';
import '../providers/auth_manager.dart';
import '../widgets/page_header.dart';
import '../widgets/event.dart';
import '../utils/googleapi_calls.dart';

class CalendarPage extends StatefulWidget {
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late Future<List<gcal.Event>> _eventList;

  @override
  void initState() {
    super.initState();

    _eventList = getEvents(context.read<AuthManager>(), "primary",
        timeMin: DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PageHeader(title: "Calendar"),
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

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) =>
                      Event.fromGoogleCalendarEvent(snapshot.data![index]),
                );
              } else {
                return Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator.adaptive(),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
