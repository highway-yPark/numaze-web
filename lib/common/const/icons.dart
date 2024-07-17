import 'package:flutter_svg/flutter_svg.dart';

class CommonIcons {
  static rightArrow() {
    return SvgPicture.asset(
      'images/right_arrow.svg',
      width: 14,
      height: 14,
    );
  }

  static check() {
    return SvgPicture.asset(
      'images/check.svg',
      width: 24,
      height: 24,
    );
  }

  static clock() {
    return SvgPicture.asset(
      'images/clock.svg',
      width: 15,
      height: 15,
    );
  }

  static adFree() {
    return SvgPicture.asset(
      'images/ad_free.svg',
    );
  }

  static calendarLeftArrow() {
    return SvgPicture.asset(
      'images/calendar_left_arrow.svg',
      width: 24,
      height: 24,
    );
  }

  static calendarRightArrow() {
    return SvgPicture.asset(
      'images/calendar_right_arrow.svg',
      width: 24,
      height: 24,
    );
  }

  static home() {
    return SvgPicture.asset(
      'images/home.svg',
      width: 32,
      height: 32,
    );
  }

  static arrowDown() {
    return SvgPicture.asset(
      'images/arrow_down.svg',
      width: 25,
      height: 25,
    );
  }

  static close() {
    return SvgPicture.asset(
      'images/close.svg',
      width: 20,
      height: 20,
    );
  }
}
