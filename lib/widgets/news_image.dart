import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/app_colors.dart';

/// Widget gambar berita dengan penanganan loading, error, dan placeholder.
/// Mengatasi masalah CORS pada Flutter Web dengan Image.network dan WebHtmlElementStrategy.fallback,
/// serta menggunakan CachedNetworkImage pada platform non-web (Android/iOS).
class NewsImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;

  const NewsImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final url = imageUrl?.trim();
    if (url == null || url.isEmpty) {
      return _buildPlaceholder();
    }

    // Jika di platform Web (Chrome), gunakan Image.network dengan WebHtmlElementStrategy.fallback
    // untuk mencegah gambar gagal termuat akibat blokade CORS browser.
    if (kIsWeb) {
      return Image.network(
        url,
        width: width,
        height: height,
        fit: fit,
        webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildLoading();
        },
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    }

    // Jika bukan Web (Android/iOS), gunakan CachedNetworkImage untuk efisiensi cache lokal.
    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => _buildLoading(),
      errorWidget: (context, url, error) => _buildPlaceholder(),
    );
  }

  Widget _buildLoading() {
    return Container(
      width: width,
      height: height,
      color: AppColors.bgElevated,
      child: const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentLime),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: AppColors.bgElevated,
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: AppColors.textSecondary,
          size: 28,
        ),
      ),
    );
  }
}
