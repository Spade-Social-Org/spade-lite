import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'Presentation/Screens/Bottom_nav/navigation_container.dart';
import 'Presentation/Screens/messages/provider/socket_provider.dart';
import 'Presentation/Screens/onboarding/landing_screen.dart';
import 'prefs/pref_provider.dart';

final userAuthFutureProvider =
    FutureProvider((ref) => ref.watch(userAuthChange));

class AuthStateChangeNotifier extends ConsumerStatefulWidget {
  const AuthStateChangeNotifier({super.key});
  @override
  ConsumerState<AuthStateChangeNotifier> createState() =>
      _AuthStateChangeNotifierState();
}

class _AuthStateChangeNotifierState
    extends ConsumerState<AuthStateChangeNotifier> {
  @override
  void initState() {
    ref.read(socketProvider.notifier).initializeSocket();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ref.watch(userAuthFutureProvider).when(
          data: (data) => data == null
              ? const LandingScreen()
              : const NavigationContainer(),
          error: (e, t) => const SizedBox.shrink(),
          loading: () => const SizedBox.shrink()),
    );
  }
}
