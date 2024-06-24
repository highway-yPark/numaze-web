import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class DataUtils {
  static DateTime sundayOfGivenDate(DateTime date) {
    return date.subtract(Duration(days: date.weekday % 7));
  }

  // static Color appointmentStatusColor(CalendarAppointmentModel appointment) {
  //   if (appointment.status == null) {
  //     if (appointment.confirmed) {
  //       return AppColors.CONFIRM;
  //     } else {
  //       return AppColors.UNCONFIRM;
  //     }
  //   } else {
  //     return AppColors.VISIT_ABSENT;
  //   }
  // }
  //
  // static Color meetingStatusColor(Meeting meeting) {
  //   if (meeting.status == null) {
  //     if (meeting.confirmed) {
  //       return AppColors.CONFIRM;
  //     } else {
  //       return AppColors.UNCONFIRM;
  //     }
  //   } else {
  //     return AppColors.VISIT_ABSENT;
  //   }
  // }

  static String formatMoney(int amount) {
    final formatter =
        NumberFormat('#,##0', 'ko_KR'); // Korean locale, no decimal places
    return formatter.format(amount); // Adding the Won symbol for clarity
  }

  static String formatKoreanWon(int amount) {
    final formatter =
        NumberFormat('#,##0', 'ko_KR'); // Korean locale, no decimal places
    return '${formatter.format(amount)} 원'; // Adding the Won symbol for clarity
  }

  static String formatKoreanWonWithSymbol(int amount) {
    final formatter =
        NumberFormat('#,##0', 'ko_KR'); // Korean locale, no decimal places
    return '₩ ${formatter.format(amount)}'; // Adding the Won symbol for clarity
  }

  static String formatDuration(int duration) {
    final hour = duration ~/ 2;
    final minute = duration % 2 * 30;
    // if hour = 0, don't show hour and if minute = 0, don't show minute
    return '${hour > 0 ? '$hour시간' : ''} ${minute > 0 ? '$minute분' : ''}';
  }

  static String formatDurationWithZero(int duration) {
    final hour = duration ~/ 2;
    final minute = duration % 2 * 30;
    // if hour = 0, don't show hour and if minute = 0, don't show minute
    if (hour == 0 && minute == 0) {
      return '0분';
    }

    if (hour == 0 && minute == 30) {
      return '30분';
    }
    return '${hour > 0 ? '$hour시간' : ''} ${minute > 0 ? '$minute분' : ''}';
  }

  static String formatTime(int time) {
    String period = time < 24 || time == 48 ? '오전' : '오후';
    final hour = time ~/ 2 % 12 == 0 ? 12 : time ~/ 2 % 12;
    final minute = time % 2 * 30;
    return '$period $hour:${minute.toString().padLeft(2, '0')}';
  }

  static String convertTime(int startTime, int duration) {
    final startHour = startTime ~/ 2 % 12 == 0 ? 12 : startTime ~/ 2 % 12;
    final startMinute = startTime % 2 * 30;
    final endHour = (startTime + duration) ~/ 2 % 12 == 0
        ? 12
        : (startTime + duration) ~/ 2 % 12;
    final endMinute = (startTime + duration) % 2 * 30;
    final startPeriod = startTime < 24 ? '오전' : '오후';
    final endPeriod = startTime + duration < 24 ? '오전' : '오후';

    return '$startPeriod $startHour:${startMinute.toString().padLeft(2, '0')} ~ $endPeriod $endHour:${endMinute.toString().padLeft(2, '0')}';
  }

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  static String formatHour(TimeOfDay time) {
    final hour =
        time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod; // Handle 12 AM/PM case
    final period = time.period == DayPeriod.am ? '오전' : '오후';
    return '$period $hour'; // Return the formatted string
  }

  static String formatTimeRange(DateTime start, DateTime end) {
    final startTime = TimeOfDay.fromDateTime(start);
    final endTime = TimeOfDay.fromDateTime(end);

    final startHour = startTime.hourOfPeriod == 0 ? 12 : startTime.hourOfPeriod;
    final startMinute = startTime.minute;
    final startPeriod = startTime.period == DayPeriod.am ? '오전' : '오후';

    final endHour = endTime.hourOfPeriod == 0 ? 12 : endTime.hourOfPeriod;
    final endMinute = endTime.minute;
    final endPeriod = endTime.period == DayPeriod.am ? '오전' : '오후';

    return '$startPeriod $startHour:${startMinute.toString().padLeft(2, '0')} ~ $endPeriod $endHour:${endMinute.toString().padLeft(2, '0')}';
  }

  static String plainToBase64(String plain) {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    String token = stringToBase64.encode(plain);
    return token;
  }

  static Color hexToColor(String hexColor) {
    return Color(int.parse('FF$hexColor', radix: 16)).withOpacity(1.0);
  }

  static String formatDateWithDay(String appointmentDate) {
    final date = DateTime.parse(appointmentDate);
    final formatter = DateFormat('yyyy.MM.dd (E)', 'ko_KR');
    return formatter.format(date);
  }

  static String formatDateWithDayFromDateTime(DateTime date) {
    final formatter = DateFormat('yyyy.MM.dd (E)', 'ko_KR');
    return formatter.format(date);
  }

  static String formatDate(String appointmentDate) {
    final date = DateTime.parse(appointmentDate);
    final formatter = DateFormat('yyyy.MM.dd', 'ko_KR');
    return formatter.format(date);
  }

  static String formatDateWithTime(String appointmentDate) {
    final date = DateTime.parse(appointmentDate);
    final formatter = DateFormat('yyyy.MM.dd hh:mm:ss', 'ko_KR');
    return formatter.format(date);
  }

  static String formatDateFromDateTime(DateTime date) {
    final formatter = DateFormat('yyyy.MM.dd', 'ko_KR');
    return formatter.format(date);
  }

  static String apiDateFormat(DateTime date) {
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }

  static String getUnicodeCharacter(String hexCode) {
    try {
      hexCode = hexCode.replaceFirst('U+', '');
      int code = int.parse(hexCode, radix: 16);
      return String.fromCharCode(code);
    } catch (e) {
      print(e);
      return 'Invalid Unicode';
    }
  }
}
