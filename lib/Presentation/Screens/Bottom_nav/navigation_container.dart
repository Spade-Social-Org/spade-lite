import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spade_lite/Presentation/Screens/Home/providers/feed_provider.dart';
import 'package:spade_lite/Presentation/Screens/onboarding/provider/notif_provider.dart';
import 'package:spade_lite/core/push_notifications_utils.dart';
import 'package:spade_lite/prefs/pref_provider.dart';

import '../Camera/camera_screen.dart';
import '../Home/presentation/home_screen.dart';
import '../Map/map_screen.dart';
import '../messages/presentation/message_screen.dart';

class NavigationContainer extends ConsumerStatefulWidget {
  const NavigationContainer({super.key});

  @override
  ConsumerState<NavigationContainer> createState() =>
      _NavigationContainerState();
}

class _NavigationContainerState extends ConsumerState<NavigationContainer> {
  int selectedIndex = 0;
  int pageIndex = 0;
  PageController get _pageController => FeedRepo.pageController;

  @override
  void initState() {
    super.initState();
    NotifHandler.refreshTokens();
    ref.read(notifProvider);
  }

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
                  PrefProvider.saveDate("");
                  PrefProvider.saveTime("");
                  PrefProvider.savePlaceId("");
                  PrefProvider.savePlaceName("");
                  PrefProvider.saveInviteeId(0);
                  PrefProvider.saveInviteeImage("");
                  PrefProvider.saveInviteeName("");
                  setState(() {
                    selectedIndex = index;
                  });
                },
                backgroundColor: Colors.black,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.grey,
                selectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.bold),
                items: [
                  BottomNavigationBarItem(
                    icon: Center(
                      child: Image.asset(
                        selectedIndex == 0
                            ? "assets/images/spade-light.png"
                            : "assets/images/spade-small.png",
                        height: 24,
                      ),
                    ),
                    label: "Feed",
                  ),
                  BottomNavigationBarItem(
                    icon: Center(
                      child: Image.asset(
                        selectedIndex == 1
                            ? "assets/images/message-light.png"
                            : "assets/images/message.png",
                        width: 24,
                        height: 24,
                      ),
                    ),
                    label: "Messages",
                  ),
                  BottomNavigationBarItem(
                    icon: Center(
                      child: Image.asset(
                        selectedIndex == 2
                            ? "assets/images/global-light.png"
                            : "assets/images/global.png",
                        width: 24,
                        height: 24,
                      ),
                    ),
                    label: "Maps",
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

  void _onPageChanged(int index) {
    if (pageIndex != index) {
      setState(() {
        pageIndex = index;
      });
    }
  }
}
