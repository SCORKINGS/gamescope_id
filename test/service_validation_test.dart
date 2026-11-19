import 'package:flutter_test/flutter_test.dart';
import 'package:nusa_news/models/article_model.dart';
import 'package:nusa_news/services/api_exception.dart';
import 'package:nusa_news/services/news_api_service.dart';

void main() {
  group('NewsApiService Validation Tests', () {
    test('searchNews melempar ApiException jika API Key kosong', () async {
      // Karena Env.apiKey defaultValue adalah '', pemanggilan tanpa --dart-define akan menghasilkan apiKey kosong
      final service = NewsApiService();

      expect(
        () => service.searchNews('gaming'),
        throwsA(
          isA<ApiException>().having(
            (e) => e.message,
            'message',
            ApiMessages.apiKeyEmpty,
          ),
        ),
      );
    });

    test('getTopHeadlines melempar ApiException jika API Key kosong', () async {
      final service = NewsApiService();

      expect(
        () => service.getTopHeadlines(category: 'technology'),
        throwsA(
          isA<ApiException>().having(
            (e) => e.message,
            'message',
            ApiMessages.apiKeyEmpty,
          ),
        ),
      );
    });

    test(
        'searchNews melempar ApiException jika keyword lebih dari 200 karakter',
        () async {
      final service = NewsApiService();
      expect(
        () => service.searchNews('a' * 201),
        throwsA(isA<ApiException>()),
      );
    });
  });

  group('NewsApiService Content Filter & Deduplication Tests', () {
    test(
        'menolak artikel yang mengandung kata terlarang (casino, gambling, judi online, slot gacor, taruhan, togel, sportsbook, bonus deposit, rtp)',
        () {
      final blockedSamples = [
        const ArticleModel(
          title: 'Daftar Situs Casino Online Terpercaya',
          url: 'https://example.com/1',
        ),
        const ArticleModel(
          title: 'Review Gadget',
          description: 'Panduan gambling online untuk pemula',
          url: 'https://example.com/2',
        ),
        const ArticleModel(
          title: 'Aplikasi Terbaru',
          description: 'Trik menang judi online di smartphone',
          url: 'https://example.com/3',
        ),
        const ArticleModel(
          title: 'Slot Gacor Hari Ini Modal Kecil',
          url: 'https://example.com/4',
        ),
        const ArticleModel(
          title: 'Taruhan Bola Piala Dunia Online',
          url: 'https://example.com/5',
        ),
        const ArticleModel(
          title: 'Hasil Togel Hongkong Tercepat',
          url: 'https://example.com/6',
        ),
        const ArticleModel(
          title: 'Platform Sportsbook Resmi Indonesia',
          url: 'https://example.com/7',
        ),
        const ArticleModel(
          title: 'Game Populer',
          description: 'Dapatkan bonus deposit 100% khusus member baru',
          url: 'https://example.com/8',
        ),
        const ArticleModel(
          title: 'Bocoran RTP Live Slot Hari Ini',
          url: 'https://example.com/9',
        ),
      ];

      for (final article in blockedSamples) {
        expect(
          NewsApiService.isArticleSafe(article),
          isFalse,
          reason: 'Artikel harus ditolak: ${article.title}',
        );
      }
    });

    test('menerima artikel teknologi dan berita yang bersih', () {
      const safeArticle1 = ArticleModel(
        title:
            'NVIDIA Resmi Luncurkan GeForce RTX 5090 dengan Arsitektur Blackwell',
        description:
            'Chip grafis terbaru menawarkan efisiensi daya dan performa AI tinggi.',
        url: 'https://teknologi.com/rtx-5090',
      );
      const safeArticle2 = ArticleModel(
        title: 'Peneliti Kembangkan Baterai Mobil Listrik Tahan 1000 Km',
        description:
            'Inovasi sains material baru memungkinkan pengisian 10 menit.',
        url: 'https://sains.com/baterai-baru',
      );

      expect(NewsApiService.isArticleSafe(safeArticle1), isTrue);
      expect(NewsApiService.isArticleSafe(safeArticle2), isTrue);
    });

    test(
        'filterAndDeduplicate menyaring artikel terlarang dan menghapus duplikasi',
        () {
      final rawArticles = [
        const ArticleModel(
          title: 'NVIDIA RTX 5090 Resmi Hadir',
          url: 'https://news.com/rtx5090',
        ),
        const ArticleModel(
          title: 'Daftar Slot Gacor Maxwin Hari Ini', // Spam judi
          url: 'https://spam.com/slot',
        ),
        const ArticleModel(
          title: 'NVIDIA RTX 5090 Resmi Hadir', // Duplikasi judul & URL
          url: 'https://news.com/rtx5090',
        ),
        const ArticleModel(
          title: 'SpaceX Luncurkan Roket Starship Terbaru',
          url: 'https://news.com/spacex',
        ),
        const ArticleModel(
          title: 'Bonus Deposit Casino Terbaik', // Spam casino
          url: 'https://spam.com/casino',
        ),
      ];

      final filtered = NewsApiService.filterAndDeduplicate(rawArticles);

      // Hanya 2 artikel bersih dan unik yang lolos
      expect(filtered.length, 2);
      expect(filtered[0].title, 'NVIDIA RTX 5090 Resmi Hadir');
      expect(filtered[1].title, 'SpaceX Luncurkan Roket Starship Terbaru');
    });

    test(
        'menolak secara tepat artikel spam Mahjong Wins 2 dari screenshot pengguna',
        () {
      const mahjongArticle = ArticleModel(
        title:
            'Mahjong Wins 2 pada Tablet dengan Penjepit Gamepad, Mengapa Aksesori Tidak Otomatis Mengendalikan Browser',
        description:
            'Mahjong Wins 2 pada tablet dengan penjepit gamepad: pahami mengapa aksesori yang terpasang tidak otomatis mengendalikan browser dan cara memeriksa kompatibilitasnya.',
        url:
            'https://habangkalan.katingankab.go.id/berita/mahjong-wins-2-tablet',
        sourceName: 'Habangkalan Penyang Karuhei Tatau',
      );

      expect(
        NewsApiService.isArticleSafe(mahjongArticle),
        isFalse,
        reason: 'Artikel Mahjong Wins 2 wajib ditolak oleh filter keamanan',
      );
    });

    test(
        'feed dengan artikel Mahjong Wins 2 mempromosikan berita bersih berikutnya sebagai featured news',
        () {
      final feed = [
        const ArticleModel(
          title:
              'Mahjong Wins 2 pada Tablet dengan Penjepit Gamepad, Mengapa Aksesori Tidak Otomatis Mengendalikan Browser',
          description: 'Mahjong Wins 2 pada tablet dengan penjepit gamepad...',
          url: 'https://spam.com/mahjong-wins-2',
          sourceName: 'Habangkalan Penyang Karuhei Tatau',
        ),
        const ArticleModel(
          title:
              'Steam Pulihkan Layanan Setelah Gangguan Pemeliharaan Jaringan',
          description:
              'Layanan Steam kembali normal setelah perbaikan jaringan.',
          url: 'https://bsinews.id/steam-pulih',
          sourceName: 'bsinews.id',
        ),
        const ArticleModel(
          title:
              'MIND Meluncurkan Integrasi DLP untuk Microsoft Copilot dan Microsoft 365',
          description: 'Keamanan data generasi baru untuk lingkungan kerja AI.',
          url: 'https://unite.ai/mind-dlp',
          sourceName: 'Unite.AI',
        ),
      ];

      final cleanFeed = NewsApiService.filterAndDeduplicate(feed);

      expect(cleanFeed.length, 2);
      // Artikel pertama (featured) harus Steam Pulihkan Layanan, bukan Mahjong Wins 2
      expect(cleanFeed[0].title,
          'Steam Pulihkan Layanan Setelah Gangguan Pemeliharaan Jaringan');
      expect(cleanFeed[1].title,
          'MIND Meluncurkan Integrasi DLP untuk Microsoft Copilot dan Microsoft 365');
    });
  });
}
