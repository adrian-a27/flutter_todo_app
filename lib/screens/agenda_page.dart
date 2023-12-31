import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/auth_manager.dart';
import '../providers/google_api_controller.dart';
import '../widgets/page_header.dart';
import '../widgets/task_group.dart';
import '../widgets/task.dart';
import '../widgets/event_stream.dart';

const noEventsTodayStr = "No events found for today!";

class AgendaPage extends StatefulWidget {
  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage>
    with AutomaticKeepAliveClientMixin {
  late Future<EventStream> _todaysEvents;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _todaysEvents = getTodaysEvents(context);
  }

  Future<EventStream> getTodaysEvents(BuildContext context) async {
    var now = DateTime.now();
    var startOfDay = DateTime(now.year, now.month, now.day);
    var endOfDay = DateTime(now.year, now.month, now.day)
        .add(Duration(days: 1))
        .subtract(Duration(milliseconds: 1));
    print(startOfDay);
    print(endOfDay);

    List<EventStream> groups = EventStream.fromGoogleCalendarEvents(
        await context.read<AuthManager>().googleApiController.then(
            (GoogleApiController googleApiController) =>
                googleApiController.getEvents(
                    timeMin: startOfDay.toUtc(), timeMax: endOfDay.toUtc())));

    for (EventStream eventStream in groups) {
      if (eventStream.heading == DateFormat.MMMMd().format(startOfDay)) {
        return eventStream;
      }
    }

    throw ErrorDescription(noEventsTodayStr);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

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
            future: _todaysEvents,
            builder:
                (BuildContext context, AsyncSnapshot<EventStream> snapshot) { 
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  if (snapshot.error!.toString() == noEventsTodayStr) {
                    return Center(child: Text("No events found for today!"));
                  } else {
                    // TODO: Put in a proper error screen
                    print(snapshot.error!);
                    return ErrorWidget(ErrorDescription(
                        "Something went wrong creating the AgendaPage!: ${snapshot.error}"));
                  }
                }
                print(snapshot.data!.heading);
                snapshot.data!.heading = "Today's Events";
                return snapshot.data!;
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
