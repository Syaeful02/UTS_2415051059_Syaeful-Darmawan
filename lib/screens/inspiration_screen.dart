import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import '../widgets/book_card.dart';
import '../widgets/empty_state.dart';
import 'book_detail_screen.dart';

class InspirationScreen extends StatefulWidget {
  const InspirationScreen({super.key});

  @override
  State<InspirationScreen> createState() => _InspirationScreenState();
}

class _InspirationScreenState extends State<InspirationScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Fungsi bantuan agar tidak nulis kode berulang
  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      // Sembunyikan keyboard
      FocusScope.of(context).unfocus();
      // Panggil API
      context.read<BookProvider>().searchBooks(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari Inspirasi Buku'),
        backgroundColor: const Color(0xFF5D4037),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Kolom Pencarian
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search, // Mengubah tombol enter jadi ikon search
              decoration: InputDecoration(
                hintText: 'Ketik judul (cth: Harry Potter)...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                // TOMBOL SUBMIT BARU DI SINI
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward, color: Color(0xFF5D4037)),
                  onPressed: _performSearch, 
                ),
              ),
              onSubmitted: (value) {
                _performSearch(); // Bisa ditekan lewat tombol enter keyboard juga
              },
            ),
          ),
          
          // Area Hasil Pencarian
          Expanded(
            child: Consumer<BookProvider>(
              builder: (context, provider, child) {
                // 1. Loading State
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                // 2. Error State
                if (provider.errorMessage != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 60, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(provider.errorMessage!, textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => provider.retry(),
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  );
                }

                // 3. Empty State
                if (provider.isEmpty) {
                  return const EmptyState(
                    message: 'Belum ada buku yang dicari.\nKetik judul lalu tekan tombol panah.',
                    icon: Icons.search,
                  );
                }

                // 4. Success/Data State
                return LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;

                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 0.6,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: provider.books.length,
                      itemBuilder: (context, index) {
                        final book = provider.books[index];
                        
                        return BookCard(
                          book: book,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookDetailScreen(book: book),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}