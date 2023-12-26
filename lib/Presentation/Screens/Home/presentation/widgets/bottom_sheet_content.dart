import 'package:flutter/material.dart';
import 'package:spade_lite/Presentation/Screens/Home/presentation/widgets/search_item.dart';

class BottomSearchSheet {
  static Widget buildBottomSheetContent(double screenHeight) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(20),
        topLeft: Radius.circular(20),
      ),
      child: Container(
        height: screenHeight * 0.7,
        width: double.infinity,
        color: const Color(0xFF232323),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: "Search for people",
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
                      color: Color(0xFF333333),
                      width: 2.0,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {},
                  ),
                ),
                textAlign: TextAlign.center,
                onSubmitted: (_) {},
              ),
              const Column(
                children: [
                  SearchItem(),
                  SearchItem(),
                  SearchItem(),
                  SearchItem(),
                  SearchItem(),
                  SearchItem(),
                  SearchItem(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
