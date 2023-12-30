import 'package:flutter/material.dart';
import 'package:spade_lite/Data/Models/discover.dart';
import 'package:spade_lite/Presentation/Screens/Calendar/calender_screen.dart';
import 'package:spade_lite/prefs/pref_provider.dart';
import '../../../../Domain/Entities/place.dart';
import '../../../../Common/theme.dart';
import '../widgets/horizontal_image_list.dart';
import 'package:spade_lite/Presentation/widgets/jh_places_items.dart';

class BottomPlacesSheet extends StatelessWidget {
  final List<Place> places;
  final ScrollController scrollController;
  final DiscoverUserModel? user;

  const BottomPlacesSheet({
    super.key,
    required this.places,
    required this.scrollController,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: ListView(
        children: [
          const SizedBox(
            height: 2,
          ),
          Center(
            child: Container(
              width: 20 * 7,
              height: 6,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                shape: BoxShape.rectangle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: user?.relationshipType == "single_searching"
                            ? Colors.green
                            : Colors.red,
                        width: 3.0,
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundImage: user?.gallery?[0] == null
                          ? null
                          : NetworkImage(user!.gallery![0]),
                      radius: 30,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: TextField(
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: "Search for places",
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
                        onPressed: () {},
                      ),
                    ),
                    textAlign: TextAlign.center,
                    onSubmitted: (_) {},
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 2, right: 8),
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
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (int i = 0; i < 3; i++) ...[
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF333333),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 14,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  iconsRow[i],
                                  color: Colors.white,
                                  size: 24,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  text[i].toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (i < 2)
                            const SizedBox(
                              width: 20,
                            ),
                        ],
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
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 12,
                      ),
                      child: Text(
                        place.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 12,
                      ),
                      child: Text(
                        place.address,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Text(
                                place.openingHours,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: place.openingHours == 'Open now'
                                      ? CustomColors.greenPrimary
                                      : Colors.grey,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              '${place.distance.toStringAsFixed(2)} miles',
                              style: const TextStyle(
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
                                PrefProvider.savePlaceName(place.name);
                                PrefProvider.savePlaceId(place.id);
                                Navigator.of(context).pop();
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        topLeft: Radius.circular(20),
                                      ),
                                      child: CalenderScreen(),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                height: 30,
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Image.asset(
                              'assets/images/arrowforward.png',
                              width: 20,
                              height: 20,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Image.asset(
                                'assets/images/calendar-light.png',
                                width: 20,
                                height: 20,
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Image.asset(
                              'assets/images/hearticon.png',
                              width: 20,
                              height: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (place.imageURL.isNotEmpty)
                      HorizontalImageList(imageURLs: place.imageURL),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
