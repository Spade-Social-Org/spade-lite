import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image/image.dart' as imageLib;
import 'package:path_provider/path_provider.dart';
import 'package:photofilters/filters/filters.dart';
import 'package:spade_lite/Common/navigator.dart';
import 'package:spade_lite/Common/theme.dart';
import 'package:spade_lite/Common/utils/utils.dart';
import 'package:spade_lite/resources/resources.dart';

class PhotoFilter extends StatelessWidget {
  final imageLib.Image image;
  final String filename;
  final Filter filter;
  final BoxFit fit;
  final Widget loader;

  const PhotoFilter({
    super.key,
    required this.image,
    required this.filename,
    required this.filter,
    this.fit = BoxFit.fill,
    this.loader = const Center(child: CircularProgressIndicator()),
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<int>>(
      future: compute(applyFilter, <String, dynamic>{
        "filter": filter,
        "image": image,
        "filename": filename,
      }),
      builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return loader;
          case ConnectionState.active:
          case ConnectionState.waiting:
            return loader;
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            return Image.memory(
              snapshot.data as dynamic,
              fit: fit,
            );
        }
      },
    );
  }
}

///The PhotoFilterSelector Widget for apply filter from a selected set of filters
class PhotoFilterSelector extends StatefulWidget {
  final Widget title;
  final List<Filter> filters;
  final imageLib.Image image;
  final Widget loader;
  final String filename;

  const PhotoFilterSelector({
    super.key,
    required this.title,
    required this.filters,
    required this.image,
    this.loader = const Center(child: CircularProgressIndicator()),
    required this.filename,
  });

  @override
  State<StatefulWidget> createState() => _PhotoFilterSelectorState();
}

class _PhotoFilterSelectorState extends State<PhotoFilterSelector> {
  String? filename;
  Map<String, List<int>?> cachedFilters = {};
  Filter? _filter;
  imageLib.Image? image;
  late bool loading;

  @override
  void initState() {
    super.initState();
    loading = false;
    _filter = widget.filters[0];
    filename = widget.filename;
    image = widget.image;
  }

  int filterIndex = 0;

  @override
  void dispose() {
    super.dispose();
  }

  bool showHint = true;
  Widget get hint => GestureDetector(
        onTapDown: (_) {
          setState(() {
            showHint = false;
          });
        },
        child: Container(
          color: const Color(0x49000000),
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(SpiderSvgAssets.swipeLeft),
              10.spacingW,
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                decoration: ShapeDecoration(
                  color: Colors.black.withOpacity(0.4000000059604645),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Swipe for filters!',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              10.spacingW,
              SvgPicture.asset(SpiderSvgAssets.swipeRight),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            child: loading
                ? widget.loader
                : PageView.builder(
                    itemCount: widget.filters.length,
                    onPageChanged: (index) {
                      setState(() {
                        _filter = widget.filters[index];
                        filterIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: MediaQuery.sizeOf(context).width,
                        height: MediaQuery.sizeOf(context).height,
                        child: _buildFilteredImage(
                          widget.filters[index],
                          image,
                          filename,
                        ),
                      );
                    },
                  ),
          ),
          if (showHint) hint,
          Positioned(
            top: 30,
            // left: 10,
            child: IconButton(
              onPressed: () {
                pop();
              },
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: ShapeDecoration(
                color: Colors.black.withOpacity(0.699999988079071),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: ShapeDecoration(
                        color: const Color(0xFF202020),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(SpiderSvgAssets.discard),
                          5.spacingW,
                          Text(
                            'Discard',
                            style: CustomTextStyle.large16.w700.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () async {
                      setState(() {
                        loading = true;
                      });
                      var imageFile = await saveFilteredImage();

                      Navigator.pop(context, {'image_filtered': imageFile});
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: ShapeDecoration(
                        color: const Color(0xFF202020),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Next',
                            style: CustomTextStyle.large16.w700.white,
                          ),
                          5.spacingW,
                          SvgPicture.asset(SpiderSvgAssets.next)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildFilterThumbnail(
      Filter filter, imageLib.Image? image, String? filename) {
    if (cachedFilters[filter.name] == null) {
      return FutureBuilder<List<int>>(
        future: compute(applyFilter, <String, dynamic>{
          "filter": filter,
          "image": image,
          "filename": filename,
        }),
        builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return CircleAvatar(
                radius: 50.0,
                backgroundColor: Colors.white,
                child: Center(
                  child: widget.loader,
                ),
              );
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              cachedFilters[filter.name] = snapshot.data;
              return CircleAvatar(
                radius: 50.0,
                backgroundImage: MemoryImage(
                  snapshot.data as dynamic,
                ),
                backgroundColor: Colors.white,
              );
          }
          // unreachable
        },
      );
    } else {
      return CircleAvatar(
        radius: 50.0,
        backgroundImage: MemoryImage(
          cachedFilters[filter.name] as dynamic,
        ),
        backgroundColor: Colors.white,
      );
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/filtered_${_filter?.name ?? "_"}_$filename');
  }

  Future<File> saveFilteredImage() async {
    var imageFile = await _localFile;
    await imageFile.writeAsBytes(cachedFilters[_filter?.name ?? "_"]!);
    return imageFile;
  }

  Widget _buildFilteredImage(
      Filter? filter, imageLib.Image? image, String? filename) {
    if (cachedFilters[filter?.name ?? "_"] == null) {
      return FutureBuilder<List<int>>(
        future: compute(applyFilter, <String, dynamic>{
          "filter": filter,
          "image": image,
          "filename": filename,
        }),
        builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return widget.loader;
            case ConnectionState.active:
            case ConnectionState.waiting:
              return widget.loader;
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              cachedFilters[filter?.name ?? "_"] = snapshot.data;
              return Image.memory(
                snapshot.data as dynamic,
                width: double.infinity,
                fit: BoxFit.cover,
              );
          }
        },
      );
    } else {
      return Image.memory(
        cachedFilters[filter?.name ?? "_"] as dynamic,
        fit: BoxFit.cover,
        width: double.infinity,
      );
    }
  }
}

///The global applyfilter function
FutureOr<List<int>> applyFilter(Map<String, dynamic> params) {
  Filter? filter = params["filter"];
  imageLib.Image image = params["image"];
  String filename = params["filename"];
  List<int> bytes = image.getBytes();
  if (filter != null) {
    filter.apply(bytes as dynamic, image.width, image.height);
  }
  imageLib.Image image0 =
      imageLib.Image.fromBytes(image.width, image.height, bytes);
  bytes = imageLib.encodeNamedImage(image0, filename)!;

  return bytes;
}

///The global buildThumbnail function
FutureOr<List<int>> buildThumbnail(Map<String, dynamic> params) {
  int? width = params["width"];
  params["image"] = imageLib.copyResize(params["image"], width: width);
  return applyFilter(params);
}
