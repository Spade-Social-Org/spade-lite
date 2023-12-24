import 'package:intl/intl.dart';

extension DateExtension on DateTime {
  String get formatDate => DateFormat('dd/MM/yyyy').format(this);
  String get formatDateWords => DateFormat('EEE MMM d, yyyy').format(this);
  String get formatDateAndTime => DateFormat('dd/MM/yyyy hh:mm').format(this);
  String get formatTime => DateFormat('hh:mm').format(this);
  String get formatTimeOnly24 => DateFormat('HH:mm').format(this);
  String get formatTimeOnly24WithSeconds => DateFormat('HH:mm:ss').format(this);
  String get formatTimeOnlyWithSeconds => DateFormat('hh:mm:ss a').format(this);
  String get formatTimeOnlyWithSecondsAndDate =>
      DateFormat('dd/MM/yyyy hh:mm:ss a').format(this);
  String get formatTimeOnlyWithSecondsAndDate24 =>
      DateFormat('dd/MM/yyyy HH:mm:ss').format(this);
  String get formatTimeOnlyWithSecondsAndDate24WithDash =>
      DateFormat('dd-MM-yyyy HH:mm:ss').format(this);
  DateTime get stripTime => DateTime(year, month, day);
}
