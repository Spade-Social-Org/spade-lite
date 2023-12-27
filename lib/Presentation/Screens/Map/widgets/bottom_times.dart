import 'package:flutter/material.dart';

class BottomTimes extends StatelessWidget {
  final String id;

  BottomTimes({required this.id});

  List<bool> getOpenStatusList(Map<String, dynamic> response) {
    List<bool> openStatusList = List.filled(24, false);

    // Extract opening hours data
    final periods = response['result']['current_opening_hours']['periods'];

    for (var period in periods) {
      final open = period['open'];
      final close = period['close'];

      if (open != null && close != null) {
        final openHour = int.parse(open['time'].substring(0, 2));
        final closeHour = int.parse(close['time'].substring(0, 2));

        // Increment count for the specified day and time range
        for (int i = openHour; i < closeHour; i++) {
          openStatusList[i] = true;
        }
      }
    }

    return openStatusList;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> response = {
      "result": {
        "current_opening_hours": {
          "open_now": true,
          "periods": [
            {
              "close": {"time": "1200"},
              "open": {"time": "0800"}
            },
            {
              "close": {"time": "1700"},
              "open": {"time": "1300"}
            }
          ],
        },
      },
    };

    List<bool> openStatusList = getOpenStatusList(response);
    return Container(
      color: Colors.black,
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Row(
            children: [
              Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
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
                for (int i = 0; i < openStatusList.length; i++)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
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
                        Text(
                          openStatusList[i] ? 'Available' : 'Unavailable',
                          style: const TextStyle(
                              fontSize: 20.0, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                Center(
                  child: SizedBox(
                    width: 125,
                    child: ElevatedButton(
                      onPressed: () {
                        // Add your button click logic here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
