import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nusa_news/models/article_model.dart';
import 'package:nusa_news/services/api_exception.dart';
import 'package:nusa_news/widgets/article_card.dart';
import 'package:nusa_news/widgets/empty_state.dart';
import 'package:nusa_news/widgets/error_view.dart';

void main() {
  group('ErrorView Widget Tests', () {
    testWidgets(
        'menampilkan pesan ApiException dan memanggil callback retry saat ditekan',
        (tester) async {
      bool retried = false;
      const exception = ApiException(ApiMessages.noInternet);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorView(
              error: exception,
              onRetry: () {
                retried = true;
              },
            ),
          ),
        ),
      );

      // Pastikan pesan error tampil
      expect(find.text(ApiMessages.noInternet), findsOneWidget);
      // Pastikan icon wifi_off tampil untuk noInternet
      expect(find.byIcon(Icons.wifi_off_rounded), findsOneWidget);
      // Pastikan tombol Coba Lagi tampil
      expect(find.text('Coba Lagi'), findsOneWidget);

      // Tekan tombol Coba Lagi
      await tester.tap(find.text('Coba Lagi'));
      await tester.pump();

      expect(retried, isTrue);
    });

    testWidgets('menampilkan icon key_off untuk error API key', (tester) async {
      const exception =
          ApiException(ApiMessages.apiKeyInvalid, statusCode: 401);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorView(
              error: exception,
              onRetry: () {},
            ),
          ),
        ),
      );

      expect(find.text(ApiMessages.apiKeyInvalid), findsOneWidget);
      expect(find.byIcon(Icons.key_off_outlined), findsOneWidget);
    });

    testWidgets('menampilkan icon timer_off untuk error timeout',
        (tester) async {
      const exception = ApiException(ApiMessages.timeout);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorView(
              error: exception,
              onRetry: () {},
            ),
          ),
        ),
      );

      expect(find.text(ApiMessages.timeout), findsOneWidget);
      expect(find.byIcon(Icons.timer_off_outlined), findsOneWidget);
    });

    testWidgets('menampilkan icon block untuk error kuota', (tester) async {
      const exception = ApiException(ApiMessages.accessDenied, statusCode: 403);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorView(
              error: exception,
              onRetry: () {},
            ),
          ),
        ),
      );

      expect(find.text(ApiMessages.accessDenied), findsOneWidget);
      expect(find.byIcon(Icons.block_outlined), findsOneWidget);
    });
  });

  group('EmptyState Widget Tests', () {
    testWidgets('menampilkan pesan dan saran dengan benar', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(
              message: 'Tidak ada berita ditemukan.',
              suggestion: 'Gunakan kata kunci lain.',
            ),
          ),
        ),
      );

      expect(find.text('Tidak ada berita ditemukan.'), findsOneWidget);
      expect(find.text('Gunakan kata kunci lain.'), findsOneWidget);
      expect(find.byIcon(Icons.search_off_rounded), findsOneWidget);
    });
  });

  group('ArticleCard Widget Tests', () {
    testWidgets('menampilkan judul, sumber, dan merespons tap', (tester) async {
      bool tapped = false;
      final article = ArticleModel(
        title: 'GeForce RTX 5090 Diumumkan',
        description: 'Spesifikasi GPU arsitektur Blackwell generasi terbaru.',
        url: 'https://example.com/rtx5090',
        publishedAt: DateTime(2026, 11, 19, 14, 0),
        sourceName: 'TechRadar ID',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ArticleCard(
              article: article,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('GeForce RTX 5090 Diumumkan'), findsOneWidget);
      expect(find.text('TechRadar ID'), findsOneWidget);

      await tester.tap(find.text('GeForce RTX 5090 Diumumkan'));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('tampilan featured menampilkan badge TERKINI', (tester) async {
      final article = ArticleModel(
        title: 'GTA 6 Rilis Trailer Kedua',
        description: 'Rockstar Games merilis trailer gameplay terbaru.',
        url: 'https://example.com/gta6-trailer',
        publishedAt: DateTime(2026, 11, 19, 10, 0),
        sourceName: 'IGN ID',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ArticleCard(
              article: article,
              featured: true,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('TERKINI'), findsOneWidget);
      expect(find.text('GTA 6 Rilis Trailer Kedua'), findsOneWidget);
      expect(find.text('IGN ID'), findsOneWidget);
    });
  });
}
