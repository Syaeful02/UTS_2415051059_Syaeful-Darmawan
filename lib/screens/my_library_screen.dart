import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/draft_provider.dart';
import '../widgets/empty_state.dart';
import 'read_novel_screen.dart';

class MyLibraryScreen extends StatefulWidget {
  const MyLibraryScreen({super.key});

  @override
  State<MyLibraryScreen> createState() => _MyLibraryScreenState();
}

class _MyLibraryScreenState extends State<MyLibraryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DraftProvider>().fetchAllDrafts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perpustakaan Referensi'),
        backgroundColor: const Color(0xFF5D4037),
        foregroundColor: Colors.white,
      ),
      body: Consumer<DraftProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) return const Center(child: CircularProgressIndicator());
          
          if (provider.references.isEmpty) {
            return const EmptyState(
              message: 'Belum ada buku referensi tersimpan.\nCari di tab Inspirasi.',
              icon: Icons.library_books,
            );
          }

          return ListView.builder(
            itemCount: provider.references.length,
            itemBuilder: (context, index) {
              final draft = provider.references[index];
              
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(draft.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${draft.genre} • Referensi'),
                  trailing: IconButton(
                    icon: const Icon(Icons.menu_book, color: Colors.green),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReadNovelScreen(draft: draft)),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}