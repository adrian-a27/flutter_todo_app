import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart' as gcal;

class Event {
  late final String name;
  late final bool isAllDay;
  late final DateTime start;
  late final DateTime end;
  late final String calendarName;
  late final String? id;
  Color? eventColor;
  String? googleCalendarColorId;
  String? description;

  Event(
      {required this.name,
      required this.isAllDay,
      required this.start,
      required this.end,
      required this.calendarName,
      required this.id,
      this.description,
      this.eventColor});

  Event.fromGoogleCalendarEvent(gcal.Event googleCalendarEvent) {
    name = googleCalendarEvent.summary!;
    isAllDay = googleCalendarEvent.start!.dateTime == null;
    start = isAllDay
        ? googleCalendarEvent.start!.date!.toUtc()
        : googleCalendarEvent.start!.dateTime!.toUtc();
    end = isAllDay
        ? googleCalendarEvent.end!.date!.toUtc()
        : googleCalendarEvent.end!.dateTime!.toUtc();
    description = googleCalendarEvent.description;
    googleCalendarColorId = googleCalendarEvent.colorId;
    id = googleCalendarEvent.iCalUID;
  }

  Map<String, dynamic> toMap() {
    return {
      "event_name": name,
      "is_all_day": isAllDay,
      "event_start": start,
      "event_end": end,
      "event_description": description,
      "event_color": eventColor?.value,
      "calendar_name": calendarName,
      "google_calendar_color_id": googleCalendarColorId
    };
  }
}
