import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:numaze_web/view/404_page.dart';
import 'package:numaze_web/view/complete_page.dart';
import 'package:numaze_web/view/customer_appointment_page.dart';
import 'package:numaze_web/view/find_reservation_page.dart';
import 'package:numaze_web/view/not_found_page.dart';
import 'package:numaze_web/view/reservation_failed.dart';
import 'package:numaze_web/view/shop_close.dart';
import 'package:numaze_web/view/shop_info_page.dart';

import '../main.dart';
import '../view/date_page.dart';
import '../view/payment_complete_screen.dart';
import '../view/reservation_details_screen.dart';
import '../view/shop_main_page.dart';
import '../view/shop_styles_screen.dart';
import '../view/styles_screen.dart';
import '../view/treatment_detail_page.dart';

final GoRouter _router = GoRouter(
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
    ),
    GoRoute(
      path: '/appointment/:appointmentId',
      builder: (BuildContext context, GoRouterState state) {
        final String appointmentId = state.pathParameters['appointmentId']!;
        final String shopDomain = state.uri.queryParameters['shopDomain']!;
        return CustomerAppointmentPage(
          shopDomain: shopDomain,
          appointmentId: appointmentId,
        );
      },
      // routes: <GoRoute>[
      //   GoRoute(
      //     path: 'payment',
      //     builder: (BuildContext context, GoRouterState state) {
      //       final String appointmentId = state.pathParameters['appointmentId']!;
      //       // print('appointmentId: $appointmentId');
      //       return PaymentComplete(
      //         appointmentId: appointmentId,
      //       );
      //     },
      //   ),
      // ],
    ),
    GoRoute(
      path: '/payment',
      builder: (BuildContext context, GoRouterState state) {
        final String appointmentId =
            state.uri.queryParameters['appointmentId']!;
        // print('appointmentId: $appointmentId');
        return PaymentComplete(
          appointmentId: appointmentId,
        );
      },
    ),
    GoRoute(
      path: '/findReservation',
      builder: (BuildContext context, GoRouterState state) {
        final String shopDomain = state.uri.queryParameters['shopDomain']!;
        return FindReservationPage(
          shopDomain: shopDomain,
        );
      },
    ),
    GoRoute(
      path: '/close',
      builder: (BuildContext context, GoRouterState state) {
        final String shopDomain = state.uri.queryParameters['shopDomain']!;
        return ShopClosePage(
          shopDomain: shopDomain,
        );
      },
    ),
    GoRoute(
      path: '/notFound',
      builder: (BuildContext context, GoRouterState state) {
        final String shopDomain = state.uri.queryParameters['shopDomain']!;
        return NotFoundPage(
          shopDomain: shopDomain,
        );
      },
    ),
    GoRoute(
      path: '/fail',
      builder: (BuildContext context, GoRouterState state) {
        final String shopDomain = state.uri.queryParameters['shopDomain']!;
        return ReservationFailed(
          shopDomain: shopDomain,
        );
      },
    ),
    GoRoute(
      path: '/s/:shopDomain',
      builder: (BuildContext context, GoRouterState state) {
        final String shopDomain = state.pathParameters['shopDomain']!;
        return ShopMainPage(shopDomain: shopDomain);
      },
      routes: <GoRoute>[
        // GoRoute(
        //   path: 'styles',
        //   builder: (BuildContext context, GoRouterState state) {
        //     final String shopDomain = state.pathParameters['shopDomain']!;
        //     final int categoryId =
        //         int.parse(state.uri.queryParameters['categoryId']!);
        //     return StyleScreen(
        //       shopDomain: shopDomain,
        //       categoryId: categoryId,
        //     );
        //   },
        // ),
        GoRoute(
          path: 'calendar',
          builder: (BuildContext context, GoRouterState state) {
            final String shopDomain = state.pathParameters['shopDomain']!;
            return CalendarScreen(
              shopDomain: shopDomain,
            );
          },
        ),
        GoRoute(
          path: 'complete',
          builder: (BuildContext context, GoRouterState state) {
            final String shopDomain = state.pathParameters['shopDomain']!;
            return CompletePage(
              shopDomain: shopDomain,
              appointmentId: state.uri.queryParameters['appointmentId']!,
            );
          },
        ),
        GoRoute(
          path: 'reservation',
          builder: (BuildContext context, GoRouterState state) {
            final String shopDomain = state.pathParameters['shopDomain']!;
            return ReservationDetailsScreen(
              shopDomain: shopDomain,
            );
          },
        ),
        GoRoute(
          path: 'info',
          builder: (BuildContext context, GoRouterState state) {
            final String shopDomain = state.pathParameters['shopDomain']!;
            return ShopInfoPage(
              shopDomain: shopDomain,
            );
          },
        ),
        GoRoute(
          path: 'shopStyles',
          builder: (BuildContext context, GoRouterState state) {
            final String shopDomain = state.pathParameters['shopDomain']!;
            return ShopStylesScreen(
              shopDomain: shopDomain,
            );
          },
        ),
        GoRoute(
          path: 'treatmentStyles',
          builder: (BuildContext context, GoRouterState state) {
            final int treatmentId =
                int.parse(state.uri.queryParameters['treatmentId']!);
            return TreatmentStylesScreen(
              // categoryId: categoryId,
              // categoryName: categoryName,
              shopDomain: state.pathParameters['shopDomain']!,
              treatmentId: treatmentId,
            );
          },
        ),
        GoRoute(
          path: 'treatment',
          builder: (BuildContext context, GoRouterState state) {
            // final int categoryId =
            //     int.parse(state.uri.queryParameters['categoryId']!);
            // final String categoryName =
            //     state.uri.queryParameters['categoryName']!;
            final int treatmentId =
                int.parse(state.uri.queryParameters['treatmentId']!);
            final int? monthlyPickId =
                state.uri.queryParameters['monthlyPickId'] != null
                    ? int.tryParse(state.uri.queryParameters['monthlyPickId']!)
                    : null;
            final int? styleId = state.uri.queryParameters['styleId'] != null
                ? int.tryParse(state.uri.queryParameters['styleId']!)
                : null;

            final int? treatmentStyleId = state
                        .uri.queryParameters['treatmentStyleId'] !=
                    null
                ? int.tryParse(state.uri.queryParameters['treatmentStyleId']!)
                : null;
            return TreatmentDetailPage(
              // categoryId: categoryId,
              // categoryName: categoryName,
              shopDomain: state.pathParameters['shopDomain']!,
              treatmentId: treatmentId,
              monthlyPickId: monthlyPickId,
              styleId: styleId,
              treatmentStyleId: treatmentStyleId,
            );
          },
        ),
      ],
    ),
  ],
  routerNeglect: false,
  debugLogDiagnostics: true,
  errorBuilder: (BuildContext context, GoRouterState state) {
    return const PageNotFound();
  },
);

GoRouter get router => _router;
