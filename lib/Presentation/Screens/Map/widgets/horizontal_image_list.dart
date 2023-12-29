import 'package:flutter/material.dart';

class HorizontalImageList extends StatelessWidget {
  final List<String> imageURLs;

  const HorizontalImageList({super.key, 
    required this.imageURLs,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: imageURLs.isNotEmpty
          ? ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: imageURLs.length,
              itemBuilder: (context, index) {
                final imageURL = imageURLs[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: NetworkImage(imageURL),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey,
                ),
                child: const Text(
                  'No image available',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
    );
  }
}
