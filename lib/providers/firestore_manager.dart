import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './google_api_controller.dart';

class FirestoreManager {
  bool _isRefreshing = false;
  final UserCredential _userCredential;
  late DocumentReference _userDocumentRef;

  FirestoreManager._create(this._userCredential);

  static Future<FirestoreManager> create(
      Future<UserCredential?> userCredentialFuture) async {
    UserCredential? userCredential = await userCredentialFuture;
    FirestoreManager firestoreManager =
        FirestoreManager._create(userCredential!);

    firestoreManager._userDocumentRef = FirebaseFirestore.instance
        .collection('users')
        .doc(firestoreManager._userCredential.user!.uid);

    return firestoreManager;
  }

  Future<void> backgroundRefreshEvents(
      GoogleApiController googleApiController) async {
    print(
        "backgroundRefreshEvents called for ${(await googleApiController.userCredential).user!.email}");

    _isRefreshing = true;

    CollectionReference events =
        _userDocumentRef.collection('events'); // TODO: Make this user specific
    var (
      eventList,
      Map<String, String> calendarIDToNameMapping,
      Map<String, Color> calendarIDToColorMapping
    ) = await googleApiController.getAllEvents();

    print("storing events");
    for (var (event, calID) in eventList) {
      // TODO: Create event data model instead of raw GCal event
      print(event.summary);
      bool isAllDay = event.start!.dateTime == null;

      // If event is all day, you should not convert date to local time
      events.doc(event.iCalUID).set({
        'event_name': event.summary!,
        'isAllDay': isAllDay,

        'event_time_start': isAllDay
            ? event.start!.date!.toUtc()
            : event.start!.dateTime!.toUtc(),
        
        'event_time_end':
            isAllDay ? event.end!.date!.toUtc() : event.end!.dateTime!.toUtc(),
        'event_description': event.description,
        'calendar_name': calendarIDToNameMapping[calID],
        'calendar_color': calendarIDToColorMapping[calID]!.value
      });
    }

    _isRefreshing = false;
  }
}
