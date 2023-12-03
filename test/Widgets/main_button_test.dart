import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spade_lite/Presentation/widgets/jh_main_button.dart';

void main() {
  /// This syntax is used to test widgets

  testWidgets('MainButton displays correct title and color',
          (WidgetTester tester) async {
        bool buttonPressed = true;
        void onPressed() {
          buttonPressed = true;
        }

        /// pumpWidget is always called for the widget we want to build
        ///don't forget to surround it with a [Material Widget]
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: JHMainButton(
                  title: 'Tap me',
                  color: Colors.blue,
                  onPressed: onPressed,
                ),
              ),
            ),
          ),
        );

        ///This code tries to find if in CUSTOMMaterialButton there is a MaterialButton
        final materialButtonFinder = find.byType(MaterialButton);

        ///we use it a finder which finds fromType

        expect(materialButtonFinder, findsOneWidget);

        /// always use await keyword we check if the button
        /// works well. Here we send a tap event to trigger the button
        await tester.tap(materialButtonFinder);
        await tester.pump();

        expect(buttonPressed, isTrue);
      });
}