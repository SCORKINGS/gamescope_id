// Daftar pesan error terpusat untuk seluruh aplikasi.
// Semua pesan error API dikelola di satu tempat.
class ApiMessages {
  ApiMessages._();

  static const String apiKeyEmpty =
      'Konfigurasi API belum diisi. Periksa config/env.json.';

  static const String apiKeyInvalid =
      'API Key tidak valid atau belum terdaftar.';

  static const String badRequest = 'Permintaan pencarian tidak valid.';

  static const String accessDenied =
      'Akses ditolak. Periksa kuota atau verifikasi akun GNews.';

  static const String notFound = 'Endpoint berita tidak ditemukan.';

  static const String tooManyRequests =
      'Request terlalu cepat. Coba beberapa saat lagi.';

  static const String noInternet =
      'Tidak ada koneksi internet. Periksa jaringan Anda.';

  static const String timeout =
      'Koneksi terlalu lambat. Server tidak merespons tepat waktu.';

  static const String serverError =
      'Server berita sedang bermasalah. Silakan coba lagi.';

  static const String parseError =
      'Format data berita dari server tidak dikenali.';

  static const String cancelled = 'Request dibatalkan.';

  static const String badCertificate =
      'Sertifikat keamanan server tidak valid.';

  static const String unknown =
      'Terjadi kesalahan tidak dikenal. Silakan coba lagi.';

  static const String emptyKeyword = 'Kata kunci pencarian tidak boleh kosong.';

  static const String keywordTooLong =
      'Kata kunci terlalu panjang (maksimal 200 karakter).';
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message';
}
