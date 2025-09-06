import 'package:intl/intl.dart';

String formatFriendlyDate(String dateString) {
    DateTime date = DateTime.parse(dateString);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final targetDate = DateTime(date.year, date.month, date.day);

    if (targetDate == today) {
      return 'Today';
    } else if (targetDate == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('d MMM y').format(date); // e.g., 29 Aug
    }
  }

String dayWithSuffix(int month) {
  if (month == 1) return "1st";
  if (month == 2) return "2nd";
  if (month == 3) return "3rd";
  return "${month}th";
}