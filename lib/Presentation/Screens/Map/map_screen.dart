import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spade_lite/Data/Models/discover.dart';
import 'package:spade_lite/Domain/Repository/discovery_repo.dart';
import 'package:spade_lite/Presentation/widgets/jh_places_items.dart';

import '../../../Common/theme.dart';
import '../../../Domain/Entities/place.dart';
import '../../Bloc/places_bloc.dart';
import '../../widgets/jh_custom_marker.dart';
import '../../widgets/jh_loader.dart';
import '../../widgets/jh_logger.dart';
import '../../widgets/jh_search_bar.dart';

Widget buildHorizontalImageList(List<String> imageURL) {
  return SizedBox(
    height: 200,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: imageURL.length,
      itemBuilder: (context, index) {
        if (index >= 0 && index < imageURL.length) {
          final imageUR = imageURL[index];
          logger.d('Image URL at index $index: $imageURL');

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: NetworkImage(imageUR),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    ),
  );
}

Widget _buildErrorBottomSheet(String errorMessage) {
  return Container(
    padding: const EdgeInsets.all(16),
    child: Center(
      child: Text('Error: $errorMessage'),
    ),
  );
}

Widget _buildLoadedBottomSheet(BuildContext context, List<Place> places,
    ScrollController scrollController) {
  return ListView(
    controller: scrollController,
    children: [
      const SizedBox(
        height: 2,
      ),
      Center(
        child: Container(
          width: 20 * 7,
          height: 6,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              shape: BoxShape.rectangle),
        ),
      ),
      Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8),
            child: CircleAvatar(
              backgroundImage: AssetImage("assets/images/Ellipse 378.png"),
              radius: 30,
            ),
          ),
          const SizedBox(
            width: 2 * 4,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: "Search for Places",
                  hintStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  fillColor: Color(0xFF333333),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 2.0,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                      weight: 30,
                      size: 30,
                    ),
                    onPressed: () {},
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.only(left: 2),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 2),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
            ),
            for (int i = 0; i < 3; i++)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFF333333),
                      borderRadius: BorderRadius.circular(20)),
                  height: 29,
                  width: 90,
                  child: Row(
                    children: [
                      Icon(
                        iconsRow[i],
                        color: Colors.white,
                        size: 15,
                      ),
                      Text(
                        text[i].toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),

      ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: places.length,
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final place = places[index];
          logger.d('Image URL for place ${place.name}: ${place.imageURL}');
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                 Padding(
                  padding: EdgeInsets.only(
                    left: 12,
                  ),
                  child: Text(
                    place.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    left: 12,
                  ),
                  child: Text(
                    'African, American,Carribbean',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Text(
                            'Open  now',
                            style: TextStyle(
                              fontSize: 14,
                              color: CustomColors.greenPrimary,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '0.8 miles',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 14,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                              height: 25,
                              width: 60 * 2,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  'Schedule',
                                  style: TextStyle(
                                    color: CustomColors.black,
                                    fontSize: 15,
                                  ),
                                ),
                              )),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Image.asset('assets/images/arrowforward.png', width: 16),
                        const SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Image.asset('assets/images/calendar.png', width: 16)),
                        const SizedBox(
                          width: 5,
                        ),
                        Image.asset('assets/images/hearticon.png', width: 17),
                      ],
                    ),
                  ],
                ),
                if (place.imageURL.isNotEmpty)
                  buildHorizontalImageList(place.imageURL),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      )
    ],
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

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({Key? key}) : super(key: key);

  @override
  State<GoogleMapScreen> createState() => _GoogleMapState();
}

