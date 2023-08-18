import 'package:flutter/material.dart';
import '../widgets/page_header.dart';
import '../widgets/event.dart';

class CalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final events = [
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
    ];

    return Column(
      children: [
        PageHeader(title: "Calendar"),
        Expanded(
          child: ListView.builder(
            itemCount: events.length,
            itemBuilder: (BuildContext context, int index) => events[index],
          ),
        ),
      ],
    );
  }
}
