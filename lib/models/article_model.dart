class ArticleModel {
  final String title;
  final String? description;
  final String? content;
  final String url;
  final String? urlToImage;
  final DateTime? publishedAt;
  final String? sourceName;

  const ArticleModel({
    required this.title,
    this.description,
    this.content,
    required this.url,
    this.urlToImage,
    this.publishedAt,
    this.sourceName,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    // Parse publishedAt dengan fallback null-safe
    DateTime? published;
    final rawDate = json['publishedAt'];
    if (rawDate is String && rawDate.isNotEmpty) {
      published = DateTime.tryParse(rawDate);
    }

    // Ambil nama sumber dari nested object 'source'
    String? source;
    final sourceField = json['source'];
    if (sourceField is Map<String, dynamic>) {
      final name = sourceField['name'];
      if (name is String && name.isNotEmpty) {
        source = name;
      }
    }

    // Pastikan title tidak null
    final title = json['title'];
    final titleStr =
        (title is String && title.isNotEmpty) ? title : 'Judul tidak tersedia';

    final url = json['url'];
    final urlStr = (url is String && url.isNotEmpty) ? url : '';

    // urlToImage dari field 'image' di GNews
    final image = json['image'];
    final imageStr = (image is String && image.isNotEmpty) ? image : null;

    final desc = json['description'];
    final descStr = (desc is String && desc.isNotEmpty) ? desc : null;

    final content = json['content'];
    final contentStr =
        (content is String && content.isNotEmpty) ? content : null;

    return ArticleModel(
      title: titleStr,
      description: descStr,
      content: contentStr,
      url: urlStr,
      urlToImage: imageStr,
      publishedAt: published,
      sourceName: source,
    );
  }

  // Cek apakah artikel memiliki gambar yang bisa ditampilkan
  bool get hasImage => urlToImage != null && urlToImage!.isNotEmpty;

  // Teks tampilan untuk sumber
  String get displaySource => sourceName ?? 'Sumber tidak diketahui';
}
