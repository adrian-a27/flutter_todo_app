import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './google_api_controller.dart';
import '../models/event.dart';

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

    // TODO: Read snapshots and store entire snapshots, not straight from firestore
    _isRefreshing = true;

    CollectionReference events = _userDocumentRef.collection('events');

    List<Event> eventList = await googleApiController.getAllEvents();

    print("storing events");
    for (Event event in eventList) {
      print(event.name);
      events.doc(event.id).set(event.toMap());
    }

    _isRefreshing = false;
  }
}
