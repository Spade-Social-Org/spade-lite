import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';
import 'package:spade_lite/Common/navigator.dart';
import 'package:spade_lite/Presentation/Screens/onboarding/model/otp_model.dart';
import 'package:spade_lite/Presentation/Screens/onboarding/provider/onboarding_provider.dart';
import 'package:spade_lite/Presentation/Screens/onboarding/signup/add_profile_picture_screen.dart';

import 'package:spade_lite/Presentation/Screens/onboarding/widgets/form_labels.dart';
import 'package:spade_lite/Presentation/Screens/onboarding/widgets/form_title.dart';
import 'package:spade_lite/Presentation/widgets/custom_button.dart';

import '../provider/loading_state_provider.dart';

class VerifyEmail extends StatefulWidget {
  final int userId;
  const VerifyEmail({Key? key, required this.userId}) : super(key: key);

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  final otp = TextEditingController();
  final form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final provider = ref.watch(onboardingProvider);
      return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Form(
                key: form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Center(
                        child: FormTitle(formTitle: "Verification Code")),
                    SizedBox(height: MediaQuery.sizeOf(context).height * 0.2),
                    const FormLabel(
                        formLabel: "Enter the OTP sent to your email"),
                    const SizedBox(height: 5),
                    Pinput(
                      autofocus: true,
                      controller: otp,
                      length: 6,
                      validator: (value) =>
                          value!.length != 6 ? 'Field is required' : null,
                      hapticFeedbackType: HapticFeedbackType.vibrate,
                      defaultPinTheme: PinTheme(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 16),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10)),
                          textStyle: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 8),
                    Consumer(builder: (context, ref, _) {
                      return StreamBuilder<bool>(
                          stream:
                              ref.watch(loadingStateProvider).isLoadingStream,
                          initialData: false,
                          builder: (context, snapshot) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: CustomButton(
                                  height: 40,
                                  onPressed: () async {
                                    final model = OTPModel(
                                        userId: "${widget.userId}",
                                        useEmail: true);
                                    provider.sendOTP(model);
                                  },
                                  child: snapshot.data!
                                      ? const SizedBox(
                                          height: 25,
                                          width: 25,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                                strokeWidth: 3),
                                          ))
                                      : const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text('Didn\'t receive code?'),
                                            SizedBox(width: 4),
                                            Text('Re-send',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                ))
                                          ],
                                        )),
                            );
                          });
                    }),
                    SizedBox(height: MediaQuery.sizeOf(context).height * 0.3),
                    CustomButton(
                        color: Colors.black,
                        text: 'Next',
                        onPressed: () async {
                          if (form.currentState!.validate()) {
                            provider.verifyOTP(otp.text.trim()).then((value) {
                              if (value.statusCode == 'SUCCESS') {
                                push(const AddProfilePictureScreen());
                              }
                            });
                          }
                        }),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
