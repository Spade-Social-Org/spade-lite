// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spade_lite/Common/navigator.dart';

import 'package:spade_lite/Presentation/Screens/onboarding/widgets/form_labels.dart';
import 'package:spade_lite/Presentation/Screens/onboarding/widgets/form_title.dart';
import 'package:spade_lite/Presentation/widgets/custom_button.dart';
import 'package:spade_lite/Presentation/widgets/custom_textfield.dart';

import 'input_phone_number_screen.dart';

class InputPassword extends StatefulWidget {
  final String name;
  const InputPassword({
    super.key,
    required this.name,
  });

  @override
  State<InputPassword> createState() => _InputPasswordState();
}

class _InputPasswordState extends State<InputPassword> {
  bool obscureText = true;
  bool cnObscureText = true;
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                      child: FormTitle(formTitle: "Please create a password")),
                  SizedBox(height: MediaQuery.sizeOf(context).height / 6),
                  const FormLabel(formLabel: "Password"),
                  const SizedBox(height: 5),
                  CustomTextfield(
                    obscureText: obscureText,
                    controller: password,
                    autoFocus: true,
                    suffixIcon: IconButton(
                        onPressed: () =>
                            setState(() => obscureText = !obscureText),
                        icon: Icon(
                          obscureText
                              ? CupertinoIcons.eye_slash_fill
                              : CupertinoIcons.eye_fill,
                          color: Colors.grey,
                        )),
                    hintText: "Enter Password",
                    validator: (value) =>
                        value!.length < 6 ? 'Password is too short' : null,
                  ),
                  const SizedBox(height: 16),
                  const FormLabel(formLabel: "Confirm Password"),
                  const SizedBox(height: 5),
                  CustomTextfield(
                    obscureText: cnObscureText,
                    controller: confirmPassword,
                    hintText: "Confirm Password",
                    validator: (value) => !value!.contains(password.text.trim())
                        ? 'Password does not match'
                        : null,
                    suffixIcon: IconButton(
                      onPressed: () =>
                          setState(() => cnObscureText = !cnObscureText),
                      icon: Icon(
                        cnObscureText
                            ? CupertinoIcons.eye_slash_fill
                            : CupertinoIcons.eye_fill,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.3),
                  CustomButton(
                      color: Colors.black,
                      text: 'Next',
                      onPressed: () async {
                        if (form.currentState!.validate()) {
                          push(InputPhoneNumberScreen(
                              name: widget.name, password: password.text));
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
