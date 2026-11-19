// Konfigurasi environment. Nilai diisi melalui --dart-define-from-file=config/env.json
// JANGAN tulis API key langsung di sini.
class Env {
  Env._();

  static const String baseUrl = String.fromEnvironment(
    'GNEWS_BASE_URL',
    defaultValue: 'https://gnews.io/api/v4',
  );

  static const String apiKey = String.fromEnvironment(
    'GNEWS_API_KEY',
    defaultValue: '',
  );

  static bool get isApiKeyEmpty => apiKey.isEmpty;

  // Samarkan API key untuk log debug: tampilkan 4 karakter pertama saja.
  static String samarkan() {
    if (apiKey.isEmpty) return '[kosong]';
    if (apiKey.length <= 4) return '****';
    return '${apiKey.substring(0, 4)}****';
  }
}
