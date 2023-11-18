import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spade_lite/Presentation/widgets/jh_calendar.dart';
import 'package:spade_lite/Presentation/widgets/jh_places_items.dart';
import '../../../Common/theme.dart';
import '../../widgets/jh_custom_marker.dart';
import '../../widgets/jh_loader.dart';
import '../../widgets/jh_logger.dart';
import '../../widgets/jh_search_bar.dart';

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

  final Map<String, Marker> _markers = {};
  Set<Polyline> polylines = {};
  bool loadingLocation = true;
  bool isLocationEnabled = false;
  bool trafficEnabled = false;
  late Geolocator geolocator;
  LatLng? _initialPosition;
  LatLng? _searchedLocation;

  @override
  void initState() {
    super.initState();

    ///Load map theme
    DefaultAssetBundle.of(context)
        .loadString('assets/maptheme/nighttheme.json')
        .then((value) {
      mapTheme = value;
    });
    _loadInitialPosition();
    _getCurrentLocation();
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
      double markerOffset = 0.0002;
      addMarker(
        'USER',
        LatLng(position.latitude + markerOffset, position.longitude),
      );
      addMarker2(
        'USER 2',
        const LatLng(5.973490, 6.862013),
      );
      addMarker4(
        'USER 3',
        const LatLng(5.952930, 6.848727),
      );
      // addMarker4(
      //   'USER 4',
      //   LatLng(5.9601322, 6.8475589),
      // );
      addMarker5(
        'USER 5',
        const LatLng(5.972808, 6.837499),
      );
      // addMarker6(
      //   'USER 6',
      //   LatLng(5.9601322, 6.8475589),
      // );
      addMarker7(
        'USER 7',
        const LatLng(5.961376, 6.834071),
      );
      addMarker7(
        'USER 8',
        const LatLng(5.993973, 6.862863),
      );

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
            //trafficEnabled: trafficEnabled,
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
              onTap: _showBottomSheet,
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
                _friendsList();
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

  final Set<Circle> _circle = {};

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

  addMarker(String id, LatLng location) async {
    var customMarkerIcon = CustomMarkerIcon(
      size: 120,
      imagePath: 'assets/images/Ellipse 365.png',
      backgroundColor: Colors.grey.withOpacity(0.5),
    );
    var marker = Marker(
      markerId: MarkerId(id),
      position: location,
      infoWindow: const InfoWindow(title: 'Mr Josh', snippet: 'Hello friend'),
      icon: await customMarkerIcon.createMarkerIcon(),
    );
    _markers[id] = marker;
    setState(() {});
  }

  addMarker2(String id, LatLng location) async {
    var customMarkerIcon = CustomMarkerIcon(
      size: 120,
      imagePath: 'assets/images/Ellipse 366.png',
      backgroundColor: Colors.grey.withOpacity(0.5),
    );
    var marker = Marker(
      markerId: MarkerId(id),
      position: location,
      infoWindow: const InfoWindow(title: 'Jennifer', snippet: 'Hello friend'),
      icon: await customMarkerIcon.createMarkerIcon(),
    );
    _markers[id] = marker;
    setState(() {});
  }

  addMarker3(String id, LatLng location) async {
    var customMarkerIcon = CustomMarkerIcon(
      size: 120,
      imagePath: 'assets/images/Ellipse 367.png',
      backgroundColor: Colors.grey.withOpacity(0.5),
    );
    var marker = Marker(
      markerId: MarkerId(id),
      position: location,
      infoWindow:
          const InfoWindow(title: 'Mrs Sandra', snippet: 'Hello friend'),
      icon: await customMarkerIcon.createMarkerIcon(),
    );
    _markers[id] = marker;
    setState(() {});
  }

  addMarker4(String id, LatLng location) async {
    var customMarkerIcon = CustomMarkerIcon(
      size: 120,
      imagePath: 'assets/images/Ellipse 372.png',
      backgroundColor: Colors.grey.withOpacity(0.5),
    );
    var marker = Marker(
      markerId: MarkerId(id),
      position: location,
      infoWindow: const InfoWindow(title: 'Maryjane', snippet: 'Hello friend'),
      icon: await customMarkerIcon.createMarkerIcon(),
    );
    _markers[id] = marker;
    setState(() {});
  }

  addMarker5(String id, LatLng location) async {
    var customMarkerIcon = CustomMarkerIcon(
      size: 120,
      imagePath: 'assets/images/Ellipse 378.png',
      backgroundColor: Colors.grey.withOpacity(0.5),
    );
    var marker = Marker(
      markerId: MarkerId(id),
      position: location,
      infoWindow: const InfoWindow(title: 'Cynthia', snippet: 'Hello friend'),
      icon: await customMarkerIcon.createMarkerIcon(),
    );
    _markers[id] = marker;
    setState(() {});
  }

  addMarker6(String id, LatLng location) async {
    var customMarkerIcon = CustomMarkerIcon(
      size: 120,
      imagePath: 'assets/images/Ellipse 379.png',
      backgroundColor: Colors.grey.withOpacity(0.5),
    );
    var marker = Marker(
      markerId: MarkerId(id),
      position: location,
      infoWindow: const InfoWindow(title: 'Mary', snippet: 'Hello friend'),
      icon: await customMarkerIcon.createMarkerIcon(),
    );
    _markers[id] = marker;
    setState(() {});
  }

  addMarker7(String id, LatLng location) async {
    var customMarkerIcon = CustomMarkerIcon(
      size: 120,
      imagePath: 'assets/images/Ellipse 369.png',
      backgroundColor: Colors.grey.withOpacity(0.5),
    );
    var marker = Marker(
      markerId: MarkerId(id),
      position: location,
      infoWindow: const InfoWindow(title: 'Esther', snippet: 'Hello friend'),
      icon: await customMarkerIcon.createMarkerIcon(),
    );
    _markers[id] = marker;
    setState(() {});
  }

  void _showBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      //isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        top: Radius.circular(30),
      )),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          minChildSize: 0.2,
          builder: (BuildContext context, ScrollController) => ListView(
            controller: ScrollController,
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
              const JHSearchField(),
              Row(
                children: [
                  const CircleAvatar(
                    backgroundImage:
                        AssetImage("assets/images/Ellipse 378.png"),
                    radius: 30,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 2),
                              color: Colors.white38,
                              borderRadius: BorderRadius.circular(20)),
                          height: 30,
                          width: 60,
                          child: Image.asset("assets/images/Vector (2).png"),
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            color: Colors.white38,
                            borderRadius: BorderRadius.circular(20)),
                        height: 30,
                        width: 60,
                        child: const Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //             CalenderScreen()));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 2),
                              color: Colors.white38,
                              borderRadius: BorderRadius.circular(20)),
                          height: 30,
                          width: 60,
                          child: const Icon(
                            Icons.calendar_month_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            color: Colors.white38,
                            borderRadius: BorderRadius.circular(20)),
                        height: 30,
                        width: 60,
                        child: const Icon(
                          Icons.bookmark_border_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                ],
              ),
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
                                switch (index) {
                                  case 0:
                                    _RestaurantBottomSheet();
                                    break;
                                  case 1:
                                    _HotelsBottomSheet();
                                    break;
                                  case 2:
                                    _MovieBottomSheet();
                                    break;
                                  case 3:
                                    _ClubsBottomSheet();
                                    break;
                                  case 4:
                                    _MuseumBottomSheet();
                                    break;
                                  default:
                                    break;
                                }
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  color: Colors.white,
                                  height: 90,
                                  width: 100,
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
        );
      },
    );
  }

  void _RestaurantBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        top: Radius.circular(30),
      )),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.4,
          minChildSize: 0.1,
          builder: (BuildContext context, ScrollController) => ListView(
            controller: ScrollController,
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
                      backgroundImage:
                          AssetImage("assets/images/Ellipse 378.png"),
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
                          fillColor: const Color(0xFF333333),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12),
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
                          width: 94,
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
              const SizedBox(
                height: 8,
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 12,
                ),
                child: Text(
                  'Fusion Vibes Kitchen + Lounge',
                  style: TextStyle(
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
                          _calendarBottomSheet();
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
                      Image.asset('assets/images/arrowforward.png', width: 18),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            _calendarBottomSheet();
                          },
                          child: Image.asset('assets/images/calendar.png',
                              width: 18)),
                      const SizedBox(
                        width: 5,
                      ),
                      Image.asset('assets/images/hearticon.png', width: 18),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 250,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: restaurantImages.length,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 90 * 10,
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: AssetImage(restaurantImages[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 12,
                ),
                child: Text(
                  'West African Way',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 12,
                ),
                child: Text(
                  'African cusine',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
              Row(
                children: [
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Text(
                          'Open now',
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
                        '1.6 miles',
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
                          _calendarBottomSheet();
                        },
                        child: Container(
                            height: 25,
                            width: 60 * 2,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
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
                      Image.asset('assets/images/arrowforward.png', width: 18),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            _calendarBottomSheet();
                          },
                          child: Image.asset('assets/images/calendar.png',
                              width: 18)),
                      const SizedBox(
                        width: 5,
                      ),
                      Image.asset('assets/images/hearticon.png', width: 18),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 250,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: restaurantImages.length,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 90 * 10,
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: AssetImage(restaurantImages[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 12,
                ),
                child: Text(
                  'West African Way',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 12,
                ),
                child: Text(
                  'African Cusine',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
              Row(
                children: [
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Text(
                          'Open now',
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
                          _calendarBottomSheet();
                        },
                        child: Container(
                            height: 25,
                            width: 60 * 2,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
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
                      Image.asset('assets/images/arrowforward.png', width: 18),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            _calendarBottomSheet();
                          },
                          child: Image.asset('assets/images/calendar.png',
                              width: 18)),
                      const SizedBox(
                        width: 5,
                      ),
                      Image.asset('assets/images/hearticon.png', width: 18),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 250,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: restaurantImages.length,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 90 * 10,
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: AssetImage(restaurantImages[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        );
      },
    );
  }

  void _HotelsBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        top: Radius.circular(30),
      )),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.4,
          minChildSize: 0.1,
          builder: (BuildContext context, ScrollController) => ListView(
            controller: ScrollController,
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
                      backgroundImage:
                          AssetImage("assets/images/Ellipse 378.png"),
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
                          fillColor: const Color(0xFF333333),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12),
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
                          width: 94,
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
              const Padding(
                padding: EdgeInsets.only(
                  left: 12,
                ),
                child: Text(
                  'Hilton Dallas/Park Cities',
                  style: TextStyle(
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
                  'Tripadvisor',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
              Row(
                children: [
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Text(
                          'Open now',
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
                          _calendarBottomSheet();
                        },
                        child: Container(
                            height: 25,
                            width: 60 * 2,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text(
                                'Book Now',
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
                      Image.asset('assets/images/arrowforward.png', width: 18),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            _calendarBottomSheet();
                          },
                          child: Image.asset('assets/images/calendar.png',
                              width: 18)),
                      const SizedBox(
                        width: 5,
                      ),
                      Image.asset('assets/images/hearticon.png', width: 18),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 250,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: hotelImages.length,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 90 * 10,
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: AssetImage(hotelImages[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 12,
                ),
                child: Text(
                  'Kimptom Pittman Hotel',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 12,
                ),
                child: Text(
                  'Tripadvisor',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
              Row(
                children: [
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Text(
                          'Open now',
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
                        '1.6 miles',
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
                          _calendarBottomSheet();
                        },
                        child: Container(
                            height: 25,
                            width: 60 * 2,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text(
                                'Book Now',
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
                      Image.asset('assets/images/arrowforward.png', width: 18),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            _calendarBottomSheet();
                          },
                          child: Image.asset('assets/images/calendar.png',
                              width: 18)),
                      const SizedBox(
                        width: 5,
                      ),
                      Image.asset('assets/images/hearticon.png', width: 18),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 250,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: hotelImages.length,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 90 * 10,
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: AssetImage(hotelImages[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 12,
                ),
                child: Text(
                  'Kimptom Pittman Hotel',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 12,
                ),
                child: Text(
                  'Tripadvisor',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
              Row(
                children: [
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Text(
                          'Open now',
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
                          _calendarBottomSheet();
                        },
                        child: Container(
                            height: 25,
                            width: 60 * 2,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text(
                                'Book Now',
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
                      Image.asset('assets/images/arrowforward.png', width: 18),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            _calendarBottomSheet();
                          },
                          child: Image.asset('assets/images/calendar.png',
                              width: 18)),
                      const SizedBox(
                        width: 5,
                      ),
                      Image.asset('assets/images/hearticon.png', width: 18),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 250,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: hotelImages.length,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 90 * 10,
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: AssetImage(hotelImages[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        );
      },
    );
  }

  void _MovieBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        top: Radius.circular(30),
      )),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.4,
          minChildSize: 0.1,
          builder: (BuildContext context, ScrollController) => ListView(
            controller: ScrollController,
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
                      backgroundImage:
                          AssetImage("assets/images/Ellipse 378.png"),
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
                          fillColor: const Color(0xFF333333),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12),
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
                          width: 94,
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
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 12,
                ),
                child: Text(
                  'Landmark\'s Inwood Theatre',
                  style: TextStyle(
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
                  'Tripadvisor Cinema',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              Row(
                children: [
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Text(
                          'Open now',
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
                          _calendarBottomSheet();
                        },
                        child: Container(
                            height: 25,
                            width: 60 * 2,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text(
                                'Buy Ticket',
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
                      Image.asset('assets/images/arrowforward.png', width: 18),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            _calendarBottomSheet();
                          },
                          child: Image.asset('assets/images/calendar.png',
                              width: 18)),
                      const SizedBox(
                        width: 5,
                      ),
                      Image.asset('assets/images/hearticon.png', width: 18),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 250,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: moviesImages.length,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 90 * 10,
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: AssetImage(moviesImages[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 12,
                ),
                child: Text(
                  'Cinapolis Luxury Cinemas',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 12,
                ),
                child: Text(
                  'Tripadvisor Cinema',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              Row(
                children: [
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Text(
                          'Open now',
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
                        '1.6 miles',
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
                          _calendarBottomSheet();
                        },
                        child: Container(
                            height: 25,
                            width: 60 * 2,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text(
                                'Buy Ticket',
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
                      Image.asset('assets/images/arrowforward.png', width: 18),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            _calendarBottomSheet();
                          },
                          child: Image.asset('assets/images/calendar.png',
                              width: 18)),
                      const SizedBox(
                        width: 5,
                      ),
                      Image.asset('assets/images/hearticon.png', width: 18),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 250,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: moviesImages.length,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 90 * 10,
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: AssetImage(moviesImages[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 12,
                ),
                child: Text(
                  'Cinapolis Luxury Cinemas',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 12,
                ),
                child: Text(
                  'Tripadvisor Cinema',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              Row(
                children: [
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Text(
                          'Open now',
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
                          _calendarBottomSheet();
                        },
                        child: Container(
                            height: 25,
                            width: 60 * 2,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text(
                                'Buy Tickets',
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
                      Image.asset('assets/images/arrowforward.png', width: 18),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            _calendarBottomSheet();
                          },
                          child: Image.asset('assets/images/calendar.png',
                              width: 18)),
                      const SizedBox(
                        width: 5,
                      ),
                      Image.asset('assets/images/hearticon.png', width: 18),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 250,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: moviesImages.length,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 90 * 10,
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: AssetImage(moviesImages[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        );
      },
    );
  }

  void _MuseumBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        top: Radius.circular(30),
      )),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.4,
          minChildSize: 0.1,
          builder: (BuildContext context, ScrollController) => ListView(
            controller: ScrollController,
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
                      backgroundImage:
                          AssetImage("assets/images/Ellipse 378.png"),
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
                          fillColor: const Color(0xFF333333),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12),
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
                          width: 94,
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
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 12,
                ),
                child: Text(
                  'Houston Museum of Natural Science',
                  style: TextStyle(
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
                  'Tripadvisor Art Museum',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              Row(
                children: [
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Text(
                          'Open now',
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
                          _calendarBottomSheet();
                        },
                        child: Container(
                            height: 25,
                            width: 60 * 2,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text(
                                'Get Ticket',
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
                      Image.asset('assets/images/arrowforward.png', width: 18),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            _calendarBottomSheet();
                          },
                          child: Image.asset('assets/images/calendar.png',
                              width: 18)),
                      const SizedBox(
                        width: 5,
                      ),
                      Image.asset('assets/images/hearticon.png', width: 18),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 250,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: museumImages.length,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 90 * 10,
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: AssetImage(museumImages[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 12,
                ),
                child: Text(
                  'Art Car Museum',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 12,
                ),
                child: Text(
                  'Tripadvisor Art Museum',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              Row(
                children: [
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Text(
                          'Open now',
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
                        '1.6 miles',
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
                          _calendarBottomSheet();
                        },
                        child: Container(
                            height: 25,
                            width: 60 * 2,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text(
                                'Get Ticket',
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
                      Image.asset('assets/images/arrowforward.png', width: 18),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            _calendarBottomSheet();
                          },
                          child: Image.asset('assets/images/calendar.png',
                              width: 18)),
                      const SizedBox(
                        width: 5,
                      ),
                      Image.asset('assets/images/hearticon.png', width: 18),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 250,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: museumImages.length,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 90 * 10,
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: AssetImage(museumImages[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 12,
                ),
                child: Text(
                  'Space Center Houston',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 12,
                ),
                child: Text(
                  'Tripadvisor Art Museum',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              Row(
                children: [
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Text(
                          'Open now',
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
                          _calendarBottomSheet();
                        },
                        child: Container(
                            height: 25,
                            width: 60 * 2,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text(
                                'Get Ticket',
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
                      Image.asset('assets/images/arrowforward.png', width: 18),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            _calendarBottomSheet();
                          },
                          child: Image.asset('assets/images/calendar.png',
                              width: 18)),
                      const SizedBox(
                        width: 5,
                      ),
                      Image.asset('assets/images/hearticon.png', width: 18),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 250,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: museumImages.length,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 90 * 10,
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: AssetImage(museumImages[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        );
      },
    );
  }

  void _ClubsBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        top: Radius.circular(30),
      )),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.4,
          minChildSize: 0.1,
          builder: (BuildContext context, ScrollController) => ListView(
            controller: ScrollController,
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
                      backgroundImage:
                          AssetImage("assets/images/Ellipse 378.png"),
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
                          fillColor: const Color(0xFF333333),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12),
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
                          width: 94,
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
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 12,
                ),
                child: Text(
                  'Club z' ,
                  style: TextStyle(
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
                  'Tripadvisor Dance club',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              Row(
                children: [
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Text(
                          'Open now',
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
                          _calendarBottomSheet();
                        },
                        child: Container(
                            height: 25,
                            width: 60 * 2,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text(
                                'Join now',
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
                      Image.asset('assets/images/arrowforward.png', width: 18),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            _calendarBottomSheet();
                          },
                          child: Image.asset('assets/images/calendar.png',
                              width: 18)),
                      const SizedBox(
                        width: 5,
                      ),
                      Image.asset('assets/images/hearticon.png', width: 18),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 250,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: clubsImages.length,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 90 ,
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: AssetImage(clubsImages[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 12,
                ),
                child: Text(
                  'Number Night Club',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 12,
                ),
                child: Text(
                  'Tripadvisor jazz & blues',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              Row(
                children: [
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Text(
                          'Open now',
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
                        '1.6 miles',
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
                          _calendarBottomSheet();
                        },
                        child: Container(
                            height: 25,
                            width: 60 * 2,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text(
                                'Join now',
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
                      Image.asset('assets/images/arrowforward.png', width: 18),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            _calendarBottomSheet();
                          },
                          child: Image.asset('assets/images/calendar.png',
                              width: 18)),
                      const SizedBox(
                        width: 5,
                      ),
                      Image.asset('assets/images/hearticon.png', width: 18),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 250,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: clubsImages.length,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 90 * 10,
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: AssetImage(clubsImages[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 12,
                ),
                child: Text(
                  'The Big Easy Logo',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 12,
                ),
                child: Text(
                  'Tripadvisor jazz & blues',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              Row(
                children: [
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Text(
                          'Open now',
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
                          _calendarBottomSheet();
                        },
                        child: Container(
                            height: 25,
                            width: 60 * 2,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text(
                                'Join now',
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
                      Image.asset('assets/images/arrowforward.png', width: 18),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            _calendarBottomSheet();
                          },
                          child: Image.asset('assets/images/calendar.png',
                              width: 18)),
                      const SizedBox(
                        width: 5,
                      ),
                      Image.asset('assets/images/hearticon.png', width: 18),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 250,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: clubsImages.length,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 90 * 10,
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: AssetImage(clubsImages[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        );
      },
    );
  }

  void _friendsList() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        top: Radius.circular(30),
      )),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          minChildSize: 0.1,
          builder: (BuildContext context, ScrollController) => ListView(
            controller: ScrollController,
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
              const JHSearchField(),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 900,
                child: GridView.builder(
                    primary: false,
                    shrinkWrap: true,
                    // scrollDirection: Axis.horizontal,
                    controller: ScrollController,
                    itemCount: friend.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedContainerIndex = index;
                          });
                        },
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: friend[index].color, width: 3),
                                      borderRadius: BorderRadius.circular(40),
                                      color: Colors.grey,
                                      image: DecorationImage(
                                          image:
                                              AssetImage(friend[index].images),
                                          fit: BoxFit.cover)),
                                  transform: (selectedContainerIndex == index)
                                      ? Matrix4.diagonal3Values(1.5, 1.5, 1)
                                      : Matrix4.identity(),
                                  height: 100,
                                  width: 100,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.black38,
                                      borderRadius: BorderRadius.circular(40)),
                                  height: 100,
                                  width: 100,
                                ),
                                if (selectedContainerIndex != index)
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black38,
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    height: 100,
                                    width: 100,
                                  ),
                              ],
                            )),
                      );
                    }),
              ),
            ],
          ),
        );
      },
    );
  }

  void _calendarBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        top: Radius.circular(30),
      )),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.6,
            minChildSize: 0.1,
            builder: (BuildContext context, ScrollController) =>
                ListView(children: [
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
                  const SizedBox(
                    height: 8,
                  ),
                  const JHCalenderWidget(),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 80, right: 80),
                    child: MaterialButton(
                      height: 50,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.of(context).pop();
                        _sheduleTime();
                      },
                      child: const Text(
                        "Next",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ]));
      },
    );
  }

  void _sheduleTime() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        top: Radius.circular(30),
      )),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.6,
            minChildSize: 0.1,
            builder: (BuildContext context, ScrollController) => ListView(
                  controller: ScrollController,
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
                    const Padding(
                      padding: EdgeInsets.all(18.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 100,
                          ),
                          Text(
                            "Twisted Root Burger co",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: scheduleNotice.length,
                        itemBuilder: (BuildContext context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedItemIndex = index;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 20.0, bottom: 10),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.white30,
                                          border: Border.all(
                                              width: 3,
                                              color: selectedItemIndex == index
                                                  ? Colors.white
                                                  : Colors.transparent)),
                                      height: 40,
                                      width: double.infinity,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Row(children: [
                                          Text(
                                            scheduleTime[index],
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white),
                                          ),
                                          const SizedBox(width: 40),
                                          Text(
                                            scheduleNotice[index],
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white),
                                          )
                                        ]),
                                      )),
                                ),
                              ),
                            ),
                          );
                        }),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 80, right: 80, bottom: 20),
                      child: MaterialButton(
                        height: 50,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: selectedItemIndex != -1
                            ? Colors.white
                            : Colors.white30,
                        onPressed: () {
                          Navigator.of(context).pop();
                          _inviteScreen();
                        },
                        child: Text(
                          "Next",
                          style: TextStyle(
                              color: selectedItemIndex != -1
                                  ? Colors.black
                                  : Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ));
      },
    );
  }

  void _inviteScreen() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        top: Radius.circular(30),
      )),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          minChildSize: 0.1,
          builder: (BuildContext context, ScrollController) => ListView(
            controller: ScrollController,
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
              const Padding(
                padding: EdgeInsets.all(18.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Twisted Bugger co",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 300,
                child: GridView.builder(
                    primary: false,
                    shrinkWrap: true,
                    // scrollDirection: Axis.horizontal,
                    controller: ScrollController,
                    itemCount: 15,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedContainerIndex = index;
                          });
                        },
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: friend[index].color, width: 3),
                                      borderRadius: BorderRadius.circular(40),
                                      color: Colors.grey,
                                      image: DecorationImage(
                                          image:
                                              AssetImage(friend[index].images),
                                          fit: BoxFit.cover)),
                                  height: 100,
                                  width: 100,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.black38,
                                      borderRadius: BorderRadius.circular(40)),
                                  height: 100,
                                  width: 100,
                                ),
                                if (selectedContainerIndex != index)
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black38,
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    height: 100,
                                    width: 100,
                                  ),
                              ],
                            )),
                      );
                    }),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 80, right: 80),
                child: MaterialButton(
                  height: 50,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop();
                    _setDate();
                  },
                  child: const Text(
                    "Invite",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _setDate() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        top: Radius.circular(30),
      )),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          minChildSize: 0.1,
          builder: (BuildContext context, ScrollController) => ListView(
            controller: ScrollController,
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
              const SizedBox(
                height: 5,
              ),
              const Center(
                  child: Text(
                "The Date is set!",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              )),
              SizedBox(
                height: 400,
                child: Stack(
                  children: [
                    Positioned(
                      left: 80,
                      bottom: 5,
                      child: Transform.rotate(
                        angle: -0.2,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height: 250,
                            width: 150,
                            color: Colors.white,
                            child:
                                Image.asset("assets/images/Rectangle 1595.png"),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 70,
                      top: 10,
                      child: Transform.rotate(
                        angle: 0.2,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height: 250,
                            width: 150,
                            color: Colors.white,
                            child: Image.asset(
                              "assets/images/Rectangle 1595.png",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Center(
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.favorite,
                          color: Color(0xFF155332),
                          size: 50,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 80, right: 80),
                child: MaterialButton(
                  height: 50,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.white,
                  onPressed: () {},
                  child: const Text(
                    "View Calender Date",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
