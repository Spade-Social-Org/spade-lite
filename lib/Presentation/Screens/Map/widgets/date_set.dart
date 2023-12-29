import 'package:flutter/material.dart';

class DateSet extends StatelessWidget {

  DateSet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text("Date Set", style: TextStyle(color: Colors.white, fontSize: 18.0),),
    );
}
}