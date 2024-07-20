import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommonIcons {
  static rightArrow() {
    return SvgPicture.asset(
      'assets/images/right_arrow.svg',
      width: 14,
      height: 14,
    );
  }

  static check() {
    return SvgPicture.asset(
      'assets/images/check.svg',
      width: 24,
      height: 24,
    );
  }

  static clock() {
    return SvgPicture.asset(
      'assets/images/clock.svg',
      width: 15,
      height: 15,
    );
  }

  static adFree() {
    return SvgPicture.asset(
      'assets/images/ad_free.svg',
    );
  }

  static calendarLeftArrow() {
    return SvgPicture.asset(
      'assets/images/calendar_left_arrow.svg',
      width: 24,
      height: 24,
    );
  }

  static calendarRightArrow() {
    return SvgPicture.asset(
      'assets/images/calendar_right_arrow.svg',
      width: 24,
      height: 24,
    );
  }

  static home() {
    return SvgPicture.asset(
      'assets/images/home.svg',
      width: 32,
      height: 32,
    );
  }

  static arrowDown() {
    return SvgPicture.asset(
      'assets/images/arrow_down.svg',
      width: 25,
      height: 25,
    );
  }

  static close() {
    return SvgPicture.asset(
      'assets/images/close.svg',
      width: 20,
      height: 20,
    );
  }

  static alert() {
    return SvgPicture.asset(
      'assets/images/alert.svg',
    );
  }

  static lineClose() {
    return Image.asset(
      'assets/images/line_close.png',
      width: 32,
      height: 32,
    );
  }

  static complete() {
    return Image.asset(
      'assets/images/complete.png',
      width: 100,
      height: 100,
    );
  }

  static confirmed() {
    return Image.asset(
      'assets/images/confirmed.png',
      width: 100,
      height: 100,
    );
  }

  static visited() {
    return Image.asset(
      'assets/images/visited.png',
      width: 100,
      height: 100,
    );
  }

  static cancel() {
    return Image.asset(
      'assets/images/cancel.png',
      width: 100,
      height: 100,
    );
  }

  static absent() {
    return Image.asset(
      'assets/images/absent.png',
      width: 100,
      height: 100,
    );
  }

  static findReservation() {
    return Image.asset(
      'assets/images/find_reservation.png',
      width: 150,
      height: 100,
    );
  }
}
