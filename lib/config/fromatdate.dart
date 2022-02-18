import 'package:intl/intl.dart';

getFormatedDate(DateTime date) {
  return DateFormat.yMMMd().format(date).toString();
}
