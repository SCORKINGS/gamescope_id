# Simpan screenshot error di folder ini

## Instruksi Pengambilan Screenshot Error

### Skenario 1: API Key Tidak Valid (HTTP 401)

1. Buka `config/env.json`
2. Ganti API key sementara dengan: `"GNEWS_API_KEY": "API_KEY_PALSU_12345"`
3. Restart aplikasi (bukan hot reload):
   ```
   flutter run -d chrome --dart-define-from-file=config/env.json
   ```
4. Aplikasi otomatis muat berita di HomeView
5. Pesan error "API Key tidak valid atau belum terdaftar." akan muncul
6. Ambil screenshot dan simpan sebagai `error-invalid-api-key.png`
7. **Kembalikan API key asli** setelah selesai screenshot

### Skenario 2: Tidak Ada Koneksi Internet

1. Jalankan aplikasi dengan API key yang benar:
   ```
   flutter run -d chrome --dart-define-from-file=config/env.json
   ```
2. Buka Chrome DevTools (F12)
3. Pilih tab **Network**
4. Ubah dropdown throttling dari "No throttling" ke **Offline**
5. Lakukan refresh (tarik ke bawah) atau pilih kategori baru
6. Pesan "Tidak ada koneksi internet. Periksa jaringan Anda." akan muncul
7. Ambil screenshot dan simpan sebagai `error-no-internet.png`
8. Kembalikan koneksi ke "No throttling" setelah selesai

## File yang Harus Ada di Folder Ini

- `error-invalid-api-key.png` - Screenshot dari Skenario 1
- `error-no-internet.png` - Screenshot dari Skenario 2
