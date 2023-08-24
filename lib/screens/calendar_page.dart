import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_manager.dart';
import '../widgets/page_header.dart';
import '../widgets/event_stream.dart';
import '../utils/googleapi_calls.dart';

class CalendarPage extends StatefulWidget {
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage>
    with AutomaticKeepAliveClientMixin {
  late Future<List<EventStream>> _eventList;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _eventList = getEvents(context.read<AuthManager>(),
        timeMin: DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      children: [
        PageHeader(title: "Calendar"),
        Expanded(
          child: FutureBuilder(
            future: _eventList,
            builder: (BuildContext context,
                AsyncSnapshot<List<EventStream>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  // TODO: Put in a proper error screen
                  return ErrorWidget(snapshot.error!);
                }

                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      snapshot.data![index].scrollable = false;
                      return snapshot.data![index];
                    });
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
