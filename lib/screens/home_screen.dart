import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/draft_provider.dart';
import 'create_edit_draft_screen.dart';
import 'read_novel_screen.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onNavigateToInspiration;

  const HomeScreen({super.key, required this.onNavigateToInspiration});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InkSpire Studio'),
        backgroundColor: const Color(0xFF5D4037),
        foregroundColor: Colors.white,
      ),
      body: Consumer<DraftProvider>(
        builder: (context, provider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Kartu Utama: Mulai Menulis
              Card(
                color: const Color(0xFF5D4037),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const Icon(Icons.create, size: 60, color: Colors.white),
                      const SizedBox(height: 16),
                      const Text(
                        'Mulai Karya Baru',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tuangkan ide ceritamu menjadi sebuah novel.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF5F0E6),
                            foregroundColor: const Color(0xFF5D4037),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () {
                            // Navigasi ke form Create dengan tipe 'original'
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CreateEditDraftScreen(defaultType: 'original'),
                              ),
                            );
                          },
                          child: const Text('TULIS NOVEL BARU'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Tombol Kecil Cari Inspirasi
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF5D4037)),
                  foregroundColor: const Color(0xFF5D4037),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const Icon(Icons.search),
                label: const Text('Mulai Mencari Inspirasi'),
                onPressed: onNavigateToInspiration, // Panggil fungsi pindah tab
              ),

              const SizedBox(height: 32),
              const Text(
                'Karya Terbarumu',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // List Preview Karya Original
              if (provider.originals.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Belum ada novel yang ditulis. Yuk mulai menulis!', style: TextStyle(color: Colors.grey)),
                )
              else
                ...provider.originals.take(3).map((draft) {
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.book, color: Color(0xFF5D4037)),
                      title: Text(draft.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(draft.status),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ReadNovelScreen(draft: draft)),
                        );
                      },
                    ),
                  );
                }),
            ],
          );
        },
      ),
    );
  }
}