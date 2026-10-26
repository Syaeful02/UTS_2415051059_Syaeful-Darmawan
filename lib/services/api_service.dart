import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book_model.dart';

class ApiService {
  Future<List<BookModel>> searchBooks(String query) async {
    final url = Uri.https('www.googleapis.com', '/books/v1/volumes', {
      'q': query,
      'maxResults': '20',
      'key': 'AIzaSyA4_NFLXuiKaukuxncJYxn6aplNNnw8MZA', // Opsional: Aktifkan jika sudah punya API Key (Solusi 2)
    });

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['items'] == null) {
          return []; 
        }

        final List items = data['items'];
        return items.map((item) => BookModel.fromJson(item)).toList();
      } else if (response.statusCode == 429) {
        // JIKA KENA RATE LIMIT (429), KEMBALIKAN DATA DUMMY
        return _getMockBooks(query);
      } else {
        throw Exception('Gagal memuat data (Code: ${response.statusCode})');
      }
    } catch (e) {
      // Jika error jaringan, coba tampilkan data dummy sebagai fallback
      return _getMockBooks(query);
    }
  }

  // Data Buku Cadangan (Mock Data)
  List<BookModel> _getMockBooks(String query) {
    return [
      BookModel(
        id: 'mock-1',
        title: 'Contoh Buku: ${query.toUpperCase()}',
        authors: 'Penulis Terkenal',
        description: 'Ini adalah data cadangan karena koneksi ke Google Books API sedang sibuk (Error 429). Silakan gunakan data ini untuk melanjutkan pengujian aplikasi.',
        thumbnail: 'https://via.placeholder.com/150x200?text=Mock+Book',
        publishedDate: '2024',
      ),
      BookModel(
        id: 'mock-2',
        title: 'Buku Inspirasi: ${query.toUpperCase()}',
        authors: 'Penulis Inspiratif',
        description: 'Data ini muncul otomatis sebagai fallback. Kamu tetap bisa mengujicoba fitur "Tambah ke My Library" dan CRUD database Supabase dengan data ini.',
        thumbnail: 'https://via.placeholder.com/150x200?text=Mock+Book+2',
        publishedDate: '2023',
      ),
    ];
  }
}