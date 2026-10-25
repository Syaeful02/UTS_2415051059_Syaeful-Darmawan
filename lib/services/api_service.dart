import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book_model.dart';

class ApiService {
  // Fungsi untuk mengambil data buku dari Google Books API
  Future<List<BookModel>> searchBooks(String query) async {
    final url = Uri.parse('https://www.googleapis.com/books/v1/volumes?q=$query&maxResults=20');
    
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['items'] == null) {
          return []; // Mengembalikan list kosong jika tidak ada hasil
        }

        final List items = data['items'];
        return items.map((item) => BookModel.fromJson(item)).toList();
      } else {
        throw Exception('Gagal memuat data dari server (Code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan jaringan: $e');
    }
  }
}