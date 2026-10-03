import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web is not configured yet.');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError('This platform is not supported yet.');
    }
  }

  // ⚠️ YAHAN DHAYAN DO: Aapke paas jo google-services.json file hai,
  // usme se dekh kar yeh teen details bas badal lena:
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_API_KEY_HERE', // google-services.json mein "current_key" dhoondo
    appId: 'YOUR_APP_ID_HERE',   // google-services.json mein "mobilesdk_app_id" dhoondo
    messagingSenderId: 'YOUR_SENDER_ID_HERE', // google-services.json mein "project_number" dhoondo
    projectId: 'shubham-salon', // Aapka firebase project id
  );
}