import 'package:flutter/material.dart';

class Event extends StatelessWidget {
  final String calendarName;
  final String eventName;
  final String eventTime; // TOD0: Should I make this a time type?
  final String? eventDescription;

  const Event(
      {super.key,
      required this.calendarName,
      required this.eventName,
      required this.eventTime,
      this.eventDescription});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
        child: Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 12),
      child: Column(children: [
        Row(children: [
          Text(
            calendarName,
            style: theme.textTheme.labelSmall,
          )
        ]),
        Row(
          children: [
            Expanded(
                child: Text(
              eventName,
              style: theme.textTheme.bodyLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            )),
            Text(
              eventTime,
              style: theme.textTheme.bodyLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            )
          ],
        ),
        if (eventDescription != null)
          Row(children: [
            Text(
              eventDescription!,
              style: theme.textTheme.bodySmall,
            )
          ])
      ]),
    ));
  }
}
