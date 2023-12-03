import 'package:flutter/material.dart';
import 'package:spade_lite/Presentation/Screens/onboarding/widgets/discover_image.dart';

class DiscoverPeople extends StatefulWidget {
  const DiscoverPeople({super.key});

  @override
  State<DiscoverPeople> createState() => _DiscoverPeopleState();
}

class _DiscoverPeopleState extends State<DiscoverPeople> {
  bool isSingleSwitched = false;
  bool isRedSwitched = false;
  bool isLongSwitched = false;
  bool isFriendSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        title: const Text(
          "Discover people with similar interests!",
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DiscoverImage(
                        color: const Color.fromARGB(255, 9, 65, 11),
                        image: 'assets/images/Group 949.png',
                        imageDesc:
                            'Single and searching for a casual relationship',
                        imageTile: 'Single',
                        isSwitched: isSingleSwitched,
                        onchange: (bool) {
                          setState(() {
                            isSingleSwitched = bool;
                          });
                        },
                      ),
                      DiscoverImage(
                        color: const Color.fromARGB(255, 146, 2, 2),
                        image: 'assets/images/Online dating-cuate 1.png',
                        imageDesc: 'Find friends with benefits or hookups',
                        imageTile: 'Red Light District',
                        isSwitched: isRedSwitched,
                        onchange: (bool) {
                          setState(() {
                            isRedSwitched = bool;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DiscoverImage(
                        color: const Color.fromARGB(255, 29, 29, 29),
                        image: 'assets/images/Couple-cuate (1) 1.png',
                        imageDesc:
                            'look for a long term or serious relationship',
                        imageTile: 'Long Term',
                        isSwitched: isLongSwitched,
                        onchange: (bool) {
                          setState(() {
                            isLongSwitched = bool;
                          });
                        },
                      ),
                      DiscoverImage(
                        color: const Color.fromARGB(255, 255, 208, 0),
                        image: 'assets/images/Group discussion-cuate 1.png',
                        imageDesc:
                            'Explore friends and connect with new people',
                        imageTile: 'Friend Group',
                        isSwitched: isFriendSwitched,
                        onchange: (bool) {
                          setState(() {
                            isFriendSwitched = bool;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: MaterialButton(
                    height: 50,
                    minWidth: double.infinity,
                    color: Colors.black,
                    child: const Text(
                      "Next",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: ((context) => const Question1())));
                    }),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
