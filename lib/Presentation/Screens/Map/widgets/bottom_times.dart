import 'package:flutter/material.dart';
import 'package:spade_lite/Presentation/Screens/Calendar/calender_screen.dart';
import 'package:spade_lite/Presentation/Screens/Map/widgets/bottom_friends_list.dart';

class BottomTimes extends StatefulWidget {
  final String id;

  BottomTimes({required this.id});

  @override
  _BottomTimesState createState() => _BottomTimesState();
}

class _BottomTimesState extends State<BottomTimes> {
  String selectedTime = '';
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
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
                          const CalenderScreen());
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
                    fontSize: 20),
              ),
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                for (int i = 0; i < 24; i++)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTime =
                            '${i >= 13 ? i - 12 : i == 0 ? 12 : i} ${i >= 12 ? 'PM' : 'AM'}';
                        selectedIndex = i;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                            color: selectedIndex == i
                                ? const Color(0xffffffff)
                                : const Color(0xff2e2e2e)),
                        color: const Color(0xff2e2e2e),
                      ),
                      padding: const EdgeInsets.all(10.0),
                      margin: const EdgeInsets.only(bottom: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${i >= 13 ? i - 12 : i == 0 ? 12 : i} ${i >= 12 ? 'PM' : 'AM'}',
                            style: const TextStyle(
                                fontSize: 20.0, color: Colors.white),
                          ),
                          const Text(
                            'Available',
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                Center(
                  child: SizedBox(
                    width: 125,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) =>
                                const BottomFriendsList());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedTime.isNotEmpty
                            ? const Color(0xffffffff)
                            : const Color(0xff2e2e2e),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: selectedTime.isNotEmpty
                              ? Colors.black
                              : const Color(0xffb2afaf),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
