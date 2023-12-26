import 'package:flutter/material.dart';
import 'package:spade_lite/Presentation/Screens/Home/presentation/widgets/qr_bottom_sheet.dart';
import 'package:spade_lite/Presentation/Screens/Profile/widget/custom_badge.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:flutter_svg/flutter_svg.dart';

List<StaggeredTile> generateStaggeredTiles(int length) {
  List<StaggeredTile> staggeredTiles = [];

  for (int i = 0; i < length; i++) {
    if (i % 3 == 0) {
      staggeredTiles.add(const StaggeredTile.count(2, 2));
    } else {
      staggeredTiles.add(const StaggeredTile.count(2, 3));
    }
  }

  return staggeredTiles;
}

List<String> posts = [
  "assets/images/post.png",
  "assets/images/post.png",
  "assets/images/post.png",
  "assets/images/post.png",
  "assets/images/post.png",
  "assets/images/post.png",
  "assets/images/post.png",
  "assets/images/post.png",
  "assets/images/post.png",
  "assets/images/post.png",
];

List<Widget> generateTiles() {
  List<Widget> tiles = [];
  for (int i = 0; i < posts.length; i++) {
    tiles.add(
      Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(12.0), // Same as the border radius above
          child: Image.asset(
            posts[i],
            fit: BoxFit.cover,
            repeat: ImageRepeat.noRepeat,
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }

  return tiles;
}

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfileState();
}

final ScrollController _scrollController = ScrollController();
bool _isLoading = false;

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMoreData();
      }
    });
  }

  Future<void> _loadMoreData() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });

      // Fetch more data and add it to posts
      // This is a placeholder, replace it with your actual data fetching code

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: true, // Show back button
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.white,
            size: 50,
          ),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
        title: null, // No title
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.centerStart,
                        children: [
                          const SizedBox(
                            // decoration: BoxDecoration(
                            //   shape: BoxShape.circle,
                            //   border: Border.all(
                            //     color: Colors.blue,
                            //     width: 2.0,
                            //   ),
                            // ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  AssetImage('assets/images/Ellipse 368.png'),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Image.asset(
                              'assets/images/add.png',
                              width: 32,
                              height: 32,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            const Text(
                              '100+',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const Text(
                              'Posts',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff818181),
                              ),
                            ),
                            const SizedBox(height: 3),
                            SizedBox(
                              width: double
                                  .infinity, // This makes the container occupy full width
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                child: const Text(
                                  'Follow',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            const Text(
                              '852',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const Text(
                              'Connections',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff818181),
                              ),
                            ),
                            const SizedBox(height: 3),
                            SizedBox(
                              width: double
                                  .infinity, // This makes the container occupy full width
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                child: const Text(
                                  'Message',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'John Doe',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Jdoe123',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff818181),
                          ),
                        ),
                      ],
                    ),
                  ]),
              const SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomBadge(
                      text: '20,067',
                      imagePath: 'assets/images/spade-gold.png',
                    ),
                    const SizedBox(width: 15),
                    const CustomBadge(
                      text: 'Virgo',
                      imagePath: 'assets/images/virgo.png',
                    ),
                    const SizedBox(width: 15),
                    const CustomBadge(
                      text: 'Add school',
                      imagePath: 'assets/images/add-2.png',
                    ),
                    const SizedBox(width: 15),
                    const CustomBadge(
                      text: 'Job',
                      imagePath: 'assets/images/job.png',
                    ),
                    const SizedBox(width: 15),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) =>
                              QRBottomSheet.buildQRBottomSheet(
                                  MediaQuery.of(context).size.height, context),
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                        );
                      },
                      child: const CustomBadge(
                        text: 'Quick add',
                        imagePath: 'assets/images/qr.png',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3.5,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle button press
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.white, // Set background color as transparent
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: const BorderSide(
                              color: Colors.white), // Set border color as white
                        ),
                      ),
                      child: SvgPicture.asset(
                        'assets/svgs/image.svg',
                        width: 24,
                        height: 24,
                        color:
                            Colors.black, // Optionally set the color of the SVG
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3.5,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle button press
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors
                            .transparent, // Set background color as transparent
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: const BorderSide(
                              color: Colors.white), // Set border color as white
                        ),
                      ),
                      child: SvgPicture.asset(
                        'assets/svgs/play.svg',
                        width: 24,
                        height: 24,
                        color:
                            Colors.white, // Optionally set the color of the SVG
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3.5,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle button press
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors
                            .transparent, // Set background color as transparent
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: const BorderSide(
                              color: Colors.white), // Set border color as white
                        ),
                      ),
                      child: SvgPicture.asset(
                        'assets/svgs/hash.svg',
                        width: 24,
                        height: 24,
                        color:
                            Colors.white, // Optionally set the color of the SVG
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 12),
                child: StaggeredGridView.count(
                  crossAxisCount: 4,
                  staggeredTiles: generateStaggeredTiles(posts.length),
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  padding: const EdgeInsets.all(4),
                  shrinkWrap: true, // Added shrinkWrap property
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical, // Added physics property
                  children: generateTiles(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
