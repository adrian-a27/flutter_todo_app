import 'package:flutter/material.dart';
import 'event.dart';

class EventStream extends StatelessWidget {
  final String? heading;
  final List<Event> events;

  const EventStream({super.key, required this.heading, required this.events});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(heading!,
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
            Text(events.length.toString(),
                style: Theme.of(context).textTheme.headlineSmall)
          ],
        ),
        for (Event event in events) event
      ],
    );
  }
}
