import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'event_widget.dart';

class EventStream extends StatelessWidget {
  late String heading;
  final List<EventWidget> events;
  final DateTime? date;
  bool scrollable;

  EventStream(
      {super.key,
      required this.heading,
      required this.events,
      this.date,
      this.scrollable = false});

  EventStream.withDate(
      {required this.date, required this.events, this.scrollable = true}) {
    heading = date!.year == DateTime.now().year
        ? DateFormat.MMMMd().format(date!.toLocal())
        : DateFormat.yMMMMd('en_US').format(date!.toLocal());
  }

  static List<EventStream> fromGoogleCalendarEvents(
      Map<DateTime, List<EventWidget>> groups) {
    // Make the EventStream for each group
    List<EventStream> eventGroups = [
      for (MapEntry<DateTime, List<EventWidget>> group in groups.entries)
        EventStream.withDate(date: group.key, events: group.value)
    ];

    // Sort the groups so the stream is ordered on the page
    eventGroups.sort((group1, group2) => group1.date!.compareTo(group2.date!));
    print("Events sorted!");

    return eventGroups;
  }

  // TODO: Create automatic group based on date
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        if (scrollable) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(heading,
                        style: Theme.of(context).textTheme.headlineSmall),
                  ),
                  Text(events.length.toString(),
                      style: Theme.of(context).textTheme.headlineSmall)
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (BuildContext context, int index) =>
                      events[index],
                ),
              ),
            ],
          );
        } else {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(heading,
                        style: Theme.of(context).textTheme.headlineSmall),
                  ),
                  Text(events.length.toString(),
                      style: Theme.of(context).textTheme.headlineSmall)
                ],
              ),
              for (var event in events) event
            ],
          );
        }
      }),
    );
  }
}
