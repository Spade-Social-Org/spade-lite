import 'package:flutter/material.dart';
import 'package:spade_lite/Data/Models/discover.dart';
import 'package:spade_lite/Domain/Repository/get_user_repo.dart';
import 'package:spade_lite/prefs/pref_provider.dart';

class DateSet extends StatelessWidget {
  const DateSet({super.key});

  Future<Map<String, dynamic>> fetchDateDetails() async {
    String? placeName = await PrefProvider.getPlaceName();
    String? placeId = await PrefProvider.getPlaceId();
    String? date = await PrefProvider.getDate();
    String? time = await PrefProvider.getTime();
    String? inviteeName = await PrefProvider.getInviteeName();
    String? inviteeId = await PrefProvider.getInviteeId();
    String? inviteeImage = await PrefProvider.getInviteeImage();
    String? userId = await PrefProvider.getUserId();
    DiscoverUserModel? user = await GetUser().getUser();
    String? userImage = user?.gallery?[0];

    return {
      "placeName": placeName,
      "placeId": placeId,
      "date": date,
      "time": time,
      "inviteeName": inviteeName,
      "inviteeId": inviteeId,
      "inviteeImage": inviteeImage,
      "userId": userId,
      "userImage": userImage,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchDateDetails(),
      builder: (context, snapshot) {
        print(snapshot.data);
        if (snapshot.connectionState == ConnectionState.done) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            padding: const EdgeInsets.only(
              top: 20,
              bottom: 20,
            ),
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                const Text(
                  'The date is set!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            top: -25,
                            right: 25,
                            child: Transform.translate(
                              offset: const Offset(0, 50),
                              child: Transform.rotate(
                                angle: 0.25, // Adjust the angle as needed
                                child: _buildImage(snapshot.data?["userImage"]),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 100,
                            right: 170,
                            child: Transform.translate(
                              offset: const Offset(0, 50),
                              child: Transform.rotate(
                                angle: -0.25, // Adjust the angle as needed
                                child:
                                    _buildImage(snapshot.data?["inviteeImage"]),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 85,
                            right: 90,
                            child: _buildHeartImage(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: SizedBox(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: const Text(
                        'View Calender',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container(
            color: Colors.black,
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildImage(String? imagePath) {
    if (imagePath == null) {
      return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            'assets/images/Rectangle 1598.png',
            width: 175,
            height: 225,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),
      );
    }
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          imagePath,
          width: 175,
          height: 225,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
      ),
    );
  }

  Widget _buildHeartImage() {
    return Container(
      width: 200,
      height: 200,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/date-heart.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
