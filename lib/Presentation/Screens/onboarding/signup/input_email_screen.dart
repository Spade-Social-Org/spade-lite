import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:spade_v4/Common/navigator.dart';
import 'package:spade_v4/Presentation/Screens/onboarding/signup/verify_email.dart';

import 'package:spade_v4/Presentation/Screens/onboarding/widgets/form_labels.dart';
import 'package:spade_v4/Presentation/Screens/onboarding/widgets/form_title.dart';
import 'package:spade_v4/Presentation/widgets/custom_button.dart';
import 'package:spade_v4/Presentation/widgets/custom_textfield.dart';

class InputEmailScreen extends StatefulWidget {
  final String name;
  final String password;
  final String phoneNumber;

  const InputEmailScreen({
    Key? key,
    required this.name,
    required this.password,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<InputEmailScreen> createState() => _InputEmailScreenState();
}

class _InputEmailScreenState extends State<InputEmailScreen> {
  final email = TextEditingController();
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
                      child: FormTitle(formTitle: "What's your email?")),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.2),
                  const FormLabel(formLabel: "Email"),
                  const SizedBox(height: 5),
                  CustomTextfield(
                    controller: email,
                    autoFocus: true,
                    textCapitalization: TextCapitalization.none,
                    hintText: "Enter your email",
                    keyboardType: TextInputType.emailAddress,
                    validator:
                        ValidationBuilder().email().maxLength(50).build(),
                  ),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.4),
                  CustomButton(
                      color: Colors.black,
                      text: 'Next',
                      onPressed: () async {
                        if (form.currentState!.validate()) {
                          push(VerifyEmail(
                              name: widget.name,
                              password: widget.password,
                              email: email.text,
                              phoneNumber: widget.phoneNumber));
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
