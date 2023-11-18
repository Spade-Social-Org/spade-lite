import 'dart:io';

import 'package:flutter/material.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spade_lite/Presentation/Screens/messages/widget/custom_snackbar.dart';

Future<File?> pickImageFromGallery(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    customSnackBar(
      e.toString(),
    );
  }
  return image;
}

Future<GiphyGif?> pickGif(BuildContext context) async {
  GiphyGif? gif;
  try {
    gif = await GiphyGet.getGif(
      context: context,
      apiKey: '',
    );
  } catch (e) {
    customSnackBar(e.toString());
  }
  return gif;
}

Future<CroppedFile?> cropImage(String path) async {
  return ImageCropper().cropImage(
    sourcePath: path,
    aspectRatioPresets: Platform.isAndroid
        ? [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ]
        : [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio5x3,
            CropAspectRatioPreset.ratio5x4,
            CropAspectRatioPreset.ratio7x5,
            CropAspectRatioPreset.ratio16x9
          ],
    aspectRatio: const CropAspectRatio(
      ratioX: 1.0,
      ratioY: 1.0,
    ),
    compressQuality: 100,
    maxWidth: 400,
    maxHeight: 400,
    compressFormat: ImageCompressFormat.jpg,
    cropStyle: CropStyle.rectangle,
    uiSettings: [
      AndroidUiSettings(
          toolbarColor: Colors.teal,
          toolbarTitle: "Profile Image",
          statusBarColor: Colors.teal,
          backgroundColor: Colors.white,
          hideBottomControls: true,
          lockAspectRatio: false,
          initAspectRatio: CropAspectRatioPreset.square,
          toolbarWidgetColor: Colors.white),
    ],
  );
}
