import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:nusa_news/views/home_view.dart';

void main() {
  group('HomeView Widget & State Tests', () {
    testWidgets('HomeView menampilkan judul GameScope ID dan bar kategori',
        (tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: HomeView(),
        ),
      );

      // Verifikasi judul AppBar RichText
      expect(find.byType(RichText), findsWidgets);

      // Verifikasi 5 kategori utama
      expect(find.text('Technology'), findsOneWidget);
      expect(find.text('Science'), findsOneWidget);
      expect(find.text('Entertainment'), findsOneWidget);
      expect(find.text('Sports'), findsOneWidget);
      expect(find.text('Business'), findsOneWidget);

      // Verifikasi icon search di AppBar
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('Dialog pencarian membuka input dan tombol Cari/Batal',
        (tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: HomeView(),
        ),
      );

      // Ketuk icon pencarian
      await tester.tap(find.byIcon(Icons.search));
      await tester.pump();

      // Dialog harus terbuka
      expect(find.text('Cari Berita'), findsOneWidget);
      expect(find.text('Batal'), findsOneWidget);
      expect(find.text('Cari'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);

      // Tekan batal
      await tester.tap(find.text('Batal'));
      await tester.pump();

      // Dialog tertutup
      expect(find.text('Cari Berita'), findsNothing);
    });
  });
}
