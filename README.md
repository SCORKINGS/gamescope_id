# GameScope ID

Gaming. Technology. What's Next.

GameScope ID adalah aplikasi berita gaming dan teknologi berbasis Flutter yang menggunakan GNews API untuk menampilkan berita terbaru sesuai kategori dan kata kunci pencarian.

Proyek ini dibuat untuk memenuhi tugas Praktikum Pemrograman Mobile Topik 11.

## Fitur Aplikasi

- Menampilkan berita berdasarkan kategori gaming dan teknologi.
- Kategori berita seperti Gaming, GTA 6, NVIDIA & GPU, Honkai: Star Rail, HoYoverse, PC & Console, dan Mobile Gaming.
- Featured article untuk menampilkan berita utama.
- Menampilkan hingga 10 artikel dari GNews API.
- Pencarian berita melalui ikon pencarian pada AppBar.
- Halaman hasil pencarian dengan FutureBuilder.
- Halaman detail berita.
- Tombol untuk membuka berita dari sumber aslinya.
- Pull-to-refresh untuk memperbarui berita.
- Cache Future berdasarkan kategori agar tidak melakukan request berulang.
- Empat kondisi tampilan: loading, error, empty, dan data.
- Penanganan error API dengan pesan yang sesuai dan fitur coba lagi.

## Teknologi yang Digunakan

| Teknologi | Kegunaan |
|---|---|
| Flutter | Framework aplikasi |
| Dart | Bahasa pemrograman |
| GNews API | Sumber data berita |
| Dio | HTTP client |
| GetX | Navigasi aplikasi |
| Cached Network Image | Menampilkan gambar berita |
| Intl | Format tanggal |
| URL Launcher | Membuka berita asli |

## Struktur Folder

```text
gamescope_id/
├── android/
├── config/
│   ├── env.example.json
│   └── env.json
├── lib/
│   ├── main.dart
│   ├── config/
│   ├── models/
│   ├── services/
│   ├── views/
│   ├── widgets/
│   ├── routes/
│   └── utils/
├── test/
├── web/
├── .gitignore
├── DESIGN.md
├── pubspec.yaml
└── README.md
```

## Persyaratan

Sebelum menjalankan aplikasi, pastikan sudah tersedia:

- Flutter SDK.
- Dart SDK.
- Google Chrome untuk menjalankan Flutter Web.
- API Key dari GNews.

Website GNews: https://gnews.io

## Instalasi

Clone repository:

```bash
git clone https://github.com/SCORKINGS/gamescope_id.git
```

Masuk ke folder proyek:

```bash
cd gamescope_id
```

Install dependencies:

```bash
flutter pub get
```

## Konfigurasi GNews API

1. Kunjungi https://gnews.io.
2. Buat akun GNews.
3. Verifikasi email jika diminta.
4. Salin API Key dari dashboard.

Salin file contoh konfigurasi:

```bash
cp config/env.example.json config/env.json
```

Pada Windows PowerShell, gunakan:

```powershell
Copy-Item config/env.example.json config/env.json
```

Isi file `config/env.json` dengan API Key milik sendiri:

```json
{
  "GNEWS_BASE_URL": "https://gnews.io/api/v4",
  "GNEWS_API_KEY": "API_KEY_ANDA"
}
```

Penting: Jangan mengunggah `config/env.json` yang berisi API Key asli ke GitHub. File tersebut harus tetap diabaikan oleh `.gitignore`.

## Menjalankan Aplikasi

Untuk Flutter Web:

```bash
flutter run -d chrome --dart-define-from-file=config/env.json
```

Untuk Android:

```bash
flutter run -d android --dart-define-from-file=config/env.json
```

## Pengujian Aplikasi

Beberapa pengujian yang dapat dilakukan:

1. Pengujian Kategori
- Buka aplikasi.
- Pilih beberapa kategori berita.
- Pastikan artikel berubah sesuai kategori.
- Kembali ke kategori sebelumnya untuk memeriksa penggunaan cache.

2. Pengujian Pencarian
- Tekan ikon pencarian pada AppBar.
- Masukkan kata kunci, misalnya `GTA 6` atau `NVIDIA`.
- Tekan tombol Cari.
- Pastikan hasil pencarian ditampilkan.

3. Pengujian Detail Berita
- Pilih salah satu artikel.
- Periksa judul, sumber, tanggal, gambar, dan deskripsi.
- Tekan tombol Baca Berita Asli.

4. Pengujian Pull-to-Refresh
- Tarik daftar berita ke bawah.
- Pastikan aplikasi melakukan permintaan ulang untuk memperbarui berita.

5. Pengujian Kondisi FutureBuilder
- Loading: ketika aplikasi sedang mengambil data.
- Error: ketika terjadi kegagalan permintaan.
- Empty: ketika tidak ada artikel ditemukan.
- Data: ketika artikel berhasil dimuat.

6. Pengujian Error Handling
- Gunakan API Key yang tidak valid untuk menguji kesalahan autentikasi.
- Matikan koneksi internet untuk menguji penanganan koneksi.
- Pastikan pesan error ditampilkan dan tombol Coba Lagi dapat digunakan.

## Catatan Penggunaan GNews

GNews menyediakan batas penggunaan API berdasarkan paket yang digunakan. Pada Free Plan terdapat batas request harian dan keterlambatan publikasi berita.

Jumlah dan ketersediaan artikel dapat berubah sesuai hasil pencarian dari GNews.

## Keamanan API Key

API Key yang digunakan dalam aplikasi Flutter Web dapat terlihat melalui hasil build JavaScript maupun permintaan jaringan di browser.

Oleh karena itu, konfigurasi ini ditujukan untuk kebutuhan praktikum dan pengembangan lokal. Untuk penggunaan produksi, API Key sebaiknya disimpan di server melalui backend atau proxy API.

## Pembuat

GameScope ID

Praktikum Pemrograman Mobile – Topik 11