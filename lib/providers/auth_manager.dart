import 'package:firebase_core/firebase_core.dart';
import './google_api_controller.dart';
import '../firebase_options.dart';

class AuthManager {
  GoogleApiController? _googleApiController;
  AuthManager._create();

  static Future<AuthManager> create() async {
    // Initalize Firebase
    var authManager = AuthManager._create();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    return authManager;
  }

  Future<GoogleApiController> get googleApiController async {
    // Creates object to interface w/ Google APIs. Also signs in
    _googleApiController ??= await GoogleApiController.create();

    return _googleApiController!;
  }
}
