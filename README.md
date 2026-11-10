# Cash Flow Harian

Aplikasi pencatatan keuangan harian sederhana berbasis Flutter. Aplikasi ini membantu pengguna melacak arus kas harian melalui pencatatan pemasukan dan pengeluaran secara cepat dan terorganisir.

---

## Fitur Utama

- **Ringkasan Saldo**: Menampilkan total saldo saat ini beserta akumulasi pemasukan dan pengeluaran.
- **Pencatatan Transaksi**: Input pemasukan atau pengeluaran lengkap dengan judul, nominal, tanggal, dan kategori.
- **Format Rupiah Otomatis**: Menampilkan seluruh nilai nominal dalam format Rupiah (`id_ID`).
- **Riwayat Harian**: Daftar transaksi harian dengan pembeda visual jenis transaksi dan opsi hapus cepat.

---

## Tech Stack

- **Framework**: Flutter 3.x
- **Bahasa Pemrograman**: Dart 3.x
- **UI & Desain**: Material Design 3
- **Dependencies**: `intl` (pemformatan mata uang dan tanggal)

---

## Struktur Proyek

```text
lib/
├── main.dart                      # Entry point aplikasi & konfigurasi tema
├── models/
│   └── transaction_model.dart     # Model data transaksi
└── screens/
    ├── home_screen.dart           # Halaman utama (dashboard saldo & riwayat)
    └── add_transaction_screen.dart# Form input transaksi baru
```

---

## Memulai (Getting Started)

### Prasyarat
- Flutter SDK (>= 3.13)
- Dart SDK
- Android Studio / VS Code
- Android Emulator atau perangkat fisik dengan USB Debugging aktif

### Instalasi & Menjalankan Aplikasi

1. **Clone repositori**
   ```bash
   git clone https://github.com/CanLikez/cash-flow-mobcom.git
   cd cash-flow-mobcom
   ```

2. **Pasang dependensi**
   ```bash
   flutter pub get
   ```

3. **Jalankan pengujian**
   ```bash
   flutter test
   ```

4. **Jalankan aplikasi**
   ```bash
   flutter run
   ```

---

## Tim Pengembang

Proyek ini dikembangkan oleh:

| No | Nama | NIM |
|:---:|---|:---:|
| 1 | Ernando Febrian | 1313624021 |
| 2 | Candra Afriansyah | 1313624023 |
| 3 | Nandana Ammar Triabimanyu | 1313624030 |
| 4 | Sukarno Adi Prasetya | 1313624010 |

---

## Lisensi

Proyek ini didistribusikan di bawah lisensi [MIT](LICENSE) (atau bebas digunakan untuk keperluan edukasi dan pembelajaran).
