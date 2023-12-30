import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spade_lite/Presentation/Screens/Map/widgets/bottom_places_sheet.dart';
import '../../../Bloc/places_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spade_lite/Presentation/widgets/jh_places_items.dart';
import 'package:spade_lite/Data/Models/discover.dart';

class BSPlacesRouter {
  final BuildContext context;
  final LatLng
      _initialPosition; // Replace with your actual initial position type

  BSPlacesRouter(this.context, this._initialPosition);

  void showBottomSheetForSelectedCard(CardModel card, DiscoverUserModel? user) {
    BlocProvider.of<PlacesBloc>(context)
        .add(FetchPlacesEvent(card.placeType, _initialPosition, null));
    showModalBottomSheet<void>(
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.2,
          maxChildSize: 1.0,
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return BlocBuilder<PlacesBloc, PlacesState>(
              builder: (context, state) {
                if (state is PlacesLoadingState) {
                  return _buildLoadingBottomSheet();
                } else if (state is PlacesLoadedState) {
                  return BottomPlacesSheet(
                      places: state.places,
                      scrollController: scrollController,
                      user: user);
                } else if (state is PlacesErrorState) {
                  return _buildErrorBottomSheet(state.message);
                }
                return Container();
              },
            );
          },
        );
      },
    );
  }

  Widget _buildLoadingBottomSheet() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorBottomSheet(String errorMessage) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Text(
          'Error: $errorMessage',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
