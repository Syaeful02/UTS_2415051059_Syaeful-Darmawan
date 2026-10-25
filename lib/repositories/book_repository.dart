import '../models/book_model.dart';
import '../services/api_service.dart';

class BookRepository {
  final ApiService _apiService = ApiService();

  // Screen/Provider tidak boleh memanggil ApiService secara langsung.
  // Harus lewat Repository (Sesuai standar arsitektur di PDF).
  Future<List<BookModel>> getBooks(String query) {
    return _apiService.searchBooks(query);
  }
}