import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:numaze_web/common/const/colors.dart';
import 'package:url_strategy/url_strategy.dart';

import 'common/router.dart';
import 'dart:html' as html;

void main() async {
  setPathUrlStrategy();
  // Ensure all widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();

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
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   html.window.location.href = 'https://numaze.co.kr';
    // });

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

class DetailsPage extends StatelessWidget {
  final String id;

  const DetailsPage({required this.id, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details Page: $id'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.go('/');
          },
          child: const Text('Back to Home'),
        ),
      ),
    );
  }
}
