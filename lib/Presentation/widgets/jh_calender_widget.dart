import 'package:flutter/material.dart';
import 'package:spade_lite/prefs/pref_provider.dart';
import 'package:table_calendar/table_calendar.dart';

class JHCalenderWidget extends StatefulWidget {
  const JHCalenderWidget({super.key});

  @override
  State<JHCalenderWidget> createState() => _JHCalenderWidgetState();
}

class _JHCalenderWidgetState extends State<JHCalenderWidget> {
  DateTime today = DateTime.now();
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    PrefProvider.saveDate(day.toString());
    setState(() {
      today = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: "en_US",
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        leftChevronIcon: Icon(
          Icons.chevron_left,
          color: Colors.white, // Set the color of the left arrow to white
        ),
        rightChevronIcon: Icon(
          Icons.chevron_right,
          color: Colors.white, // Set the color of the right arrow to white
        ),
      ),
      calendarStyle: const CalendarStyle(
        selectedDecoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        selectedTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        todayTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        defaultTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        weekendTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        outsideTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        outsideDaysVisible: true,
      ),
      daysOfWeekStyle: const DaysOfWeekStyle(
        weekdayStyle: TextStyle(
          color: Colors.white, // Set the text color for weekdays to white
          fontWeight: FontWeight.w600,
        ),
        weekendStyle: TextStyle(
          color: Colors.white, // Set the text color for weekends to white
          fontWeight: FontWeight.w600,
        ),
      ),
      availableGestures: AvailableGestures.all,
      selectedDayPredicate: (day) => isSameDay(day, today),
      focusedDay: today,
      firstDay: DateTime.utc(2010, 18, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      onDaySelected: _onDaySelected,
    );
  }
}
