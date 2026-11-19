import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  // Format tanggal publikasi ke bahasa Indonesia
  // Contoh output: "19 Nov 2026, 10:30"
  static String format(DateTime dateTime) {
    try {
      final DateFormat formatter = DateFormat('d MMM yyyy, HH:mm', 'id');
      return formatter.format(dateTime.toLocal());
    } catch (_) {
      return dateTime.toIso8601String();
    }
  }

  // Format ringkas untuk ArticleCard
  // Contoh output: "19 Nov 2026"
  static String formatShort(DateTime dateTime) {
    try {
      final DateFormat formatter = DateFormat('d MMM yyyy', 'id');
      return formatter.format(dateTime.toLocal());
    } catch (_) {
      return dateTime.toIso8601String();
    }
  }

  // Parse dari ISO 8601 string dengan fallback
  static DateTime? tryParse(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }
}
