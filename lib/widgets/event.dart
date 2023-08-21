import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart' as gcal;
import 'package:intl/intl.dart';

class Event extends StatelessWidget {
  final String calendarName;
  final String eventName;
  final String eventTime; // TODO: Should I make this a time type?
  final String? eventDescription;
  final String? colorId;

  const Event(
      {super.key,
      required this.calendarName,
      required this.eventName,
      required this.eventTime,
      this.eventDescription,
      this.colorId});

  // TODO: Handle all day events
  Event.fromGoogleCalendarEvent(gcal.Event event)
      : calendarName = "CAL_NAME",
        eventName = event.summary!,
        eventTime =
            "${DateFormat.jm().format(DateTime.now())} - ${DateFormat.jm().format(DateTime.now())}",
        eventDescription = event.description,
        colorId = event.colorId;

  static final colorIdMap = <String, Color>{
    "1": Color(0xff7986cb),
    "2": Color(0xff33b679),
    "3": Color(0xff8e24aa),
    "4": Color(0xffe67c73),
    "5": Color(0xfff6c026),
    "6": Color(0xfff5511d),
    "7": Color(0xff039be5),
    "8": Color(0xff616161),
    "9": Color(0xff3f51b5),
    "10": Color(0xff0b8043),
    "11": Color(0xffd60000),
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // TODO: Handle description viewing
    return Card(
        color: colorIdMap.containsKey(colorId) ? colorIdMap[colorId]!.harmonizeWith(theme.colorScheme.primary) : theme.colorScheme.surface,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 12, bottom: 12, left: 12, right: 12),
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
                  overflow: TextOverflow.ellipsis,
                )),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    eventTime,
                    style: theme.textTheme.bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ]),
        ));
  }
}
