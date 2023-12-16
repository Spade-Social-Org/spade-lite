import 'package:flutter/material.dart';

class FormTitle extends StatelessWidget {
  final String formTitle;
  const FormTitle({
    super.key,
    required this.formTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        formTitle,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  }
}
