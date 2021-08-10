import 'package:intl/intl.dart';

class Format {
  String hours(double hours) {
    final hoursNotNegative = hours < 0.0 ? 0.0 : hours;
    final formatter = NumberFormat.decimalPattern();
    final formatted = formatter.format(hoursNotNegative);
    return '${formatted}h';
  }

  String date(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }

  String dayOfWeek(DateTime date) {
    return DateFormat.E().format(date);
  }

  String currency(double pay) {
    if (pay != 0.0) {
      final formatter = NumberFormat.simpleCurrency(decimalDigits: 0);
      return formatter.format(pay);
    }
    return '';
  }
}
