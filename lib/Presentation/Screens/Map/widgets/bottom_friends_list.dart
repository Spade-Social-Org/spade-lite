import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:spade_lite/Presentation/Screens/Map/widgets/bottom_times.dart';
import 'package:spade_lite/Presentation/Screens/Map/widgets/date_set.dart';

class BottomFriendsList extends StatefulWidget {
  const BottomFriendsList({Key? key}) : super(key: key);

  @override
  _BottomFriendsListState createState() => _BottomFriendsListState();
}

class _BottomFriendsListState extends State<BottomFriendsList> {
  int selectedFriendIndex = -1;

  final TextEditingController searchController = TextEditingController();

  final List<Map<String, dynamic>> friends = [
    {"image": "assets/images/Ellipse 368.png", "name": "Aohn Doe"},
    {"image": "assets/images/Ellipse 368.png", "name": "Bohn Doe"},
    {"image": "assets/images/Ellipse 368.png", "name": "Cohn Doe"},
    {"image": "assets/images/Ellipse 368.png", "name": "Dohn Doe"},
    {"image": "assets/images/Ellipse 368.png", "name": "Eohn Doe"},
    {"image": "assets/images/Ellipse 368.png", "name": "Fohn Doe"},
    {"image": "assets/images/Ellipse 368.png", "name": "Gohn Doe"},
    {"image": "assets/images/Ellipse 368.png", "name": "Hohn Doe"},
    {"image": "assets/images/Ellipse 368.png", "name": "Iohn Doe"},
    {"image": "assets/images/Ellipse 368.png", "name": "John Doe"},
  ];

  List<Map<String, dynamic>> filteredFriends = [];

  @override
  void initState() {
    super.initState();
    filteredFriends = List.from(friends);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    children: [
                      InkWell(
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) =>
                                BottomTimes(id: ''),
                          );
                        },
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const Text(
                        "Twisted Root Burger co",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                TextField(
                  controller: searchController,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  onChanged: (value) {
                    setState(() {
                      filteredFriends = friends
                          .where((friend) => friend['name']
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .toList();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Search for people",
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
                        size: 30,
                      ),
                      onPressed: () {},
                    ),
                  ),
                  textAlign: TextAlign.center,
                  onSubmitted: (_) {},
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7 - 170,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // Set the number of columns
                    ),
                    itemCount: filteredFriends.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedFriendIndex = index;
                          });
                          showDialog(
                            context: context,
                            builder: (context) => _buildPopOutDialog(
                              context,
                              filteredFriends[index],
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 40.0,
                                backgroundImage: AssetImage(
                                  filteredFriends[index]["image"],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                child: Text(
                                  filteredFriends[index]["name"],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPopOutDialog(BuildContext context, Map<String, dynamic> friend) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(),
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              CircleAvatar(
                radius: 165,
                backgroundImage: AssetImage(friend["image"]),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                friend["name"],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) => DateSet());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffffffff),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text(
                'Invite',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
