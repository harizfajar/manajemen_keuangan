import 'package:intl/intl.dart';

String formatCurrency(double number) {
  final formatter = NumberFormat("#,###", "id_ID");
  return formatter.format(number);
}
