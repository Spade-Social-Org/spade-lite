import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:spade_lite/Common/navigator.dart';
import 'package:spade_lite/Presentation/Screens/onboarding/widgets/form_labels.dart';
import 'package:spade_lite/Presentation/Screens/onboarding/widgets/form_title.dart';
import 'package:spade_lite/Presentation/widgets/custom_textfield.dart';

import '../../../widgets/custom_button.dart';
import 'input_password.dart';

class FirstNameScreen extends StatefulWidget {
  const FirstNameScreen({super.key});

  @override
  State<FirstNameScreen> createState() => _FirstNameScreenState();
}

class _FirstNameScreenState extends State<FirstNameScreen> {
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
                      child: FormTitle(formTitle: "What's your name?")),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.2),
                  const FormLabel(formLabel: "First Name"),
                  const SizedBox(height: 8),
                  CustomTextfield(
                    controller: controller,
                    autoFocus: true,
                    hintText: 'Enter your first name',
                    validator:
                        ValidationBuilder().minLength(3).maxLength(50).build(),
                  ),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.4),
                  CustomButton(
                    color: Colors.black,
                    text: 'Next',
                    onPressed: () {
                      if (form.currentState!.validate()) {
                        push(InputPassword(name: controller.text.trim()));
                      }
                    },
                  ),
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
