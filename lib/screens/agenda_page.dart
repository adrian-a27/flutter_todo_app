import 'package:flutter/material.dart';
import '../widgets/page_header.dart';
import '../widgets/task_group.dart';
import '../widgets/task.dart';
import '../widgets/event_stream.dart';
import '../widgets/event.dart';

class AgendaPage extends StatelessWidget {
  final children = [
    TaskGroup(heading: "Today", tasks: [
      Task(name: "This is a task"),
      Task(name: "This is another task"),
      Task(name: "Finish the other tasks")
    ]),
    EventStream(heading: "Today's Event's", events: [
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
    ])
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PageHeader(
          title: "Agenda",
          subtitile: "January 1st",
        ),
        Expanded(
          child: ListView.builder(
            itemCount: children.length,
            itemBuilder: (BuildContext context, int index) => children[index],
          ),
        )
      ],
    );
  }
}
