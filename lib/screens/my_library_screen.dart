import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/draft_provider.dart';
import 'create_edit_draft_screen.dart';

class MyLibraryScreen extends StatefulWidget {
  const MyLibraryScreen({super.key});

  @override
  State<MyLibraryScreen> createState() => _MyLibraryScreenState();
}

class _MyLibraryScreenState extends State<MyLibraryScreen> {
  @override
  void initState() {
    super.initState();
    // Ambil data dari database saat screen dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DraftProvider>().fetchDrafts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Library'),
        backgroundColor: const Color(0xFF5D4037),
        foregroundColor: Colors.white,
      ),
      body: Consumer<DraftProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) return const Center(child: CircularProgressIndicator());
          if (provider.errorMessage != null) return Center(child: Text('Error: ${provider.errorMessage}'));
          if (provider.drafts.isEmpty) return const Center(child: Text('Belum ada draft novel tersimpan.'));

          return ListView.builder(
            itemCount: provider.drafts.length,
            itemBuilder: (context, index) {
              final draft = provider.drafts[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(draft.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${draft.genre} • ${draft.status}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CreateEditDraftScreen(draft: draft)),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Dialog Konfirmasi Delete (Sesuai PDF)
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Hapus Draft?'),
                              content: Text('Yakin ingin menghapus "${draft.title}"?'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    bool success = await provider.deleteDraft(draft.id!);
                                    if (success && context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Draft berhasil dihapus')),
                                      );
                                    }
                                  },
                                  child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
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