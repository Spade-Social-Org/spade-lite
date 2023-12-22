import 'package:flutter/material.dart';

class JHSearchField extends StatelessWidget {
  final TextEditingController searchController;
  final void Function() searchLocation;

  const JHSearchField({
    super.key,
    required this.searchController,
    required this.searchLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: TextField(
        controller: searchController,
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
            onPressed: searchLocation,
          ),
        ),
        textAlign: TextAlign.center,
        onSubmitted: (_) {
          searchLocation();
        },
      ),
    );
  }
}
