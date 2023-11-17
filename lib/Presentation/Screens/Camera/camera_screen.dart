import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:photofilters/photofilters.dart' as photofilters;
import 'package:spade_v4/Common/image_properties.dart';
import 'package:spade_v4/Common/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'filter_screen.dart';
import 'package:path/path.dart';
import 'package:image/image.dart' as imageLib;

import 'package:spade_v4/Presentation/Screens/Home/providers/feed_provider.dart';
import '../../../Common/camera_components/camera_appbar.dart';
import '../../../Common/navigator.dart';
import '../../../Common/routes/routes.dart';

late List<CameraDescription> cameras;

class CameraScreen extends ConsumerStatefulWidget {
  final String receiverId;
  const CameraScreen({
    super.key,
    required this.receiverId,
  });

  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen> {
  late CameraController _cameraController;
  late Future<void> _cameraValue;
  bool isFlashOn = false;
  bool isCameraFront = true;
  bool isRecording = false;

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(cameras[0], ResolutionPreset.high);
    _cameraValue = _cameraController.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CameraAppBar(
        isFlashOn: isFlashOn,
        onFlashPressed: toggleFlash,
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                FutureBuilder(
                  future: _cameraValue,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return SizedBox(
                        width: double.infinity,
                        child: CameraPreview(_cameraController),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            File? image = await pickImageFromGallery(context);
                            //if (!mounted) return;
                            if (image != null) {
                              // ignore: use_build_context_synchronously
                              final finalImage = await navigateNamedTo(
                                context,
                                Routes.sendingImageViewRoute,
                                arguments: {
                                  'path': image.path,
                                  'uId': widget.receiverId,
                                },
                              );
                              if (!mounted) return;
                              log(finalImage.toString());
                              ref.read(feedProvider.notifier).createPost(
                                context,
                                isStory: !finalImage.$2,
                                filePath: [finalImage.$1],
                              );
                              FeedRepo.pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          child: const CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.black38,
                            child: Icon(
                              Icons.photo,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (!isRecording) takePhoto(context);
                          },
                          onLongPress: () async {
                            await _cameraController.startVideoRecording();
                            setState(() {
                              isRecording = true;
                            });
                          },
                          onLongPressUp: () async {
                            XFile videoPath =
                                await _cameraController.stopVideoRecording();
                            setState(() {
                              isRecording = false;
                            });
                            if (!mounted) return;
                            final finalImage = await navigateNamedTo(
                              context,
                              Routes.sendingVideoViewRoute,
                              arguments: {
                                'uId': widget.receiverId,
                                'path': videoPath.path,
                              },
                            );
                            if (!mounted) return;
                            log(finalImage.toString());
                            ref.read(feedProvider.notifier).createPost(
                              context,
                              isStory: !finalImage.$2,
                              isVideo: true,
                              filePath: [finalImage.$1],
                            );
                            FeedRepo.pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: cameraIcon(),
                        ),
                        GestureDetector(
                          onTap: toggleCameraFront,
                          child: const CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.black38,
                            child: Icon(
                              Icons.flip_camera_ios,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Text(
              'Hold for video, tap for photo',
              style: CustomTextStyle.large16.white,
            ),
          ),
        ],
      ),
    );
  }

  Icon cameraIcon() {
    return isRecording
        ? const Icon(
            Icons.radio_button_on,
            color: Colors.red,
            size: 80,
          )
        : const Icon(
            Icons.panorama_fish_eye,
            size: 80,
            weight: 10,
            color: Colors.white,
          );
  }

  void toggleFlash() {
    setState(() {
      isFlashOn = !isFlashOn;
    });
    isFlashOn
        ? _cameraController.setFlashMode(FlashMode.torch)
        : _cameraController.setFlashMode(FlashMode.off);
  }

  void toggleCameraFront() {
    setState(() {
      isCameraFront = !isCameraFront;
    });
    int cameraPos = isCameraFront ? 0 : 1;
    _cameraController =
        CameraController(cameras[cameraPos], ResolutionPreset.high);
    _cameraValue = _cameraController.initialize();
  }

  void takePhoto(BuildContext context) async {
    XFile file = await _cameraController.takePicture();
    if (!mounted) return;
    final fileName = basename(file.path);
    var image = imageLib.decodeImage(File(file.path).readAsBytesSync());
    if (image == null) return;
    image = imageLib.copyRotate(image, 90);
    //if (image == null) return;
    Map? imagefile = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoFilterSelector(
          title: const Text("Photo Filter Example"),
          image: image!,
          filters: photofilters.presetFiltersList,
          filename: fileName,
          loader: const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
    if (!(imagefile != null && imagefile.containsKey('image_filtered'))) return;
    if (!mounted) return;
    final finalImage = await navigateNamedTo(
        context, Routes.sendingImageViewRoute,
        arguments: {
          'path': imagefile['image_filtered'].path,
          'uId': widget.receiverId,
        });
    if (!mounted) return;
    log(finalImage.toString());
    ref.read(feedProvider.notifier).createPost(
      context,
      isStory: !finalImage.$2,
      filePath: [finalImage.$1],
    );
    FeedRepo.pageController.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _cameraController.dispose();
  }
}
