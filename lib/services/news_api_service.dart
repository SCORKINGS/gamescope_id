import 'package:dio/dio.dart';
import '../config/env.dart';
import '../models/article_model.dart';
import '../models/news_response_model.dart';
import 'api_exception.dart';

class NewsApiService {
  late final Dio _dio;

  NewsApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: Env.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    // Log interceptor hanya untuk mode debug, API key disamarkan
    assert(() {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: false,
          responseBody: false,
          requestHeader: false,
          responseHeader: false,
          logPrint: (obj) {
            // Samarkan API key dari URL sebelum log
            final log = obj.toString().replaceAll(Env.apiKey, Env.samarkan());
            // ignore: avoid_print
            print('[NewsApiService] $log');
          },
        ),
      );
      return true;
    }());
  }

  /// Daftar kata kunci komprehensif promosi judi online, casino, slot, taruhan, dll.
  static const List<String> blockedKeywords = [
    // Istilah umum judi & casino
    'casino',
    'gambling',
    'judi online',
    'judi',
    'perjudian',
    'taruhan',
    'togel',
    'sportsbook',
    // Slot & Gacor
    'slot gacor',
    'slot online',
    'slot88',
    'slot777',
    'slot 88',
    'slot 777',
    'situs slot',
    'daftar slot',
    'link slot',
    'bocoran slot',
    'pola slot',
    'game slot',
    'mesin slot',
    'rtp slot',
    'rtp live',
    'maxwin',
    'jackpot gacor',
    'scatter hitam',
    'free spin',
    'freespin',
    // Judul game slot populer (yang sering dipakai spammer terselubung)
    'mahjong wins',
    'mahjong ways',
    'mahjong slot',
    'mahjong',
    'gates of olympus',
    'kakek zeus',
    'zeus slot',
    'starlight princess',
    'sweet bonanza',
    'spaceman slot',
    'spaceman',
    'pragmatic play',
    'pragmatic',
    'pg soft',
    'habanero',
    // Istilah transaksi & promosi judi
    'bonus deposit',
    'bonus depo',
    'min depo',
    'min wd',
    'depo 10k',
    'depo 25k',
    'depo pulsa',
    // Togel & Toto
    'wostoto',
    'toto macau',
    'toto sgp',
    'toto hk',
    'bandar togel',
    // Agen & Situs
    'link alternatif',
    'situs gacor',
    'situs judi',
    'agen slot',
    'agen judi',
    'bandar judi',
    'bandar bola',
    // Judi kartu / meja
    'poker online',
    'roulette online',
    'baccarat online',
    'dominoqq',
    'bandarq',
  ];

  /// Regex untuk kata sensitif dengan batas kata (word boundary), misalnya 'rtp', 'mahjong', 'wostoto'
  static final RegExp blockedWordBoundaryRegex = RegExp(
    r'\b(rtp|casino|gambling|judi|togel|sportsbook|maxwin|gacor|wostoto|zeus|mahjong)\b',
    caseSensitive: false,
  );

  /// Cek apakah suatu artikel aman dan relevan (bebas dari promosi judi/casino/slot)
  static bool isArticleSafe(ArticleModel article) {
    final title = article.title.toLowerCase();
    final description = (article.description ?? '').toLowerCase();
    final content = (article.content ?? '').toLowerCase();
    final url = article.url.toLowerCase();
    final source = (article.sourceName ?? '').toLowerCase();

    final combined = '$title $description $content $url $source';

    // 1. Periksa daftar kata kunci terlarang
    for (final kw in blockedKeywords) {
      if (combined.contains(kw)) {
        return false;
      }
    }

    // 2. Periksa regex word boundary (misalnya 'rtp', 'mahjong', 'wostoto')
    if (blockedWordBoundaryRegex.hasMatch(combined)) {
      return false;
    }

    return true;
  }

  /// Filter artikel terlarang dan eliminasi duplikasi berdasarkan URL atau Judul
  static List<ArticleModel> filterAndDeduplicate(List<ArticleModel> articles) {
    final seenUrls = <String>{};
    final seenTitles = <String>{};
    final safeArticles = <ArticleModel>[];

    for (final article in articles) {
      // Tolak artikel yang mengandung konten terlarang
      if (!isArticleSafe(article)) {
        continue;
      }

      final cleanUrl = article.url.trim().toLowerCase();
      final cleanTitle = article.title.trim().toLowerCase();

      // Hindari duplikasi artikel
      if (cleanUrl.isNotEmpty && seenUrls.contains(cleanUrl)) {
        continue;
      }
      if (cleanTitle.isNotEmpty && seenTitles.contains(cleanTitle)) {
        continue;
      }

      if (cleanUrl.isNotEmpty) seenUrls.add(cleanUrl);
      if (cleanTitle.isNotEmpty) seenTitles.add(cleanTitle);

      safeArticles.add(article);
    }

    return safeArticles;
  }

  /// Ambil berita utama berdasarkan kategori menggunakan endpoint /top-headlines.
  /// Kategori yang didukung: technology, science, entertainment, sports, business.
  Future<List<ArticleModel>> getTopHeadlines({required String category}) async {
    if (Env.isApiKeyEmpty) {
      throw const ApiException(ApiMessages.apiKeyEmpty);
    }

    final trimmed = category.trim().toLowerCase();
    if (trimmed.isEmpty) {
      throw const ApiException(ApiMessages.emptyKeyword);
    }

    try {
      final response = await _dio.get(
        '/top-headlines',
        queryParameters: {
          'category': trimmed,
          'lang': 'id',
          'max': 10,
          'apikey': Env.apiKey,
        },
      );

      if (response.data is! Map<String, dynamic>) {
        throw const ApiException(ApiMessages.parseError);
      }

      final newsResponse = NewsResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
      // Terapkan filter konten dan deduplikasi sebelum artikel dikembalikan
      return filterAndDeduplicate(newsResponse.articles);
    } on ApiException {
      rethrow;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw const ApiException(ApiMessages.parseError);
    }
  }

  /// Cari berita berdasarkan keyword.
  /// Validasi keyword sebelum request; lempar ApiException jika gagal.
  Future<List<ArticleModel>> searchNews(String keyword) async {
    // Validasi API key
    if (Env.isApiKeyEmpty) {
      throw const ApiException(ApiMessages.apiKeyEmpty);
    }

    // Validasi keyword
    final trimmed = keyword.trim();
    if (trimmed.isEmpty) {
      throw const ApiException(ApiMessages.emptyKeyword);
    }
    if (trimmed.length > 200) {
      throw const ApiException(ApiMessages.keywordTooLong);
    }

    // Gunakan operator NOT pada query jika memungkinkan untuk memfilter sejak di tingkat API
    String query = trimmed;
    if (!trimmed.toLowerCase().contains('not ') && trimmed.length <= 120) {
      query =
          '$trimmed NOT casino NOT judi NOT "slot gacor" NOT togel NOT mahjong';
    }

    try {
      final response = await _dio.get(
        '/search',
        queryParameters: {
          'q': query,
          'lang': 'id',
          'max': 10,
          'sortby': 'publishedAt',
          'apikey': Env.apiKey,
        },
      );

      if (response.data is! Map<String, dynamic>) {
        throw const ApiException(ApiMessages.parseError);
      }

      final newsResponse = NewsResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
      // Terapkan filter konten dan deduplikasi sebelum artikel dikembalikan
      return filterAndDeduplicate(newsResponse.articles);
    } on ApiException {
      rethrow;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw const ApiException(ApiMessages.parseError);
    }
  }

  ApiException _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException(ApiMessages.timeout);

      case DioExceptionType.connectionError:
        return const ApiException(ApiMessages.noInternet);

      case DioExceptionType.badCertificate:
        return const ApiException(ApiMessages.badCertificate);

      case DioExceptionType.cancel:
        return const ApiException(ApiMessages.cancelled);

      case DioExceptionType.badResponse:
        return _handleHttpStatus(e.response?.statusCode);

      case DioExceptionType.transformTimeout:
        return const ApiException(ApiMessages.timeout);

      case DioExceptionType.unknown:
        // Periksa apakah ini masalah koneksi atau parse
        final msg = e.message ?? '';
        if (msg.contains('SocketException') ||
            msg.contains('NetworkException') ||
            msg.contains('connection')) {
          return const ApiException(ApiMessages.noInternet);
        }
        return const ApiException(ApiMessages.unknown);
    }
  }

  ApiException _handleHttpStatus(int? statusCode) {
    switch (statusCode) {
      case 400:
        return const ApiException(ApiMessages.badRequest, statusCode: 400);
      case 401:
        return const ApiException(ApiMessages.apiKeyInvalid, statusCode: 401);
      case 403:
        return const ApiException(ApiMessages.accessDenied, statusCode: 403);
      case 404:
        return const ApiException(ApiMessages.notFound, statusCode: 404);
      case 429:
        return const ApiException(ApiMessages.tooManyRequests, statusCode: 429);
      default:
        if (statusCode != null && statusCode >= 500) {
          return ApiException(ApiMessages.serverError, statusCode: statusCode);
        }
        return ApiException(
          '${ApiMessages.unknown} (HTTP $statusCode)',
          statusCode: statusCode,
        );
    }
  }
}
