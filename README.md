# InkSpire - Aplikasi Inspirasi & Penulisan Novel

## Identitas Mahasiswa
- **Nama:** [Syaeful Darmawan]
- **NIM:** [2415051059]
- **Kelas:** [PTI 5A]

## Deskripsi Project
InkSpire adalah aplikasi mobile berbasis Flutter yang dirancang khusus untuk para penulis. Aplikasi ini memfasilitasi dua kebutuhan utama penulis: **mencari inspirasi** dari buku-buku populer di seluruh dunia, dan **menulis draf novel original** mereka sendiri. Aplikasi ini memisahkan secara jelas antara perpustakaan referensi dan ruang kerja kreatif penulis.

## Fitur Utama
1. **Home (Ruang Kerja Penulis):** Pusat untuk mulai menulis novel baru. Menampilkan preview karya terbaru dan tombol pintas untuk mencari inspirasi.
2. **Inspiration (Pencarian Referensi):** Mencari buku dari Google Books API. Tampilan grid responsif (menyesuaikan ukuran layar HP/Tablet).
3. **My Library (Perpustakaan Referensi):** Menyimpan dan membaca buku-buku referensi yang ditemukan dari API. (Terpisah dari karya original).
4. **Profile (Manajemen Karya Sendiri):** Menampilkan identitas mahasiswa serta daftar novel original yang ditulis oleh pengguna. Pengguna dapat membaca, mengedit, dan menghapus karya mereka di sini.
5. **Novel Reader:** Fitur untuk membaca isi novel dengan tampilan menyerupai buku fisik (font khusus, spasi nyaman).
6. **CRUD & State Management:** Menggunakan Provider (`ChangeNotifier`) dan Supabase (PostgreSQL) untuk operasi Create, Read, Update, Delete dengan *loading* dan *error state*.

## Tech Stack & Arsitektur
- **Framework:** Flutter (Dart)
- **State Management:** Provider
- **REST API:** Google Books API (`https://www.googleapis.com/books/v1/volumes`)
- **Backend/Database:** Supabase (PostgreSQL)
- **Arsitektur:** UI -> Provider -> Repository -> Service -> API/Database

### Struktur Folder
```text
lib/
 ┣ models/         # BookModel (API), DraftModel (Database)
 ┣ services/       # ApiService (HTTP), SupabaseService (Query DB)
 ┣ repositories/   # Menghubungkan Service ke Provider
 ┣ providers/      # BookProvider, DraftProvider (State Management)
 ┣ screens/        # 7 Screen Fungsional (Home, Inspirasi, Detail, My Library, Form, Reader, Profile)
 ┣ widgets/        # Reusable Widgets (BookCard, DraftCard, EmptyState)
 ┗ main.dart       # Entry point & Setup Provider/Supabase