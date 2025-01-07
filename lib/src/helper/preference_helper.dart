import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  final SharedPreferences preferences;

  PreferencesHelper(this.preferences);

  // Keys
  static const String PREF_MERCHENT_ID = "merchant_id";
  static const String PREF_CLIENT_ID = "id";

  // Getters and Setters
  String get clientId => preferences.getString(PREF_CLIENT_ID) ?? "";
  set clientId(String value) => preferences.setString(PREF_CLIENT_ID, value);

  String get merchantId => preferences.getString(PREF_MERCHENT_ID) ?? "";
  set merchantId(String value) => preferences.setString(PREF_MERCHENT_ID, value);

  Future<void> clear() async {
    await preferences.clear();
  }
}