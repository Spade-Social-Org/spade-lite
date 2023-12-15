import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spade_lite/Presentation/Screens/Home/providers/feed_provider.dart';
import 'package:spade_lite/Presentation/Screens/Map/map_screen.dart';

import '../Camera/camera_screen.dart';
import '../Home/presentation/home_screen.dart';
import '../messages/message_screen.dart';

class NavigationContainer extends StatefulWidget {
  const NavigationContainer({super.key});

  @override
  State<NavigationContainer> createState() => _NavigationContainerState();
}

class _NavigationContainerState extends State<NavigationContainer> {
  int selectedIndex = 0;
  int _PageIndex = 0;
  bool _showOption = false;
  int card_click = 0;
  PageController get _pageController => FeedRepo.pageController;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeScreen(),
      const MessageScreen(),
      const GoogleMapScreen(),
    ];

    final List<Widget> appPage = [
      const CameraScreen(
        receiverId: '',
      ),
    ];
    SystemUiOverlayStyle customStatusBarStyle = const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: customStatusBarStyle,
      child: Consumer(builder: (context, ref, _) {
        return Scaffold(
          body: selectedIndex == 0 || selectedIndex == 0
              ? PageView(
                  controller: FeedRepo.pageController,
                  onPageChanged: _onPageChanged,
                  children: [
                    appPage[0],
                    pages[0],
                  ],
                )
              : pages[selectedIndex],
          bottomNavigationBar: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: double.infinity,
                height: 70.0,
                color: Colors.black,
              ),
              BottomNavigationBar(
                useLegacyColorScheme: true,
                type: BottomNavigationBarType.fixed,
                currentIndex: selectedIndex,
                onTap: (index) {
                  setState(() {
                    if (selectedIndex == 2 && index == 2) {
                      _showOption = true;
                    } else {
                      _showOption = false;
                      selectedIndex = index;
                    }
                  });
                },
                backgroundColor: Colors.black,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.grey,
                selectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.bold),
                items: [
                  BottomNavigationBarItem(
                    icon: Image.asset(
                        selectedIndex == 0
                            ? "assets/images/spade-light.png"
                            : "assets/images/spade-small.png",
                        height: 24),
                    label: "",
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      selectedIndex == 1
                          ? "assets/images/message-light.png"
                          : "assets/images/message.png",
                      width: 24,
                      height: 24,
                    ),
                    label: "",
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      selectedIndex == 3
                          ? "assets/images/global-light.png"
                          : "assets/images/global.png",
                      width: 24,
                      height: 24,
                    ),
                    label: "",
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void _onIconTapped(int index) {
    setState(() {
      selectedIndex = index;
      _PageIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void _onPageChanged(int index) {
    if (_PageIndex != index) {
      setState(() {
        _PageIndex = index;
      });
    }
  }

  void _zoneClick(int index) {
    if (card_click == index) {
      setState(() {
        card_click = 0;
        _showOption = false;
      });
    } else {
      setState(() {
        card_click = index;
        _showOption = false;
      });
    }
  }
}
