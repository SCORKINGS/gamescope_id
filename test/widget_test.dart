import 'package:flutter_test/flutter_test.dart';
import 'package:nusa_news/models/article_model.dart';
import 'package:nusa_news/models/news_response_model.dart';
import 'package:nusa_news/services/api_exception.dart';

void main() {
  group('ArticleModel.fromJson', () {
    test('parse artikel lengkap dengan benar', () {
      final json = {
        'title': 'GTA 6 Rilis Tahun 2026',
        'description': 'Rockstar Games mengumumkan tanggal rilis GTA 6.',
        'content': 'Konten berita lengkap...',
        'url': 'https://contoh.com/gta6',
        'image': 'https://contoh.com/gta6.jpg',
        'publishedAt': '2026-11-19T10:00:00Z',
        'source': {'name': 'GameNews ID'},
      };

      final article = ArticleModel.fromJson(json);

      expect(article.title, 'GTA 6 Rilis Tahun 2026');
      expect(article.sourceName, 'GameNews ID');
      expect(article.hasImage, true);
      expect(article.publishedAt, isNotNull);
    });

    test('handle field null dengan aman', () {
      final json = {
        'title': null,
        'url': null,
        'image': null,
        'source': null,
      };

      final article = ArticleModel.fromJson(json);

      expect(article.title, 'Judul tidak tersedia');
      expect(article.hasImage, false);
      expect(article.sourceName, null);
      expect(article.displaySource, 'Sumber tidak diketahui');
    });

    test('handle tanggal tidak valid tanpa crash', () {
      final json = {
        'title': 'Test',
        'url': 'https://test.com',
        'publishedAt': 'bukan-tanggal',
      };

      final article = ArticleModel.fromJson(json);
      expect(article.publishedAt, isNull);
    });
  });

  group('NewsResponseModel.fromJson', () {
    test('parse daftar artikel dengan benar', () {
      final json = {
        'totalArticles': 2,
        'articles': [
          {
            'title': 'Artikel 1',
            'url': 'https://test1.com',
          },
          {
            'title': 'Artikel 2',
            'url': 'https://test2.com',
          },
        ],
      };

      final response = NewsResponseModel.fromJson(json);
      expect(response.totalArticles, 2);
      expect(response.articles.length, 2);
      expect(response.isEmpty, false);
    });

    test('handle daftar kosong', () {
      final json = {'totalArticles': 0, 'articles': []};
      final response = NewsResponseModel.fromJson(json);
      expect(response.isEmpty, true);
    });
  });

  group('ApiException', () {
    test('pesan error terpusat tersedia', () {
      expect(ApiMessages.apiKeyEmpty, isNotEmpty);
      expect(ApiMessages.apiKeyInvalid, isNotEmpty);
      expect(ApiMessages.noInternet, isNotEmpty);
      expect(ApiMessages.timeout, isNotEmpty);
      expect(ApiMessages.accessDenied, isNotEmpty);
      expect(ApiMessages.badRequest, isNotEmpty);
      expect(ApiMessages.serverError, isNotEmpty);
      expect(ApiMessages.parseError, isNotEmpty);
    });

    test('ApiException menyimpan statusCode', () {
      const e = ApiException('Test error', statusCode: 401);
      expect(e.message, 'Test error');
      expect(e.statusCode, 401);
    });
  });
}
