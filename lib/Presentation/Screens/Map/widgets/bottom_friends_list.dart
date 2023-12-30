import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:spade_lite/Presentation/Screens/Map/models/FriendsModel.dart';
import 'package:spade_lite/Presentation/Screens/Map/widgets/bottom_times.dart';
import 'package:spade_lite/Presentation/Screens/Map/widgets/date_set.dart';
import 'package:spade_lite/prefs/pref_provider.dart';
import 'package:http/http.dart' as http;

class BottomFriendsList extends StatefulWidget {
  const BottomFriendsList({super.key});

  @override
  _BottomFriendsListState createState() => _BottomFriendsListState();
}

class _BottomFriendsListState extends State<BottomFriendsList> {
  int selectedFriendIndex = -1;

  final TextEditingController searchController = TextEditingController();

  List<dynamic> filteredFriends = [];

  List<Friend> friends = [];

  @override
  void initState() {
    super.initState();
    getMatches().then((friendList) {
      setState(() {
        friends = friendList;
      });
    });
  }

  Future<List<Friend>> getMatches() async {
    String? token = await PrefProvider.getUserToken();
    final response = await http.get(
      Uri.parse(
        'https://spade-backend-v3-production.up.railway.app/api/v1/users/matches',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);

      if (data['statusCode'] == 'SUCCESS' && data['data'] is List) {
        List<Friend> friendList = [];
        for (var friendData in data['data']) {
          if (friendData is Map<String, dynamic>) {
            Friend friend = Friend(
              userId: friendData['user_id'],
              name: friendData['name'],
              image: List<String>.from([friendData['image']]),
            );
            friendList.add(friend);
          }
        }
        return friendList;
      }
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.7,
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
                                const BottomTimes(),
                          );
                        },
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      FutureBuilder<String?>(
                        future: PrefProvider.getPlaceName(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            );
                          } else {
                            return const Text(
                              'Loading...',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            );
                          }
                        },
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
                      filteredFriends.clear();
                      if (value.isNotEmpty) {
                        setState(() {
                          filteredFriends.clear();
                          if (value.isNotEmpty) {
                            filteredFriends = friends
                                .where((friend) => friend.name
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();
                          }
                        });
                      }
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
                FutureBuilder<List<Friend>>(
                  future: getMatches(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      friends = snapshot.data!;
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7 - 170,
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                          ),
                          itemCount: searchController.text.isNotEmpty
                              ? filteredFriends.length
                              : snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final friend = searchController.text.isNotEmpty
                                ? filteredFriends[index]
                                : snapshot.data![index];

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedFriendIndex = index;
                                });
                                showDialog(
                                  context: context,
                                  builder: (context) => _buildPopOutDialog(
                                    context,
                                    friend,
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 40.0,
                                      backgroundImage: NetworkImage(
                                        friend.image[0],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Expanded(
                                      child: Text(
                                        friend.name,
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
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.data == []) {
                      return const Center(
                        child: Text(
                          'No friend found',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      );
                    } else {
                      print("Error: ${snapshot.error}");
                      return const Center(
                        child: Text(
                          'Failed to get friends list',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPopOutDialog(BuildContext context, Friend friend) {
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
                backgroundImage: NetworkImage(
                  friend.image[0],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                friend.name,
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
                    builder: (BuildContext context) => const DateSet());
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
