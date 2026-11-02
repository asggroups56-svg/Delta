String formatReportDate(DateTime date) {
  return formatReportDateTime(DateTime(date.year, date.month, date.day));
}

String formatReportDateTime(DateTime dateTime) {
  final year = dateTime.year.toString().padLeft(4, '0');
  final month = dateTime.month.toString().padLeft(2, '0');
  final day = dateTime.day.toString().padLeft(2, '0');
  final hour = dateTime.hour.toString().padLeft(2, '0');
  final minute = dateTime.minute.toString().padLeft(2, '0');
  final second = dateTime.second.toString().padLeft(2, '0');
  return '$year-$month-${day}T$hour:$minute:$second';
}
