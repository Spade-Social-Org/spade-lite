import 'package:flutter/material.dart';

class JHSearchField extends StatelessWidget {
  const JHSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: TextField(
        style: const TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          hintText: "Search for Places",
          hintStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          fillColor: const Color(0xFF333333),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Colors.white,
              width: 2.0,
            ),
          ),
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
              weight: 30,
              size: 30,
            ),
            onPressed: () {},
          ),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
