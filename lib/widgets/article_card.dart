import 'package:flutter/material.dart';
import '../models/article_model.dart';
import '../utils/app_colors.dart';
import '../utils/date_formatter.dart';
import 'news_image.dart';

/// Card artikel reusable untuk daftar berita.
/// Menampilkan thumbnail, judul, deskripsi singkat, sumber, dan waktu.
class ArticleCard extends StatelessWidget {
  final ArticleModel article;
  final VoidCallback onTap;
  // Jika featured = true, tampilan lebih menonjol (artikel pertama di feed)
  final bool featured;

  const ArticleCard({
    super.key,
    required this.article,
    required this.onTap,
    this.featured = false,
  });

  @override
  Widget build(BuildContext context) {
    if (featured) {
      return _FeaturedCard(article: article, onTap: onTap);
    }
    return _ListCard(article: article, onTap: onTap);
  }
}

/// Kartu artikel unggulan: gambar penuh di atas, teks di bawah.
/// Hanya dipakai untuk artikel pertama di setiap kategori.
class _FeaturedCard extends StatelessWidget {
  final ArticleModel article;
  final VoidCallback onTap;

  const _FeaturedCard({required this.article, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar penuh di atas — dibatasi 220px agar tidak memenuhi layar desktop
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 220),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: NewsImage(
                    imageUrl: article.urlToImage,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
            // Teks di bawah gambar
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label "TERKINI" sebagai penanda featured
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accentLime,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: const Text(
                      'TERKINI',
                      style: TextStyle(
                        color: AppColors.textOnAccent,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (article.description != null &&
                      article.description!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      article.description!,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        height: 1.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 10),
                  _SourceTimestamp(article: article),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Kartu artikel daftar: thumbnail kiri, teks kanan.
class _ListCard extends StatelessWidget {
  final ArticleModel article;
  final VoidCallback onTap;

  const _ListCard({required this.article, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail kiri
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: NewsImage(
                imageUrl: article.urlToImage,
                width: 112,
                height: 76,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            // Teks kanan
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  _SourceTimestamp(article: article),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Baris sumber dan waktu publikasi, dipakai di kedua jenis card.
class _SourceTimestamp extends StatelessWidget {
  final ArticleModel article;

  const _SourceTimestamp({required this.article});

  @override
  Widget build(BuildContext context) {
    final dateText = article.publishedAt != null
        ? DateFormatter.formatShort(article.publishedAt!)
        : null;

    return Row(
      children: [
        Flexible(
          child: Text(
            article.displaySource,
            style: const TextStyle(
              color: AppColors.accentOrange,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (dateText != null) ...[
          const SizedBox(width: 6),
          const Text(
            '\u00B7',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
          ),
          const SizedBox(width: 6),
          Text(
            dateText,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ],
    );
  }
}
