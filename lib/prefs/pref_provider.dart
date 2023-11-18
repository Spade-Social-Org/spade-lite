import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spade_lite/Data/Models/user_model.dart';

final userAuthChange = Provider((ref) => PrefProvider.getUserToken());
final userIdProvider = FutureProvider((ref) => PrefProvider.getUserId());
final userProvider = FutureProvider((ref) => PrefProvider.getUserModel());

class PrefProvider {
  static const _storage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true));

  static String userId = 'userId';
  static String user = 'user';
  static String token = 'token';
  static String loginData = 'loginData';

  static Future<void> saveUserToken(String value) async {
    await _storage.write(key: token, value: value);
  }

  static Future<String?> getUserToken() async {
    return await _storage.read(key: token);
  }

  static Future saveUserId(int value) async {
    await _storage.write(key: userId, value: "$value");
  }

  static Future saveUserModel(User userModel) async {
    await _storage.write(key: user, value: userModel.toJson());
  }

  static Future<User?> getUserModel() async {
    final userModel = await _storage.read(key: user);
    if (userModel == null) return null;
    return User.fromJson(userModel);
  }

  static Future<String?> getUserId() async {
    return await _storage.read(key: userId);
  }

  static Future<bool> saveUserLoginDetails(List<String> values) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setStringList('loginData', values);
  }

  static Future<List<String>?> getUserLoginDetails() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getStringList('loginData');
  }
}
