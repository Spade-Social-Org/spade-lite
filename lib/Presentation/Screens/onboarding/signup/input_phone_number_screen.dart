// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:spade_lite/Common/navigator.dart';

import 'package:spade_lite/Presentation/Screens/onboarding/widgets/form_labels.dart';
import 'package:spade_lite/Presentation/Screens/onboarding/widgets/form_title.dart';
import 'package:spade_lite/Presentation/widgets/custom_button.dart';
import 'package:spade_lite/Presentation/widgets/custom_textfield.dart';

import 'input_email_screen.dart';

class InputPhoneNumberScreen extends StatefulWidget {
  final String name;
  final String password;
  const InputPhoneNumberScreen({
    Key? key,
    required this.name,
    required this.password,
  }) : super(key: key);

  @override
  State<InputPhoneNumberScreen> createState() => _InputPhoneNumberScreenState();
}

class _InputPhoneNumberScreenState extends State<InputPhoneNumberScreen> {
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
          child: SingleChildScrollView(
            child: Form(
              key: form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                      child: FormTitle(formTitle: "Whats your phone number?")),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.2),
                  const FormLabel(formLabel: "Mobile Number"),
                  const SizedBox(height: 5),
                  CustomTextfield(
                    controller: controller,
                    autoFocus: true,
                    keyboardType: TextInputType.number,
                    hintText: "+1-400-200-9000",
                    validator:
                        ValidationBuilder().phone().maxLength(50).build(),
                  ),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.4),
                  CustomButton(
                      color: Colors.black,
                      text: 'Next',
                      onPressed: () async {
                        if (form.currentState!.validate()) {
                          push(InputEmailScreen(
                              name: widget.name,
                              password: widget.password,
                              phoneNumber: controller.text));
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
  }
}
