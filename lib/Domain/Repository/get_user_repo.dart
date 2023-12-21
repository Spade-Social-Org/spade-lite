import 'package:spade_lite/Data/Models/discover.dart';
import 'package:spade_lite/prefs/pref_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GetUser {
  DiscoverUserModel? user;
  Future<DiscoverUserModel?> getUser() async {
    String? token = await PrefProvider.getUserToken();
    String? id = await PrefProvider.getUserId();
    final response = await http.get(
      Uri.parse(
        'https://spade-backend-v3-production.up.railway.app/api/v1/users/profile/$id',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    final data = json.decode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      user = DiscoverUserModel.fromJson(data['data']);
    } else {
      return null;
    }
    return user;
  }
}
