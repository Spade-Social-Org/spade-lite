import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:spade_v4/Data/Models/discover.dart';
import 'package:spade_v4/prefs/pref_provider.dart';

class DiscoverRepo {
  List<DiscoverUserModel> allProduct = [];

  //checkout users
  Future<List<DiscoverUserModel>> checkoutUsers() async {
    print("checkout in progress!");
    String? token = await PrefProvider.getUserToken();

    final body = jsonEncode(
        {"longitude": 7.0, "latitude": 4.0, "type": "single_searching"});
    final response = await http.post(
      Uri.parse(
        'https://spade-backend-v3-production.up.railway.app/api/v1/users/discover',
      ),
      body: body,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    log("checkout=====>${body.toString()}");

    final data = json.decode(response.body);
    log(data.toString());

    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> allUsers = data['data'];
      log("order=====>${data.toString()}");
      // log(allEvents.toString());
      allProduct = allUsers
          .map<DiscoverUserModel>((event) => DiscoverUserModel.fromJson(event))
          .toList();

      return allProduct;
    } else {
      return [];
    }
  }

  //Like User
  Future<dynamic> likeUser({int? id}) async {
    String? token = await PrefProvider.getUserToken();
    print("liking Users");

    final response = await http.get(
      Uri.parse(
        'https://spade-backend-v3-production.up.railway.app/api/v1/users/like/2',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final data = json.decode(response.body);
    log(data.toString());

    if (response.statusCode == 200 || response.statusCode == 201) {
      log("like user=====>${data.toString()}");

      return data;
    } else {
      return data;
    }
  }
}
