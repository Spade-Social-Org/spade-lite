import 'package:shared_preferences/shared_preferences.dart';

class LocalData {
  static final LocalData instance = LocalData._internal();

  factory LocalData() {
    return instance;
  }

  LocalData._internal();

  late SharedPreferences prefs;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  bool isStoryViewed(String url) {
    return prefs.getBool('story $url') ?? false;
  }

  Future<void> setStoryViewed(String url) async {
    await prefs.setBool('story $url', true);
  }
}
