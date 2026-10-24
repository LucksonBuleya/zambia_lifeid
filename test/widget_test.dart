import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zambia_lifeid/main.dart';
import 'package:zambia_lifeid/services/checklist_store.dart';
import 'package:zambia_lifeid/widgets/typewriter_text.dart';

/// A narrow (360 dp) but tall phone screen, so every card is built and any
/// layout overflow on small phones makes the test fail. Animations are turned
/// off (like the phone's "remove animations" setting) so screens can settle.
void usePhoneScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 4800);
  tester.view.devicePixelRatio = 3.0;
  tester.platformDispatcher.accessibilityFeaturesTestValue =
      const FakeAccessibilityFeatures(disableAnimations: true);
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
}

/// Opens a province dropdown (scrolling to it if needed) and picks [province].
Future<void> selectProvince(WidgetTester tester, String province) async {
  final dropdown = find.byType(DropdownButtonFormField<String>);
  final list = find.descendant(of: find.byType(ListView), matching: find.byType(Scrollable));
  await tester.scrollUntilVisible(dropdown, 300, scrollable: list.first);
  await tester.pumpAndSettle();
  await tester.tap(dropdown);
  await tester.pumpAndSettle();
  await tester.tap(find.text('$province Province').last);
  await tester.pumpAndSettle();
}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await checklistStore.load();
    checklistStore.reset('driving');
  });

  testWidgets('Home shows the four services and search filters them', (tester) async {
    usePhoneScreen(tester);
    await tester.pumpWidget(const ZambiaLifeIdApp());

    expect(find.text('Zambia LifeID'), findsOneWidget);
    expect(find.text('NRC'), findsOneWidget);
    expect(find.text('Birth Certificate'), findsOneWidget);
    expect(find.text('Passport'), findsOneWidget);
    expect(find.text('Driving Licence'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'rtsa');
    await tester.pump();
    expect(find.text('Driving Licence'), findsOneWidget);
    expect(find.text('Passport'), findsNothing);

    await tester.enterText(find.byType(TextField), 'xyz');
    await tester.pump();
    expect(find.textContaining('No services match'), findsOneWidget);
  });

  testWidgets('Driving licence checklist ticks and shows progress', (tester) async {
    usePhoneScreen(tester);
    await tester.pumpWidget(const ZambiaLifeIdApp());

    await tester.tap(find.text('Driving Licence'));
    await tester.pumpAndSettle();
    expect(find.text('0 of 3 completed'), findsOneWidget);

    await tester.tap(find.text('Medical certificate'));
    await tester.pump();
    expect(find.text('1 of 3 completed'), findsOneWidget);

    // The same progress appears on the My Lists tab.
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('My Lists'));
    await tester.pumpAndSettle();
    expect(find.text('1 of 3 completed'), findsOneWidget);
  });

  testWidgets('Overview and Before You Apply swipe like a card stack', (tester) async {
    usePhoneScreen(tester);
    await tester.pumpWidget(const ZambiaLifeIdApp());

    await tester.tap(find.text('Birth Certificate'));
    await tester.pumpAndSettle();
    expect(find.text('Next: Before You Apply'), findsOneWidget);

    await tester.drag(find.byType(PageView), const Offset(-300, 0));
    await tester.pumpAndSettle();
    expect(find.text('Back to Overview'), findsOneWidget);

    await tester.tap(find.text('Back to Overview'));
    await tester.pumpAndSettle();
    expect(find.text('Next: Before You Apply'), findsOneWidget);
  });

  testWidgets('Service details show verified offices or an honest note', (tester) async {
    usePhoneScreen(tester);
    await tester.pumpWidget(const ZambiaLifeIdApp());

    await tester.tap(find.text('Driving Licence'));
    await tester.pumpAndSettle();

    await selectProvince(tester, 'Lusaka');
    expect(find.text('RTSA Head Office (Road Safety House)'), findsOneWidget);

    await selectProvince(tester, 'Western');
    expect(find.textContaining('No verified Driving Licence office details for Western'),
        findsOneWidget);
  });

  testWidgets('Offices tab filters by province and service', (tester) async {
    usePhoneScreen(tester);
    await tester.pumpWidget(const ZambiaLifeIdApp());

    await tester.tap(find.text('Offices'));
    await tester.pumpAndSettle();
    expect(find.text('Select a province to see offices.'), findsOneWidget);

    await selectProvince(tester, 'Copperbelt');
    expect(find.text('Passport issuing centre - Ndola'), findsOneWidget);
    expect(find.text('RTSA office - Ndola'), findsOneWidget);
    expect(find.textContaining('Address not verified'), findsWidgets);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Passport'));
    await tester.pumpAndSettle();
    expect(find.text('Passport issuing centre - Ndola'), findsOneWidget);
    expect(find.text('RTSA office - Ndola'), findsNothing);

    await selectProvince(tester, 'Western');
    expect(find.textContaining('No verified offices for Western Province'), findsOneWidget);
    expect(find.text('Head offices (Lusaka)'), findsOneWidget);
  });

  testWidgets('Templates tab shows unofficial templates', (tester) async {
    usePhoneScreen(tester);
    await tester.pumpWidget(const ZambiaLifeIdApp());

    await tester.tap(find.text('Templates'));
    await tester.pumpAndSettle();
    expect(find.text('Driving licence preparation'), findsOneWidget);
    expect(find.textContaining('Unofficial'), findsWidgets);
  });

  testWidgets('Typewriter types a phrase letter by letter', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(body: TypewriterText(phrases: ['Hello', 'World'])),
    ));
    expect(find.text(''), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 150)); // two letters
    expect(find.text('He'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 210)); // the rest
    expect(find.text('Hello'), findsOneWidget);
  });

  test('Checklist progress is saved and loaded again after a restart', () async {
    final firstRun = ChecklistStore();
    await firstRun.load();
    firstRun.toggle('passport', 'pp_nrc');

    // A new store simulates reopening the app: it reads what was saved.
    final secondRun = ChecklistStore();
    await secondRun.load();
    expect(secondRun.isChecked('passport', 'pp_nrc'), isTrue);
    expect(secondRun.isChecked('passport', 'pp_birth'), isFalse);
  });
}
