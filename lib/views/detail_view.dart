import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/article_model.dart';
import '../utils/app_colors.dart';
import '../utils/date_formatter.dart';
import '../widgets/news_image.dart';

class DetailView extends StatelessWidget {
  const DetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final article = Get.arguments as ArticleModel?;

    if (article == null) {
      return Scaffold(
        backgroundColor: AppColors.bgPrimary,
        appBar: AppBar(
          backgroundColor: AppColors.bgSurface,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () => Get.back(),
          ),
          title: const Text(
            'Detail Berita',
            style: TextStyle(color: AppColors.textPrimary, fontSize: 16),
          ),
        ),
        body: const Center(
          child: Text(
            'Artikel tidak ditemukan.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(article),
          SliverToBoxAdapter(
            child: _buildContent(context, article),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(ArticleModel article) {
    return SliverAppBar(
      expandedHeight: article.hasImage ? 220 : 0,
      pinned: true,
      backgroundColor: AppColors.bgSurface,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      flexibleSpace: article.hasImage
          ? FlexibleSpaceBar(
              background: NewsImage(
                imageUrl: article.urlToImage,
                width: double.infinity,
                height: 220,
              ),
            )
          : null,
    );
  }

  Widget _buildContent(BuildContext context, ArticleModel article) {
    final dateText = article.publishedAt != null
        ? DateFormatter.format(article.publishedAt!)
        : null;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sumber dan tanggal
          Row(
            children: [
              Flexible(
                child: Text(
                  article.displaySource,
                  style: const TextStyle(
                    color: AppColors.accentOrange,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (dateText != null) ...[
                const SizedBox(width: 8),
                const Text(
                  '\u00B7',
                  style:
                      TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
                const SizedBox(width: 8),
                Text(
                  dateText,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          // Judul
          Text(
            article.title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              height: 1.4,
            ),
          ),
          // Deskripsi
          if (article.description != null &&
              article.description!.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              article.description!,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ],
          // Konten (sering terpotong oleh GNews)
          if (article.content != null && article.content!.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(color: AppColors.divider),
            const SizedBox(height: 12),
            Text(
              article.content!,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                height: 1.7,
              ),
            ),
          ],
          const SizedBox(height: 24),
          // Catatan konten terpotong
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.bgElevated,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'Konten artikel mungkin tidak lengkap karena keterbatasan GNews Free Plan. Baca berita lengkap di sumber aslinya.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Tombol baca berita asli
          if (article.url.isNotEmpty)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _openUrl(article.url),
                icon: const Icon(Icons.open_in_new, size: 18),
                label: const Text(
                  'Baca Berita Asli',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentOrange,
                  foregroundColor: AppColors.textPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
