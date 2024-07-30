import 'dart:html' as html;

import 'package:firebase_analytics_web/firebase_analytics_web.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:numaze_web/common/const/colors.dart';
import 'package:url_strategy/url_strategy.dart';

import 'common/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

late FirebaseAnalyticsWeb analytics;

void main() async {
  setPathUrlStrategy();
  // Ensure all widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  analytics = FirebaseAnalyticsWeb();
  analytics.setAnalyticsCollectionEnabled(true);

  // Initialize the locale data
  await initializeDateFormatting('ko_KR', null);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus
        },
      ),
      theme: ThemeData(
        fontFamily: 'Pretendard',
        scaffoldBackgroundColor: ContainerColors.white,
      ),
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      html.window.location.href = 'https://numaze.co.kr';
    });

    return const Scaffold(
      // appBar: AppBar(
      //   title: const Text('Home Page'),
      // ),
      body: Center(
          // child: ElevatedButton(
          //   onPressed: () {
          //     context.go('/s/dodu');
          //   },
          //   child: const Text('Go to Details Page'),
          // ),
          ),
    );
  }
}