class _GoogleMapState extends State<GoogleMapScreen>
    with SingleTickerProviderStateMixin {
  String mapTheme = '';
  int selectedItemIndex = -1;
  int selectedContainerIndex = -1;
  late GoogleMapController? mapController;
  final TextEditingController _searchController = TextEditingController();

  Map<String, Marker> _markers = {};
  Set<Polyline> polylines = {};
  bool loadingLocation = true;
  bool _isMarkerZoomed = false;
  bool isLocationEnabled = false;
  bool trafficEnabled = false;
  late Geolocator geolocator;
  LatLng? _initialPosition;
  LatLng? _searchedLocation;

  final Set<Circle> _circle = {};

  List<DiscoverUserModel> userSpade = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false,
            myLocationEnabled: isLocationEnabled,
            myLocationButtonEnabled: false,
            trafficEnabled: trafficEnabled,
            circles: _circle,
            //polylines: polylines,
            onMapCreated: (controller) {
              controller.setMapStyle(mapTheme);
              mapController = controller;

              /// After fetching the location this [SETSTATE] we set the isLocationEnabled to true meaning the button is on
              setState(() {
                isLocationEnabled = true;
              });
            },
            markers: _markers.values.toSet(),
            initialCameraPosition: _initialPosition != null
                ? CameraPosition(target: _initialPosition!, zoom: 14)
                : const CameraPosition(target: LatLng(0, 0), zoom: 14),
          ),
          if (loadingLocation)
            const Center(
              child: JHLoadingSpinner(),
            ),
          Positioned(
            left: 20,
            bottom: 40,
            child: GestureDetector(
              onTap: _showBottomSheetForCard,
              child: CircleAvatar(
                backgroundColor: Colors.black,
                radius: 30,
                child: Image.asset('assets/images/places.png'),
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: 40,
            child: GestureDetector(
              onTap: () {
                //_friendsList();
              },
              child: CircleAvatar(
                backgroundColor: Colors.black,
                radius: 30,
                child: Image.asset('assets/images/people.png'),
              ),
            ),
          ),
          Positioned(
            top: 64 * 2,
            left: 20,
            right: 20,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: "Where would you like to go?",
                      hintStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      fillColor: const Color(0xFF333333),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white,
                          weight: 30,
                          size: 30,
                        ),
                        onPressed: _searchLocation,
                      ),
                    ),
                    textAlign: TextAlign.center,
                    onSubmitted: (_) {
                      _searchLocation();
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 36,
            right: 20,
            child: InkWell(
              onTap: _toggleLocation,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isLocationEnabled ? Colors.green : Colors.grey,
                    width: 2.5,
                  ),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 20,
                  child: Image.asset('assets/images/Union.png'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void fetchUsers() async {
    try {
      userSpade = await DiscoverRepo().checkoutUsers();
      debugPrint("userSp =======> ${userSpade.toString()}");
      // Now you can use userSp in your UI
      setState(() {
        // Update your UI if necessary
      });
    } catch (error) {
      // Handle the error
      print("Error fetching users: $error");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();

    ///Load map theme
    DefaultAssetBundle.of(context)
        .loadString('assets/maptheme/nighttheme.json')
        .then((value) {
      mapTheme = value;
    });
    _loadInitialPosition();
    _getCurrentLocation();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // Assuming generateRandomUsers returns a List<User> with random user data
      // final List<User> userList = generateRandomUsers(5);

      final newmarkers = userSpade.map((user) async {
        double latitude = double.parse(user.latitude.toString());
        double longitude = double.parse(user.longitude.toString());
        var customMarkerIcon = CustomMarkerIcon(
          size: 160,
          imagePath: user.gallery![0],
          backgroundColor: Colors.grey.withOpacity(0.5),
          onTap: () {},
          position: LatLng(latitude, longitude),
        );

        return Marker(
          position: LatLng(latitude, longitude),
          markerId: MarkerId(user.name!),
          icon: await customMarkerIcon.createMarkerIcon(),
          onTap: () {
            _onMarkerTapped(_markers[user.name]!);
          },
        );
      });

      setState(() async {
        _markers = {
          for (var marker in await Future.wait(newmarkers))
            (marker).markerId.value: marker
        };
      });
    });
  }

  void _addCircle(Position position) {
    _circle.add(
      Circle(
        circleId: const CircleId('circle_1'),
        center: LatLng(position.latitude, position.longitude),
        radius: 900,
        fillColor: Colors.grey.withOpacity(0.5),
        strokeWidth: 2,
        strokeColor: Colors.green,
      ),
    );
    setState(() {});
  }

  void _getCurrentLocation() async {
    try {
      /// Request location permissions explicitly
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        /// Handle the case where permissions are denied
        /// You can show a dialog to inform the user or take any other action
        setState(() {
          loadingLocation = false;
        });
        return;
      }

      /// Permissions are granted or allowed while using the app, proceed with fetching the location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      ///store the initial position in cache
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setDouble('latitude', position.latitude);
      prefs.setDouble('longitude', position.longitude);

      String userAddress = placemarks.isNotEmpty
          ? "${placemarks.first.name}, ${placemarks.first.locality}, ${placemarks.first.administrativeArea}"
          : "Unknown Location";

      /// Center the map on the current location
      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 14,
          ),
        ),
      );

      /// Update the search bar text with the user's address
      setState(() {
        _initialPosition = LatLng(position.latitude, position.longitude);
        _searchController.text = userAddress;
        loadingLocation = false;
        //isLocationEnabled = true;
      });
      _addCircle(position);

      Polyline polyline = Polyline(
        polylineId: const PolylineId('polyline_1'),
        color: Colors.blue,
        width: 5,
        points: [LatLng(position.latitude, position.longitude)],
      );

      setState(() {
        polylines = {polyline};
      });
    } on PlatformException catch (e) {
      /// Handle errors that might occur when fetching the current location
      logger.e("Error: ${e.message}");
      setState(() {
        loadingLocation = false;
      });
    }
  }

  Future<void> _loadInitialPosition() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? cachedLatitude = prefs.getDouble('latitude');
    double? cachedLongitude = prefs.getDouble('longitude');

    if (cachedLatitude != null && cachedLongitude != null) {
      setState(() {
        _initialPosition = LatLng(cachedLatitude, cachedLongitude);
      });
    }
    _getCurrentLocation();
  }

  void _onMarkerTapped(Marker tappedMarker) {
    print('Marker tapped');

    double targetZoom = _isMarkerZoomed ? 14.0 : 20.0;
    _isMarkerZoomed = !_isMarkerZoomed;
    setState(() {
      _markers.forEach((key, marker) {
        _markers[key] = marker.copyWith(visibleParam: true);
      });
    });

    setState(() {
      _markers[tappedMarker.markerId.value] =
          tappedMarker.copyWith(visibleParam: true);
    });

    mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(tappedMarker.position, targetZoom),
    );
    _showBottomSheet();
  }

  void _searchLocation() async {
    String searchText = _searchController.text;
    if (searchText.isEmpty) return;

    try {
      List<Location> locations = await locationFromAddress(searchText);
      if (locations.isNotEmpty) {
        setState(() {
          _searchedLocation =
              LatLng(locations.first.latitude, locations.first.longitude);
          mapController?.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: _searchedLocation!,
                zoom: 14,
              ),
            ),
          );
        });
      }
    } catch (e) {
      print("Error searching location: $e");
    }
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
          child: Container(
            height: 250,
            width: double.infinity,
            color: const Color(0xff000000),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        border: Border.all(width: 3.5, color: Colors.green),
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sophie',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          'Nirmala Girls HSS, Dallas - 16m ago',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/svgs/location.svg",
                                  height: 25,
                                  color: const Color(0xff797979),
                                ),
                                const SizedBox(width: 5),
                                const Text(
                                  'Opened',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.green,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  '1m',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff797979),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/svgs/personMap.svg",
                                  height: 20,
                                  color: const Color(0xff797979),
                                ),
                                const Text(
                                  '20min',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff797979),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.green,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/svgs/msg.svg",
                              height: 20,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 5),
                            const Text(
                              'Message',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black,
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                                _showBottomSheetForCard();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.transparent,
                                  border: Border.all(
                                      width: 1.5, color: Colors.white),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/svgs/calendar.svg",
                                      height: 20,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.transparent,
                                border:
                                    Border.all(width: 1.5, color: Colors.white),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Invite',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _showBottomSheetForCard() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
          child: Container(
            height: 430,
            width: double.infinity,
            color: const Color(0xff000000),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Center(
                  child: Container(
                    width: 20 * 7,
                    height: 3,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        shape: BoxShape.rectangle),
                  ),
                ),
                const SizedBox(height: 10),
                const JHSearchField(),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage:
                          AssetImage("assets/images/Ellipse 378.png"),
                      radius: 40,
                    ),
                    const SizedBox(width: 10),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 2),
                                color: Colors.white38,
                                borderRadius: BorderRadius.circular(20)),
                            height: 30,
                            width: 60,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Image.asset(
                                "assets/images/Vector (2).png",
                                height: 10,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 2),
                              color: Colors.white38,
                              borderRadius: BorderRadius.circular(20)),
                          height: 30,
                          width: 60,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: SvgPicture.asset(
                              "assets/svgs/like.svg",
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 2),
                                color: Colors.white38,
                                borderRadius: BorderRadius.circular(20)),
                            height: 30,
                            width: 60,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: SvgPicture.asset(
                                "assets/svgs/calendar.svg",
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: images.length,
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  _showBottomSheetForSelectedCard(cards[index]);
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Container(
                                    color: Colors.white,
                                    height: 130,
                                    width: 130,
                                    child: Image.asset(
                                      images[index],
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                title[index],
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _showBottomSheetForSelectedCard(CardModel card) {
    BlocProvider.of<PlacesBloc>(context)
        .add(FetchPlacesEvent(card.placeType, _initialPosition!, null));
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
                  return _buildLoadedBottomSheet(
                      context, state.places, scrollController);
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

  void _toggleLocation() {
    setState(() {
      isLocationEnabled = !isLocationEnabled;
    });

    if (isLocationEnabled) {
      _getCurrentLocation();
    } else {
      _initialPosition = null;
    }
  }
}
