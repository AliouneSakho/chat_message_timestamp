extension DateTimeExtension on DateTime {
  String get formattedTimeHm {
    String twoDigits(int n) {
      if (n >= 10) {
        return "$n";
      }
      return "0$n";
    }

    return "${twoDigits(hour)}:${twoDigits(minute)}";
  }
}
