import 'package:flutter/material.dart';

class FormLabel extends StatelessWidget {
  final String formLabel;
  const FormLabel({
    super.key,
    required this.formLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        formLabel,
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
      ),
    );
  }
}
