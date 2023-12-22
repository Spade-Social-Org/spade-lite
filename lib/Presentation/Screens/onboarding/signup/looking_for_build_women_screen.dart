import 'package:flutter/material.dart';

import '../../Bottom_nav/navigation_container.dart';

class LookingForBuildWomenScreen extends StatefulWidget {
  const LookingForBuildWomenScreen({super.key});

  @override
  State<LookingForBuildWomenScreen> createState() =>
      _LookingForBuildWomenScreenState();
}

class _LookingForBuildWomenScreenState
    extends State<LookingForBuildWomenScreen> {
  String? _selectedType;

  void _selectType(String type) {
    setState(() {
      _selectedType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 18,
              top: 30,
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          const Center(
            child: Text(
              "What build are you looking for?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          const SizedBox(
            height: 60,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => _selectType('Petite'),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: _selectedType == 'Petite'
                        ? Colors.grey[300]
                        : Colors.white,
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, offset: Offset(0.0, 4.0))
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 140,
                  width: 146,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: 80,
                            child: Image.asset(
                              "assets/images/freepik--character-1--inject-316.png",
                              fit: BoxFit.fill,
                            )),
                        const Text("Petite")
                      ]),
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              GestureDetector(
                onTap: () => _selectType('Athletic'),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: _selectedType == 'Athletic'
                        ? Colors.grey[300]
                        : Colors.white,
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, offset: Offset(0.0, 4.0))
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 140,
                  width: 146,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: 80,
                            child: Image.asset(
                              "assets/images/freepik--character-3--inject-316.png",
                              fit: BoxFit.fill,
                            )),
                        const Text("Athletic")
                      ]),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => _selectType('Curvy'),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: _selectedType == 'Curvy'
                        ? Colors.grey[300]
                        : Colors.white,
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, offset: Offset(0.0, 4.0))
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 140,
                  width: 146,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: 80,
                            child: Image.asset(
                              "assets/images/freepik--character-5--inject-316.png",
                              fit: BoxFit.fill,
                            )),
                        const Text("Curvy")
                      ]),
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              GestureDetector(
                onTap: () => _selectType('BBW'),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: _selectedType == 'BBW'
                        ? Colors.grey[300]
                        : Colors.white,
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, offset: Offset(0.0, 4.0))
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 140,
                  width: 146,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: 80,
                            child: Image.asset(
                                "assets/images/freepik--character-2--inject-316.png")),
                        const Text("BBW")
                      ]),
                ),
              ),
            ],
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: MaterialButton(
                  height: 50,
                  minWidth: double.infinity,
                  color: Colors.black,
                  child: const Text(
                    "Next",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) =>
                                const NavigationContainer())));
                  }),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
