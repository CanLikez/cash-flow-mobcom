# 💰 Cash Flow Harian - Mobile Computing Project

Aplikasi pencatatan keuangan harian (pemasukan & pengeluaran) berbasis **Flutter**, dirancang sebagai proyek mata kuliah **Mobile Computing (Mobcom)** Semester 5.

Repositori ini merupakan *starter template* (fondasi awal) yang telah terstruktur rapi agar memudahkan pembagian tugas dan kolaborasi antar anggota kelompok.

---

## 👥 Informasi Kelompok

| No | Nama Mahasiswa | NIM | Peran / Pembagian Tugas |
|---|---|---|---|
| 1 | [Nama Anggota 1] | [NIM 1] | Project Lead & State Management |
| 2 | [Nama Anggota 2] | [NIM 2] | UI/UX & Tampilan Dashboard |
| 3 | [Nama Anggota 3] | [NIM 3] | Form Transaksi & Validasi Input |
| 4 | [Nama Anggota 4] | [NIM 4] | Database Lokal (SQLite / Hive) |
| 5 | [Nama Anggota 5] | [NIM 5] | Dokumentasi & Pengujian (Testing) |

*(Silakan sesuaikan nama, NIM, dan pembagian peran di atas dengan anggota kelompok Anda)*

---

## 📱 Fitur Aplikasi

### 1. Fondasi yang Sudah Disediakan (Starter Code)
- [x] **Inisialisasi Proyek Flutter 3.x** dengan Material 3 Design.
- [x] **Dashboard Ringkasan Saldo**:
  - Menampilkan sisa saldo total.
  - Ringkasan akumulasi pemasukan dan pengeluaran.
- [x] **Riwayat Transaksi**:
  - Tampilan daftar transaksi dengan penanda warna (hijau = pemasukan, merah = pengeluaran).
  - Format mata uang Rupiah otomatis (`Rp`) dan tanggal menggunakan package `intl`.
- [x] **Form Tambah Transaksi**:
  - Pilihan jenis transaksi (*SegmentedButton* Pemasukan vs Pengeluaran).
  - Input judul, nominal, dan kategori dengan validasi input.
- [x] **Smoke Test**: Pengujian widget awal (`flutter test`) berhasil terkonfigurasi.

### 2. Roadmap / Rencana Pengembangan Kelompok
Berikut adalah rekomendasi fitur yang dapat dikembangkan bersama kelompok untuk memenuhi kriteria penilaian tugas:
- [ ] **Penyimpanan Data Lokal**: Integrasi SQLite (`sqflite`), `hive`, atau `shared_preferences` agar data tidak hilang saat aplikasi ditutup.
- [ ] **State Management**: Implementasi `Provider`, `Bloc`, atau `Riverpod` untuk manajemen state yang reaktif dan terstruktur.
- [ ] **Filter & Kategori**: Filter berdasarkan rentang waktu (harian, mingguan, bulanan) dan kategori (makanan, transport, belanja, dll.).
- [ ] **Grafik / Visualisasi**: Visualisasi pengeluaran bulanan menggunakan package `fl_chart`.
- [ ] **Export Data**: Fitur unduh laporan dalam format PDF atau CSV.

---

## 📂 Struktur Direktori

Struktur file di dalam direktori `lib/` disusun menggunakan pendekatan modular:

```text
lib/
├── main.dart                      # Titik awal eksekusi aplikasi (Entry point & konfigurasi tema)
├── models/
│   └── transaction_model.dart     # Definisi data model transaksi (id, title, amount, type, date)
├── screens/
│   ├── home_screen.dart           # Layar utama (Dashboard saldo & daftar transaksi)
│   └── add_transaction_screen.dart# Layar form penambahan transaksi baru
├── widgets/                       # (Opsional) Komponen reusable (misal: Custom Card, Button)
└── services/                      # (Opsional) Penanganan database lokal / shared preferences
```

---

## 🛠️ Prasyarat & Instalasi

### Prasyarat Sistem
Pastikan perangkat Anda sudah terinstal:
1. **Flutter SDK** (versi 3.13 ke atas atau versi stabil terbaru).
2. **Dart SDK** (termasuk dalam paket Flutter).
3. **Android Studio** atau **VS Code** (dengan ekstensi Flutter & Dart).
4. Emulator Android / iOS atau perangkat HP fisik dengan mode *Developer Options & USB Debugging* aktif.

Cek kesiapan lingkungan kerja dengan menjalankan:
```bash
flutter doctor
```

---

### Langkah Instalasi & Menjalankan Aplikasi

1. **Buka folder proyek** di terminal / command prompt atau VS Code:
   ```bash
   cd "Cash Flow"
   ```

2. **Unduh dependencies proyek**:
   ```bash
   flutter pub get
   ```

3. **Jalankan pengujian unit/widget**:
   ```bash
   flutter test
   ```

4. **Jalankan aplikasi di perangkat / emulator**:
   ```bash
   flutter run
   ```

---

## 🤝 Panduan Kolaborasi Git untuk Kelompok

Untuk mencegah konflik kode (*merge conflict*) selama pengerjaan tugas bersama:

### 1. Hubungkan / Clone Remote Repository
Untuk anggota kelompok yang ingin meng-clone repositori ini:
```bash
git clone https://github.com/CanLikez/cash-flow-mobcom.git
cd cash-flow-mobcom
flutter pub get
```

### 2. Alur Kerja Branch (Branching Strategy)
- `main` : Hanya berisi kode yang sudah stabil dan siap dipresentasikan.
- `dev` : Branch integrasi tempat menggabungkan fitur dari setiap anggota.
- `feature/<nama-fitur>` : Branch kerja masing-masing anggota.
  
Contoh alur pengerjaan anggota:
```bash
# 1. Update kode terbaru dari branch utama
git checkout dev
git pull origin dev

# 2. Buat branch baru untuk fitur yang dikerjakan
git checkout -b feature/database-sqlite

# 3. Lakukan pengkodean, kemudian commit
git add .
git commit -m "feat: implementasi fungsi CRUD SQLite untuk transaksi"

# 4. Push ke remote repo
git push -u origin feature/database-sqlite

# 5. Buat Pull Request (PR) ke branch dev untuk di-review oleh teman kelompok
```

---

## 📄 Lisensi & Penggunaan
Proyek ini dibuat untuk keperluan akademik mata kuliah Mobile Computing. Silakan dimodifikasi dan dikembangkan lebih lanjut sesuai dengan ketentuan silabus perkuliahan.
