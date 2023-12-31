import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart' as gcal;
import 'package:intl/intl.dart';
import '../models/event.dart';

class EventWidget extends StatelessWidget {
  final String eventName;
  final String eventTime; // TODO: Should I make this a time type?
  final String? eventDescription;
  final String calendarName;
  final String? colorId;
  Color? color;

  // EventWidget(
  //     {super.key,
  //     required this.calendarName,
  //     required this.eventName,
  //     required this.eventTime,
  //     this.eventDescription,
  //     this.colorId});

  EventWidget(Event event)
      : eventName = event.name,
        eventTime = event.isAllDay
            ? "All day"
            : "${DateFormat.jm().format(event.start.toLocal())} - ${DateFormat.jm().format(event.end.toLocal())}",
        eventDescription = event.description,
        calendarName = event.calendarName,
        color = event.eventColor,
        colorId = event.googleCalendarColorId;

  // TODO: Handle all day events
  EventWidget.fromGoogleCalendarEvent(gcal.Event event,
      {this.calendarName = "CAL_NAME", this.color})
      : eventName = event.summary!,
        // If dateTime is null, it's an all day event
        eventTime = event.start!.dateTime == null
            ? "All day"
            : "${DateFormat.jm().format(event.start!.dateTime!.toLocal())} - ${DateFormat.jm().format(event.end!.dateTime!.toLocal())}",
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
    final newColorScheme = ColorScheme.fromSeed(
        seedColor: color != null
            ? (colorId != null ? colorIdMap[colorId] : color)!
                .harmonizeWith(theme.colorScheme.primary)
            : theme.colorScheme.primary,
        brightness: theme.brightness);

    // TODO: Handle description viewing
    return Card(
      color: newColorScheme.primaryContainer,
      child: Padding(
        padding:
            const EdgeInsets.only(top: 12, bottom: 12, left: 12, right: 12),
        child: Column(children: [
          Row(
            children: [
              Expanded(
                  child: Text(
                calendarName,
                style: theme.textTheme.labelSmall!
                    .copyWith(color: newColorScheme.onPrimaryContainer),
                overflow: TextOverflow.ellipsis,
              )),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: Text(
                eventName,
                style: theme.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: newColorScheme.onPrimaryContainer),
                overflow: TextOverflow.ellipsis,
              )),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  eventTime,
                  style: theme.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: newColorScheme.onPrimaryContainer),
                ),
              )
            ],
          ),
        ]),
      ),
    );
  }
}
