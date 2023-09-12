import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import './firestore_manager.dart';
import './google_api_controller.dart';
import '../firebase_options.dart';

class AuthManager {
  // GoogleApiController
  GoogleApiController? _googleApiController;
  late Future<GoogleApiController?> _googleApiControllerFuture;

  // Firebase UserCredential
  UserCredential? _userCredential;
  late Future<UserCredential?> _userCredentialFuture;

  // FirestoreManager
  FirestoreManager? _firestoreManager;
  late Future<FirestoreManager> _firestoreManagerFuture;
  AuthManager._create();

  static Future<AuthManager> create() async {
    // Initialize Firebase
    var authManager = AuthManager._create();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });

    authManager._googleApiControllerFuture =
        GoogleApiController.create().onError((error, stackTrace) {
      throw ErrorDescription(error.toString());
    });

    authManager._userCredentialFuture = authManager._googleApiControllerFuture
        .then((GoogleApiController? googleApiController) =>
            googleApiController!.userCredential)
        .onError((error, stackTrace) {
      throw ErrorDescription(error.toString());
    });

    authManager._firestoreManagerFuture =
        FirestoreManager.create(authManager.userCredential);

    return authManager;
  }

  Future<GoogleApiController> get googleApiController async {
    // Creates object to interface w/ Google APIs. Also signs in
    _googleApiController ??= await _googleApiControllerFuture;

    return _googleApiController!;
  }

  Future<UserCredential> get userCredential async {
    // Derives the userCredential from the GoogleApiController
    _userCredential ??= await _userCredentialFuture;

    return _userCredential!;
  }

  Future<FirestoreManager> get firestoreManager async {
    // Creates object to interface w/ Firestore
    _firestoreManager ??= await _firestoreManagerFuture;

    return _firestoreManager!;
  }
}
