import 'package:intl/intl.dart';

String formatDate(DateTime date) => DateFormat('dd/MM/yyyy').format(date);

String formatGpa(double gpa) => NumberFormat('0.00', 'vi_VN').format(gpa);
