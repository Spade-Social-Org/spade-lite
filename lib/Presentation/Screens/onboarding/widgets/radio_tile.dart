// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:spade_lite/Presentation/Screens/onboarding/widgets/questions_enum.dart';

class RadioTileWidget extends StatefulWidget {
  final Text title;
  final dynamic value;
  final dynamic groupValue;
  final Function(Question1Enum?)? onChanged;
  const RadioTileWidget({
    super.key,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  State<RadioTileWidget> createState() => _RadioTileWidgetState();
}

class _RadioTileWidgetState extends State<RadioTileWidget> {
  @override
  Widget build(BuildContext context) {
    return RadioListTile<Question1Enum>(
      activeColor: Colors.white,
      title: widget.title,
      value: widget.value,
      groupValue: widget.groupValue,
      onChanged: widget.onChanged,
    );
  }
}
