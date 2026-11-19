import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nusa_news/widgets/news_image.dart';

void main() {
  group('NewsImage Widget Tests', () {
    testWidgets('menampilkan placeholder jika imageUrl bernilai null',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NewsImage(imageUrl: null, width: 100, height: 100),
          ),
        ),
      );

      expect(find.byIcon(Icons.image_not_supported_outlined), findsOneWidget);
    });

    testWidgets('menampilkan placeholder jika imageUrl berupa string kosong',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NewsImage(imageUrl: '   ', width: 100, height: 100),
          ),
        ),
      );

      expect(find.byIcon(Icons.image_not_supported_outlined), findsOneWidget);
    });

    testWidgets('mampu me-render NewsImage dengan URL tanpa throwing exception',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NewsImage(
              imageUrl: 'https://example.com/gaming-news.jpg',
              width: 120,
              height: 80,
            ),
          ),
        ),
      );

      expect(find.byType(NewsImage), findsOneWidget);
    });
  });
}
