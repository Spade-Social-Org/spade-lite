import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spade_lite/Common/navigator.dart';
import 'package:spade_lite/Presentation/Screens/onboarding/model/register_model.dart';
import 'package:spade_lite/Presentation/Screens/onboarding/signup/verify_email.dart';
import 'package:spade_lite/Presentation/Screens/onboarding/widgets/form_title.dart';
import 'package:spade_lite/Presentation/widgets/custom_button.dart';

import '../provider/onboarding_provider.dart';

import 'package:form_validator/form_validator.dart';

import 'package:spade_lite/Presentation/Screens/onboarding/widgets/form_labels.dart';

import 'package:spade_lite/Presentation/widgets/custom_textfield.dart';

class AddUsernameScreen extends ConsumerStatefulWidget {
  final RegisterModel registerModel;
  const AddUsernameScreen({
    Key? key,
    required this.registerModel,
  }) : super(key: key);

  @override
  ConsumerState<AddUsernameScreen> createState() => _AddUsernameScreenState();
}

class _AddUsernameScreenState extends ConsumerState<AddUsernameScreen> {
  final controller = TextEditingController();

  final form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: form,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                      child: FormTitle(formTitle: "Create a Username")),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.2),
                  const FormLabel(formLabel: "Username"),
                  const SizedBox(height: 8),
                  CustomTextfield(
                    controller: controller,
                    autoFocus: true,
                    hintText: 'Ex. Jdoe100',
                    validator:
                        ValidationBuilder().minLength(3).maxLength(50).build(),
                  ),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.4),
                  CustomButton(
                      color: Colors.black,
                      text: 'Next',
                      onPressed: () async {
                        if (!form.currentState!.validate()) return;
                        final model = widget.registerModel
                            .copyWith(username: controller.text);

                        ref
                            .read(onboardingProvider)
                            .register(model)
                            .then((value) {
                          if (value.statusCode == 'SUCCESS') {
                            push(VerifyEmail(userId: value.data!.userId!));
                          }
                        });
                      }),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
