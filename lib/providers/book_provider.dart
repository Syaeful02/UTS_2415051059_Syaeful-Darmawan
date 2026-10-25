import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../repositories/book_repository.dart';

class BookProvider extends ChangeNotifier {
  final BookRepository _repository = BookRepository();

  // State Management (Sesuai PDF: Minimal loading, data, error)
  bool _isLoading = false;
  String? _errorMessage;
  List<BookModel> _books = [];
  String _lastQuery = '';

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<BookModel> get books => _books;
  bool get isEmpty => _books.isEmpty && !_isLoading && _errorMessage == null;

  // Fungsi untuk memicu pencarian
  Future<void> searchBooks(String query) async {
    if (query.isEmpty) return;
    
    _lastQuery = query;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Memberitahu UI kalau loading dimulai

    try {
      _books = await _repository.getBooks(query);
      _isLoading = false;
      notifyListeners(); // Memberitahu UI kalau data sudah siap
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners(); // Memberitahu UI kalau ada error
    }
  }

  // Fungsi untuk retry jika error
  void retry() {
    if (_lastQuery.isNotEmpty) {
      searchBooks(_lastQuery);
    }
  }
}