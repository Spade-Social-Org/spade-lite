import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../Domain/Entities/place.dart';
import '../../Domain/Usecase/get_places_use_case.dart';
import '../widgets/jh_logger.dart';

abstract class PlacesEvent extends Equatable {
  const PlacesEvent();
}

class FetchPlacesEvent extends PlacesEvent {
  final String placeType;
  final LatLng location;
  final String? nextPageToken;

  const FetchPlacesEvent(this.placeType, this.location, this.nextPageToken);

  @override
  List<Object?> get props => [placeType, location, nextPageToken];
}

abstract class PlacesState extends Equatable {
  const PlacesState();
}

class PlacesLoadingState extends PlacesState {
  @override
  List<Object?> get props => [];
}

class PlacesLoadedState extends PlacesState {
  final List<Place> places;

  const PlacesLoadedState(this.places);

  @override
  List<Object?> get props => [places];
}

class PlacesErrorState extends PlacesState {
  final String message;

  const PlacesErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class PlacesBloc extends Bloc<PlacesEvent, PlacesState> {
  final GetPlaces getPlaces;

  PlacesBloc(this.getPlaces) : super(PlacesLoadingState()) {
    on<FetchPlacesEvent>((event, emit) async {
      emit(PlacesLoadingState());

      try {
        final placesResult = await getPlaces(event.placeType, event.location,
            nextPageToken: event.nextPageToken);
        emit(PlacesLoadedState(placesResult.places));
      } catch (e) {
        emit(const PlacesErrorState('Failed to fetch places.'));
      }
    });
  }

  Future<GetPlacesResult> fetchPlaces(String placeType, LatLng location,
      {String? nextPageToken}) async {
    final places =
        await getPlaces(placeType, location, nextPageToken: nextPageToken);

    return places;
  }
}
