import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/ui/weather.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  testWidgets("Weather Widget Test", (WidgetTester tester) async {
    // Build our widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Weather(),
        ),
      ),
    );

    // Verify text elements
    final dateString = DateFormat('MMMM d H:m').format(DateTime.now());
    expect(find.text(dateString), findsOneWidget);
    expect(find.text('20'), findsOneWidget);
    expect(find.text('℃'), findsOneWidget);
    expect(find.text('Tokyo'), findsOneWidget);
    expect(find.text('Sunny'), findsOneWidget);

    // Verify widget types with exact counts
    expect(find.byType(Row), findsNWidgets(2));      // Two Rows
    expect(find.byType(Column), findsNWidgets(2));   // Two Columns
    expect(find.byType(Container), findsNWidgets(5)); // Five Containers
    expect(find.byType(Image), findsOneWidget);       // One Image
    expect(find.byType(ClipOval), findsOneWidget);    // One ClipOval
  });
}