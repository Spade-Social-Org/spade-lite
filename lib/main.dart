import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spade_v4/Common/navigator.dart';
import 'package:spade_v4/Data/Service/geo_locator.dart';
import 'package:spade_v4/auth_state_change_notifier.dart';
import 'package:spade_v4/injection.dart' as di;

import 'Common/routes/route_generator.dart';
import 'Presentation/Bloc/places_bloc.dart';
import 'Presentation/Screens/Camera/camera_screen.dart';
import 'injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  GeoLocatorService.getInitialLocation();
  cameras = await availableCameras();
  di.init();
  runApp(
    ProviderScope(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<PlacesBloc>(
            create: (context) => locator<PlacesBloc>(),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Spade',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
          ),
          useMaterial3: true,
        ),
        navigatorKey: kNavigatorKey,
        onGenerateRoute: RouteGenerator.onGenerateRoute,
        onUnknownRoute: RouteGenerator.unKnownRoute,
        home: const AuthStateChangeNotifier(),
      ),
    );
  }
}
