import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../Presentation/widgets/jh_logger.dart';
import '../../utils.dart';
import 'package:http/http.dart' as http;

class GooglePlacesApi {
  final String apiKey = ApiKey;
  final http.Client httpClient;

  GooglePlacesApi({required this.httpClient});

  Future<Map<String, dynamic>> fetchPlaces(String placeType, LatLng location,
      {String? pageToken}) async {
    var url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?'
        'location=${location.latitude},${location.longitude}&radius=50000&type=$placeType&key=$apiKey';
    if (pageToken != null) {
      url += '&pagetoken=$pageToken';
    }

    logger.d('API Request URL: $url');

    final response = await httpClient.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final responseData = response.body;

      return json.decode(responseData) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> fetchPlaceDetails(String placeId) async {
    final detailsUrl =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey';

    final detailsResponse = await httpClient.get(Uri.parse(detailsUrl));

    if (detailsResponse.statusCode == 200) {
      final detailsData = detailsResponse.body;
      return json.decode(detailsData) as Map<String, dynamic>;
    } else {
      throw Exception(
          'Failed to fetch place details: ${detailsResponse.statusCode}');
    }
  }

  List<String> buildPhotoUrls(List<String>? photoReferences) {
    if (photoReferences == null || photoReferences.isEmpty) {
      return [];
    }

    return photoReferences.map((photoReference) {
      return 'https://maps.googleapis.com/maps/api/place/photo?'
          'maxwidth=150&photoreference=$photoReference&key=$apiKey';
    }).toList();
  }
}
