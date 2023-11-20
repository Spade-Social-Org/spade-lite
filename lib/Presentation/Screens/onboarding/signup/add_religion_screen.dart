import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'input_birthday_screen.dart';

class AddReligionScreen extends StatelessWidget {
 

  final List<String> religions = [
    "Islam",
    'Christianity',
    'Hinduism',
    'Irreligion',
    'Sikhism',
    'Judaism',
    'Buddhism',
    'Atheist',
    'Folk religion',
    'Others...',
  ];

   AddReligionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 18,
                top: 30,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            const Center(
              child: Text(
                "What's your religion?",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(flex: 100,
              child: Container(
                child: MasonryGridView.builder(
                  itemCount: religions.length,
                  gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                   itemBuilder: ((context, index) {
                     return Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Container(
                        height: 70,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 3,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              spreadRadius: 2.0,
                              color: Colors.black12,
                              blurRadius: 3,
                              offset: Offset(0.0, 4.0),
                            )
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            religions[index],
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                                     ),
                     );
                   })),
              )
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: MaterialButton(
                  height: 50,
                  minWidth: double.infinity,
                  color: Colors.black,
                  child: const Text(
                    "Next",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => const InputBirthdayScreen()),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}






