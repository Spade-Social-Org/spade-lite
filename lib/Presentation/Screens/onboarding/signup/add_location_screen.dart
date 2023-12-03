import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spade_lite/Common/navigator.dart';
import 'package:spade_lite/Presentation/Screens/onboarding/model/register_model.dart';
import 'package:spade_lite/Presentation/Screens/onboarding/signup/add_username_screen.dart';
import 'package:spade_lite/Presentation/Screens/onboarding/widgets/form_title.dart';
import 'package:spade_lite/Presentation/widgets/custom_button.dart';


class AddLocationScreen extends StatefulWidget {
  final String name;
  final String password;
  final String phoneNumber;
  final String email;
  const AddLocationScreen({
    Key? key,
    required this.name,
    required this.password,
    required this.phoneNumber,
    required this.email,
  }) : super(key: key);

  @override
  State<AddLocationScreen> createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen> {
  final postalCode = TextEditingController();

  String country = "";
  String state = "";
  String city = "";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Center(
                    child: FormTitle(
                  formTitle: "Where do you live?",
                )),
                const SizedBox(height: 20),
                Image.asset("assets/images/location2.png", height: 250),
                const SizedBox(height: 20),
                CSCPicker(
                  flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,
                  countrySearchPlaceholder: "Country",
                  stateSearchPlaceholder: "State",
                  citySearchPlaceholder: "City",
                  countryDropdownLabel: "Country",
                  stateDropdownLabel: "State",
                  cityDropdownLabel: "City",
                  onCountryChanged: (value) => setState(() => country = value),
                  onStateChanged: (value) =>
                      setState(() => state = value ?? ""),
                  onCityChanged: (value) => setState(() => city = value ?? ""),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: postalCode,
                  style: const TextStyle(fontSize: 14),
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    hintText: "Postal Code",
                    hintStyle: const TextStyle(fontSize: 14),
                    errorStyle: const TextStyle(color: Colors.black),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 100),
                Consumer(builder: (context, ref, _) {
                  return CustomButton(
                      color: Colors.black,
                      text: 'Next',
                      onPressed: () async {
                        final model = RegisterModel(
                            email: widget.email,
                            password: widget.password,
                            name: widget.name,
                            phoneNumber: widget.phoneNumber,
                            country: country,
                            city: city,
                            state: state,
                            postalCode: postalCode.text.trim());

                        push(AddUsernameScreen(registerModel: model));
                      });
                }),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
