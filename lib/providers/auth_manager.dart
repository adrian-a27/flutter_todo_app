import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:googleapis/calendar/v3.dart' as gcal;
import '../firebase_options.dart';

class AuthManager {
  static final List<String> _scopes = [gcal.CalendarApi.calendarEventsScope];
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: _scopes);
  gcal.CalendarApi? _calendarApi;

  AuthManager._create();

  static Future<AuthManager> create() async {
    // Initalize Firebase
    var authManager = AuthManager._create();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Sign in with Google (might get moved to not be auto)
    await authManager.signInWithGoogle();
    return authManager;
  }

  Future<void> signInWithGoogle() async {
    if (await _googleSignIn.signInSilently() == null) {
      try {
        // FIXME: This isn't good practice on the web, need to use renderButton
        await _googleSignIn.signIn();
      } catch (error) {
        print(error);
      }
      print("Sign in complete.");
    } else {
      // Use the cached access token to check if we have access to the scopes
      if (!(await _googleSignIn.canAccessScopes(_scopes))) {
        await _googleSignIn.requestScopes(_scopes);
      }

      print("Signed in silently");
    }
  }

  Future<gcal.CalendarApi> get calendarApi async {
    if (_calendarApi == null) {
      var client = await _googleSignIn.authenticatedClient();
      if (client == null) print("Null client!");

      // Cache the client
      _calendarApi = gcal.CalendarApi(client!);
    }

    return _calendarApi!;
  }

  GoogleSignInAccount getGoogleAccountUser() {
    return _googleSignIn.currentUser!;
  }
}