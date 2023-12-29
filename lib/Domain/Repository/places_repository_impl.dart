import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spade_lite/Domain/Repository/places_repository.dart';
import 'package:geolocator/geolocator.dart';
import '../../Data/Google_api_service/apiservice.dart';
import '../Entities/place.dart';

class PlacesRepositoryImpl implements PlacesRepository {
  final GooglePlacesApi api;

  PlacesRepositoryImpl(this.api);
  @override
  Future<List<Place>> getPlaces(String placeType, LatLng location,
      {String? nextPageToken}) async {
    final places = <Place>[];

    do {
      final data =
          await api.fetchPlaces(placeType, location, pageToken: nextPageToken);

      // ignore: unnecessary_null_comparison
      if (data != null && data.containsKey('results')) {
        final placesJson = data['results'] as List<dynamic>;

        places.addAll(await Future.wait(placesJson.map((placeJson) async {
          final details = await api.fetchPlaceDetails(placeJson['place_id']);
          final placeDetails = details['result'] as Map<String, dynamic>;

          final photoReferences = placeDetails['photos'] as List<dynamic>?;

          final imageUrls = api.buildPhotoUrls(photoReferences
              ?.map((photo) => photo['photo_reference'] as String)
              .toList());

          return Place(
            id: placeDetails['place_id'],
            name: placeDetails['name'],
            address: placeDetails['vicinity'],
            imageURL: imageUrls,
            reviews: [],
            openingHours: placeDetails['opening_hours'] != null
                ? placeDetails['opening_hours']['open_now']
                    ? 'Open now'
                    : 'Closed'
                : 'Unknown',
            distance: _calculateDistance(
              location.latitude,
              location.longitude,
              placeDetails['geometry']['location']['lat'] as double,
              placeDetails['geometry']['location']['lng'] as double,
            ),
          );
        })));

        nextPageToken = data['next_page_token'];
      } else {
        break;
      }
    } while (nextPageToken != null);

    return places;
  }
}

double _calculateDistance(
  double userLat,
  double userLng,
  double placeLat,
  double placeLng,
) {
  return Geolocator.distanceBetween(userLat, userLng, placeLat, placeLng) /
      1609.34;
}
