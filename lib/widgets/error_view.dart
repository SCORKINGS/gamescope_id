import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../services/api_exception.dart';

/// Widget error state dengan ikon kontekstual, pesan, dan tombol retry.
class ErrorView extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;

  const ErrorView({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final message = _extractMessage();
    final icon = _selectIcon(message);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Coba Lagi'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.divider),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _extractMessage() {
    if (error is ApiException) {
      return (error as ApiException).message;
    }
    return error.toString().replaceFirst('Exception: ', '');
  }

  // Pilih ikon berdasarkan konten pesan error
  IconData _selectIcon(String message) {
    if (message.contains('internet') || message.contains('koneksi')) {
      return Icons.wifi_off_rounded;
    }
    if (message.contains('lambat') || message.contains('timeout')) {
      return Icons.timer_off_outlined;
    }
    if (message.contains('API Key') ||
        message.contains('konfigurasi') ||
        message.contains('Konfigurasi')) {
      return Icons.key_off_outlined;
    }
    if (message.contains('kuota') || message.contains('Akses')) {
      return Icons.block_outlined;
    }
    if (message.contains('cepat') || message.contains('429')) {
      return Icons.speed_outlined;
    }
    if (message.contains('server') || message.contains('Server')) {
      return Icons.dns_outlined;
    }
    return Icons.error_outline_rounded;
  }
}
