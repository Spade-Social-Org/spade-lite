import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spade_lite/Data/Models/discover.dart';
import 'package:spade_lite/Domain/Repository/discovery_repo.dart';
import 'package:spade_lite/Domain/Repository/get_user_repo.dart';
import 'package:spade_lite/Presentation/Screens/Map/map.dart';
import 'package:spade_lite/Presentation/Screens/Map/widgets/bs_places_manager.dart';
import 'package:spade_lite/Presentation/widgets/jh_places_items.dart';
import 'package:spade_lite/Presentation/widgets/rounded_marker.dart';
import '../../widgets/jh_loader.dart';
import '../../widgets/jh_logger.dart';
import '../../widgets/jh_search_bar.dart';
import 'package:sentry/sentry.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapState();
}

class _GoogleMapState extends State<GoogleMapScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  LatLng? _searchedLocation;
  late GoogleMapController? mapController;

  String mapTheme = '';
  int selectedItemIndex = -1;
  int selectedContainerIndex = -1;

  final Map<String, Marker> markers = {};
  Set<Marker> _markers = {};

  Set<Polyline> polylines = {};
  bool loadingLocation = true;
  bool _isMarkerZoomed = false;
  bool isLocationEnabled = false;
  bool trafficEnabled = false;
  late Geolocator geolocator;
  LatLng? _initialPosition;

  final Set<Circle> _circle = {};

  List<DiscoverUserModel> userSpade = [];
  DiscoverUserModel? user;

  Future<void> addMarker(LatLng location, String url, String type) async {
    var marker = Marker(
      markerId: const MarkerId("USER"),
      position: location,
      infoWindow: const InfoWindow(title: 'ME', snippet: ''),
      onTap: () {
        _onMarkerTapped(_markers as Marker);
      },
      icon: await RoundedMarker(imageUrl: url, type: type).toBitmapDescriptor(
          logicalSize: const Size(200, 200), imageSize: const Size(400, 400)),
    );
    setState(() {
      _markers.add(marker);
    });
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
    } catch (error, stackTrace) {
      // Handle the error
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    createMarkers(context, "User");
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
              mapController = controller;
              mapController!.setMapStyle(MapStyle().aubergine);

              /// After fetching the location this [SETSTATE] we set the isLocationEnabled to true meaning the button is on
              setState(() {
                isLocationEnabled = true;
              });
            },
            markers: _markers,
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
              onTap: () => _showBottomSheetForCard(user),
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
                          onPressed: _searchLocation),
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
              onTap: () =>
                  _toggleLocation(user?.gallery?[0], user?.relationshipType),
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

  createMarkers(BuildContext context, String id) {
    userSpade.forEach((contact) async {
      double latitude = double.parse(contact.latitude.toString());
      double longitude = double.parse(contact.longitude.toString());

      double targetZoom = _isMarkerZoomed ? 14.0 : 20.0;
      _isMarkerZoomed = !_isMarkerZoomed;

      Marker marker = Marker(
        markerId: MarkerId(contact.name.toString()),
        position: LatLng(latitude, longitude),
        icon: await RoundedMarker(
                imageUrl: contact.gallery![0], type: contact.relationshipType!)
            .toBitmapDescriptor(
                logicalSize: const Size(200, 200),
                imageSize: const Size(400, 400)),
        onTap: () {
          mapController?.animateCamera(
            CameraUpdate.newLatLngZoom(LatLng(latitude, longitude), targetZoom),
          );
          _showBottomSheet(
            name: contact.name,
            imageString: contact.gallery![0],
            location:
                "${contact.country.toString()} ${contact.distance.toString()}",
          );
        },
        infoWindow: InfoWindow(
          title: contact.name,
          snippet: 'Street 6 . 2min ago',
        ),
      );

      setState(() {
        _markers.add(marker);
      });
    });
  }

  void fetchUsers() async {
    try {
      userSpade = await DiscoverRepo().checkoutUsers();
      // Now you can use userSpade in your UI
      setState(() {
        // Update your UI if necessary
      });
    } catch (error, stackTrace) {
      // Handle the error
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
    }
  }

  void fetchUser() async {
    try {
      user = await GetUser().getUser();
      // Now you can use user in your UI
      setState(() {
        // Update your UI if necessary
      });
      if (user != null) {
        _loadInitialPosition(user?.gallery?[0], user?.relationshipType);
        _getCurrentLocation(user?.gallery?[0], user?.relationshipType);
      }
    } catch (error, stackTrace) {
      // Handle the error
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUser();
    fetchUsers();

    ///Load map theme
    DefaultAssetBundle.of(context)
        .loadString('assets/maptheme/nighttheme.json')
        .then((value) {
      mapTheme = value;
    });

    if (user != null) {
      _loadInitialPosition(user?.gallery?[0], user?.relationshipType);
      _getCurrentLocation(user?.gallery?[0], user?.relationshipType);
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // Assuming generateRandomUsers returns a List<User> with random user data
      // final List<User> userList = generateRandomUsers(5);

      final newmarkers = userSpade.map((user) async {
        double latitude = double.parse(user.latitude.toString());
        double longitude = double.parse(user.longitude.toString());

        return Marker(
          position: LatLng(latitude, longitude),
          markerId: MarkerId(user.name!),
          icon: await RoundedMarker(
                  imageUrl: user.gallery![0], type: user.relationshipType!)
              .toBitmapDescriptor(
                  logicalSize: const Size(200, 200),
                  imageSize: const Size(400, 400)),
          onTap: () {
            _onMarkerTapped(_markers
                .firstWhere((marker) => marker.markerId.value == user.name));
          },
        );
      });

      setState(() async {
        _markers = {
          for (var marker in await Future.wait(newmarkers))
            (marker).markerId.value: marker
        } as Set<Marker>;
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

  void _getCurrentLocation(String? imageUrl, String? type) async {
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
      double markerOffset = 0.0002;
      // createMarkers(context, "user");
      if (imageUrl != null && type != null) {
        addMarker(LatLng(position.latitude + markerOffset, position.longitude),
            imageUrl, type);
      } else {
        addMarker(LatLng(position.latitude + markerOffset, position.longitude),
            "assets/images/Ellipse 378.png", "single_searching");
      }

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

  Future<void> _loadInitialPosition(String? imageUrl, String? type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? cachedLatitude = prefs.getDouble('latitude');
    double? cachedLongitude = prefs.getDouble('longitude');

    if (cachedLatitude != null && cachedLongitude != null) {
      setState(() {
        _initialPosition = LatLng(cachedLatitude, cachedLongitude);
      });
    }
    _getCurrentLocation(imageUrl, type);
  }

  void _onMarkerTapped(Marker tappedMarker) {
    double targetZoom = _isMarkerZoomed ? 14.0 : 20.0;
    _isMarkerZoomed = !_isMarkerZoomed;
    setState(() {
      for (var marker in _markers) {
        _markers = marker.copyWith(visibleParam: true) as Set<Marker>;
      }
    });

    setState(() {
      _markers = tappedMarker.copyWith(visibleParam: true) as Set<Marker>;
    });

    mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(tappedMarker.position, targetZoom),
    );
    //_showBottomSheet();
  }

  void _showBottomSheet({String? name, String? imageString, String? location}) {
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
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(imageString!),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${location!} - 16m ago',
                          style: const TextStyle(
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
                                _showBottomSheetForCard(user);
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

  void _showBottomSheetForCard(DiscoverUserModel? user) {
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
                JHSearchField(
                    searchController: _searchController,
                    searchLocation: _searchLocation),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: user?.relationshipType == "single_searching"
                              ? Colors.green
                              : Colors
                                  .red, // Change this to your desired border color
                          width:
                              3.0, // Change this to your desired border width
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundImage: user?.gallery?[0] == null
                            ? null
                            : NetworkImage(user!.gallery![0]),
                        radius: 30,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                        child: Container(
                            padding: const EdgeInsets.all(
                                12.5), // Set your desired padding
                            decoration: BoxDecoration(
                              color: const Color(
                                  0xFF2F2F2F), // Set your desired background color
                              borderRadius: BorderRadius.circular(
                                  15), // Set your desired border radius
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                        color: Colors.white38,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    height: 30,
                                    width: 60,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 0, vertical: 3.5),
                                      child: Image.asset(
                                        "assets/images/Vector (2).png",
                                        height: 10,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                        color: Colors.white38,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    height: 30,
                                    width: 60,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 0, vertical: 3.5),
                                      child: SvgPicture.asset(
                                        "assets/svgs/like.svg",
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                        color: Colors.white38,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    height: 30,
                                    width: 60,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 0, vertical: 3.5),
                                      child: SvgPicture.asset(
                                        "assets/svgs/calendar.svg",
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                        color: Colors.white38,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    height: 30,
                                    width: 60,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 0, vertical: 3.5),
                                      child: SvgPicture.asset(
                                        "assets/svgs/bookmark.svg",
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ))),
                  ],
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: cards.length,
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
                                  BSPlacesRouter(context, _initialPosition!)
                                      .showBottomSheetForSelectedCard(
                                          cards[index], user);
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset(
                                    images[index],
                                    fit: BoxFit.fill,
                                    width: 125,
                                    height: 125,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                title[index],
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
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

  void _toggleLocation(String? imageUrl, String? type) {
    setState(() {
      isLocationEnabled = !isLocationEnabled;
    });

    if (isLocationEnabled) {
      _getCurrentLocation(imageUrl, type);
    } else {
      _initialPosition = null;
    }
  }
}
