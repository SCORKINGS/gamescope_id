import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

/// Widget empty state untuk hasil pencarian kosong atau kategori tanpa berita.
class EmptyState extends StatelessWidget {
  final String message;
  final String? suggestion;

  const EmptyState({
    super.key,
    this.message = 'Berita belum ditemukan.',
    this.suggestion,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.search_off_rounded,
              size: 48,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
            if (suggestion != null) ...[
              const SizedBox(height: 8),
              Text(
                suggestion!,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
