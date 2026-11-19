import 'article_model.dart';

class NewsResponseModel {
  final int totalArticles;
  final List<ArticleModel> articles;

  const NewsResponseModel({
    required this.totalArticles,
    required this.articles,
  });

  factory NewsResponseModel.fromJson(Map<String, dynamic> json) {
    final total = json['totalArticles'];
    final totalInt = (total is int) ? total : 0;

    final rawArticles = json['articles'];
    List<ArticleModel> parsed = [];

    if (rawArticles is List) {
      for (final item in rawArticles) {
        if (item is Map<String, dynamic>) {
          try {
            parsed.add(ArticleModel.fromJson(item));
          } catch (_) {
            // Lewati artikel yang tidak bisa di-parse
          }
        }
      }
    }

    return NewsResponseModel(
      totalArticles: totalInt,
      articles: parsed,
    );
  }

  bool get isEmpty => articles.isEmpty;
}
