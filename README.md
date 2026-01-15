**Projek ini digunakan untuk memenuhi Tugas UAS Mata Kuliah Pemrograman Bergerak**

**NAMA: ANANDA MUHAMAD PRASETYO**

**NIM : 2205101082**

**KELAS : 7D**

# BMI Kalkulator 📊

Aplikasi kalkulator Body Mass Index (BMI) yang lengkap dengan fitur pelacakan kesehatan, dibuat menggunakan Flutter.

![Flutter](https://img.shields.io/badge/Flutter-3.10.7-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.10.7-0175C2?logo=dart)
![SQLite](https://img.shields.io/badge/SQLite-Database-003B57?logo=sqlite)

## 📖 Histori Pembuatan

Proyek ini dimulai sebagai aplikasi kalkulator BMI sederhana dan berkembang menjadi aplikasi pelacakan kesehatan yang komprehensif melalui beberapa tahap pengembangan:

### Tahap 1: Struktur Dasar
- Memisahkan kode monolitik `main.dart` menjadi struktur modular
- Membuat file terpisah untuk setiap halaman: `bmi_page.dart`, `goal_page.dart`, `tentang_page.dart`
- Organisasi kode yang lebih bersih dan mudah dimaintain

### Tahap 2: UI/UX Enhancement
- Menambahkan **gauge indikator visual** berbentuk setengah lingkaran
- Gauge menampilkan zona warna: Kurus (Biru), Normal (Hijau), Gemuk (Orange), Obesitas (Merah)
- Optimasi ukuran dan saturasi warna (opacity 0.7) untuk tampilan lebih menarik
- Gauge selalu tampil bahkan sebelum perhitungan BMI dilakukan

### Tahap 3: Responsive Design
- Implementasi desain adaptif untuk mobile dan desktop
- Breakpoint 800px: mode mobile (Column layout) vs desktop (Row layout)
- Pengalaman pengguna optimal di berbagai ukuran layar

### Tahap 4: Fitur Pelacakan
- **Tracking Goal**: Menambahkan fitur pencatatan target kesehatan dengan deadline
- **Date Picker**: Memilih tanggal target dengan mudah
- **Countdown Timer**: Menampilkan sisa waktu untuk mencapai goal
- **Indikator Urgensi**: Warna-warna yang menandakan prioritas goal

### Tahap 5: Riwayat Perhitungan
- Menambahkan fitur **history BMI** di bawah kalkulator
- Kartu detail untuk setiap perhitungan sebelumnya
- Opsi hapus individual atau hapus semua riwayat

### Tahap 6: Profesionalisasi
- Rebranding dari "tc_app" menjadi "BMI Kalkulator"
- Update semua konfigurasi platform (Android, iOS, macOS, Linux, Windows, Web)
- Halaman **Tentang** dengan informasi kontak: support@bmikalkulator.com
- Halaman **Kebijakan Privasi** dengan 5 bagian lengkap
- Halaman **Hak Cipta** dengan detail copyright

### Tahap 7: Database & Persistensi
- Implementasi **SQLite database** menggunakan package `sqflite`
- Penyimpanan persistent untuk BMI history dan goals
- Singleton pattern `DatabaseHelper` untuk manajemen database
- Data tetap tersimpan meskipun aplikasi ditutup

### Tahap 8: Privacy & Security
- Konfigurasi `.gitignore` untuk melindungi data pengguna
- Mencegah file database (*.db, *.sqlite) ter-commit ke version control
- Melindungi privasi pengguna dengan baik

## ✨ Fitur Utama

### 1. Kalkulator BMI
- Input tinggi badan (cm) dan berat badan (kg)
- Perhitungan BMI otomatis
- Kategori hasil: Kurus, Normal, Gemuk, Obesitas
- Gauge indikator visual setengah lingkaran
- Rekomendasi kesehatan berdasarkan hasil

### 2. Pelacakan Goal
- Tambah multiple goals dengan deadline
- Date picker untuk memilih tanggal target
- Countdown timer untuk setiap goal
- Indikator warna berdasarkan urgensi
- Hapus goal yang sudah tercapai

### 3. Riwayat BMI
- Simpan semua perhitungan BMI
- Tampilan kartu detail dengan tanggal dan waktu
- Lihat kategori dan hasil sebelumnya
- Hapus riwayat individual atau semua sekaligus

### 4. Halaman Informasi
- **Tentang**: Informasi aplikasi dan kontak support
- **Kebijakan Privasi**: Detail perlindungan data pengguna
- **Hak Cipta**: Informasi copyright dan lisensi

### 5. Desain Responsif
- Adaptif untuk mobile dan desktop
- Layout otomatis menyesuaikan ukuran layar
- Pengalaman pengguna optimal di semua perangkat

## 🚀 Cara Penggunaan

### Instalasi

1. **Clone repository**
   ```bash
   git clone https://github.com/Ananda1082/BMI_Kal.git
   cd BMI_Kal
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Jalankan aplikasi**
   ```bash
   flutter run
   ```

### Menghitung BMI

1. Buka aplikasi dan Anda akan melihat halaman kalkulator BMI
2. Masukkan **tinggi badan** Anda dalam cm (contoh: 170)
3. Masukkan **berat badan** Anda dalam kg (contoh: 65)
4. Tekan tombol **"Hitung BMI"**
5. Lihat hasil BMI, kategori, dan gauge indikator visual
6. Hasil otomatis tersimpan di riwayat

### Mengelola Goal

1. Tap ikon **☰** di kanan atas → pilih **"Goal"**
2. Tekan tombol **"+ Tambah Goal"** di pojok kanan bawah
3. Masukkan nama goal (contoh: "Turun 5 kg")
4. Tap ikon kalender untuk memilih tanggal deadline
5. Tekan **"Simpan"**
6. Goal akan muncul dengan countdown timer
7. Tap ikon **🗑️** untuk menghapus goal yang sudah tercapai

### Melihat Riwayat

1. Scroll ke bawah di halaman BMI untuk melihat **"Riwayat Perhitungan"**
2. Setiap kartu menampilkan:
   - Tanggal dan waktu perhitungan
   - Tinggi dan berat badan
   - Hasil BMI dan kategori
3. Tekan **"Hapus"** pada kartu untuk menghapus satu riwayat
4. Tekan **"Hapus Semua"** untuk menghapus seluruh riwayat

### Informasi & Kontak

1. Tap ikon **☰** → pilih **"Tentang"**
2. Lihat informasi aplikasi dan email kontak support
3. Akses **Kebijakan Privasi** untuk detail perlindungan data
4. Akses **Hak Cipta** untuk informasi lisensi

## 🛠️ Teknologi yang Digunakan

- **Framework**: Flutter SDK ^3.10.7
- **Language**: Dart ^3.10.7
- **Database**: SQLite via `sqflite ^2.3.0`
- **Path Management**: `path ^1.8.3`
- **UI Components**: Material Design
- **Custom Graphics**: CustomPainter untuk gauge
- **State Management**: StatefulWidget
- **Architecture Pattern**: Singleton (DatabaseHelper)

## 📱 Platform Support

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 📁 Struktur Proyek

```
lib/
├── main.dart                    # Entry point aplikasi
├── helpers/
│   └── database_helper.dart    # SQLite database singleton
└── pages/
    ├── bmi_page.dart           # Kalkulator BMI & riwayat
    ├── goal_page.dart          # Pelacakan goal
    └── tentang_page.dart       # About, privacy, copyright
```

## 🔒 Privasi & Keamanan

- Data tersimpan **lokal** di perangkat pengguna
- Tidak ada pengiriman data ke server eksternal
- File database dilindungi oleh `.gitignore`
- Kebijakan privasi lengkap tersedia di dalam aplikasi

## 📧 Kontak & Support

Email: tyobro0@gmail.com

## 📄 Lisensi

Copyright © 2026 BMI Kalkulator. All rights reserved.

---

**Dibuat dengan ❤️ menggunakan Flutter**
