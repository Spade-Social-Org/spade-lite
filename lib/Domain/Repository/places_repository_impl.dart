import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spade_lite/Domain/Repository/places_repository.dart';
import '../../Data/Google_api_service/apiservice.dart';
import '../../Presentation/widgets/jh_logger.dart';
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
      logger.d('API Response Data: $data');

      // ignore: unnecessary_null_comparison
      if (data != null && data.containsKey('results')) {
        final placesJson = data['results'] as List<dynamic>;

        places.addAll(placesJson.map((placeJson) {
          final photos = placeJson['photos'] as List<dynamic>?;

          String imageUrl = '';

          if (photos != null && photos.isNotEmpty) {
            final photoReference = photos[0]['photo_reference'];
            imageUrl = api.buildPhotoUrl(photoReference);
          }

          return Place(
            id: placeJson['place_id'],
            name: placeJson['name'],
            address: placeJson['vicinity'],
            imageURL: imageUrl,
            reviews: [],
            openingHours: placeJson['opening_hours'] != null
                ? placeJson['opening_hours']['open_now']
                    ? 'Open now'
                    : 'Closed'
                : 'Unknown',
          );
        }));

        nextPageToken = data['next_page_token'];
      } else {
        print('Invalid or missing API response data');
        break;
      }
    } while (nextPageToken != null);

    return places;
  }
}
