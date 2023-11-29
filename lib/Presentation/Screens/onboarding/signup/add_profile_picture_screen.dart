import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spade_v4/Common/constants.dart';
import 'package:spade_v4/Common/image_properties.dart';
import 'package:spade_v4/Common/navigator.dart';
import 'package:spade_v4/Common/utils/utils.dart';
import 'package:spade_v4/Presentation/Screens/onboarding/provider/set_profile_image_provider.dart';
import 'package:spade_v4/Presentation/Screens/onboarding/widgets/form_title.dart';
import 'package:spade_v4/Presentation/widgets/custom_button.dart';

class AddProfilePictureScreen extends ConsumerStatefulWidget {
  const AddProfilePictureScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<AddProfilePictureScreen> createState() =>
      _AddUsernameScreenState();
}

class _AddUsernameScreenState extends ConsumerState<AddProfilePictureScreen> {
  String? filePath;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Center(
                  child: FormTitle(
                    formTitle: "Please upload a profile picture",
                  ),
                ),
                105.spacingH,
                InkWell(
                  onTap: () async {
                    final image = await pickImageFromGallery(context);
                    if (image != null) {
                      setState(() {
                        filePath = image.path;
                      });
                    }
                  },
                  child: Stack(
                    children: [
                      Container(
                        height: 300,
                        width: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: (filePath == null
                                ? const NetworkImage(
                                    AppConstants.defaultImage,
                                  )
                                : FileImage(
                                    File(filePath!),
                                  )) as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 20,
                        child: Container(
                          width: 50,
                          height: 50,
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            color: const Color(0xFF939393),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                210.spacingH,
                CustomButton(
                  color: Colors.black,
                  text: 'Next',
                  onPressed: () async {
                    if (filePath == null) return;
                    ref.read(profileImageProvider.notifier).saveProfilePicture(
                          context,
                          filePath: filePath!,
                        );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
