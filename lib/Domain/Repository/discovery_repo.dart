import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:spade_lite/Data/Models/discover.dart';
import 'package:spade_lite/prefs/pref_provider.dart';

import 'package:geolocator/geolocator.dart';

class DiscoverRepo {
  List<DiscoverUserModel> allProduct = [];

  //checkout users
  Future<List<DiscoverUserModel>> checkoutUsers() async {
    String? token = await PrefProvider.getUserToken();

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    double latitude = position.latitude;
    double longitude = position.longitude;

    final body = jsonEncode({"longitude": longitude, "latitude": latitude});
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
}
