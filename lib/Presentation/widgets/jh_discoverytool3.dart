import 'package:flutter/material.dart';

class JHDiscoveryTool3 extends StatelessWidget {
  const JHDiscoveryTool3({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 200,
      width: 320,
      child: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                card2(
                  name: 'Natalia',
                  image: "asset/images/Rectangle 1595.png",
                ),
                Divider(
                  height: 50,
                  thickness: 3,
                  color: Colors.black,
                ),
                card2(
                  name: "Maria",
                  image: "asset/images/Rectangle 1598.png",
                ),
              ],
            ),
            Button(
              name: "My unpopuolar opinion is ....",
            ),
            Button(
              name: "Go-to-dish to cook ....",
            ),
            Button(
              name: "Topics to debate ....",
            ),
            Button(name: 'One thing i cannot live without ....')
          ],
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  final String name;
  const Button({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey, width: 1)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(name), const Icon(Icons.heart_broken)],
          ),
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class card2 extends StatelessWidget {
  final String name;
  final String image;
  const card2({super.key, required this.name, required this.image});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
            height: 100,
            width: 100,
            child: Image.asset(
              image,
              fit: BoxFit.fill,
            )),
        Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.cake),
            Text('24'),
          ],
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.nightlight_outlined),
            Text('Night'),
          ],
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Image.asset('asset/logo/icon-park-outline_virgo.png'),
            Text('virgo'),
          ],
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.line_weight),
            Text('51'),
          ],
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.location_on_outlined),
            Text('4.3ml'),
          ],
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.location_on),
            Text('Slim'),
          ],
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Image.asset('asset/images/bi_gender-male.png'),
            Text('Straight'),
          ],
        ),
      ],
    );
  }
}
