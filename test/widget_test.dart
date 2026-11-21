import 'package:aagaaz_institute/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('mobile sign-in opens courses and live classes', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const AagaazApp());
    await tester.pump();

    expect(find.text('Aagaaz Institute'), findsOneWidget);
    expect(find.text('Sign in with your mobile number'), findsOneWidget);

    final continueButton = tester.widget<FilledButton>(
      find.byKey(const Key('continue-button')),
    );
    expect(continueButton.onPressed, isNull);

    await tester.enterText(find.byKey(const Key('phone-field')), '1234567890');
    await tester.pump();
    expect(
      tester.widget<FilledButton>(find.byKey(const Key('continue-button'))).onPressed,
      isNull,
    );

    await tester.enterText(find.byKey(const Key('phone-field')), '9876543210');
    await tester.pump();
    await tester.tap(find.byKey(const Key('continue-button')));
    await tester.pumpAndSettle();

    expect(find.text('Enter the 6-digit code'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('otp-field')), '123456');
    await tester.pump();
    await tester.tap(find.byKey(const Key('verify-button')));
    await tester.pumpAndSettle();

    expect(find.text('Live classes'), findsWidgets);
    expect(find.text('UPSC CSE Foundation'), findsWidgets);
    expect(find.text('Fundamental Rights: Articles 12–35'), findsWidgets);
    expect(find.text('+91 98••• 210'), findsWidgets);

    await tester.tap(find.text('MPPSC Mains').hitTestable());
    await tester.pumpAndSettle();
    expect(find.text('Enroll in this batch'), findsOneWidget);
    await tester.tap(find.byKey(const Key('enroll-button')));
    await tester.pumpAndSettle();
    expect(find.text('Enrolled · 0% complete'), findsOneWidget);
  });
}
