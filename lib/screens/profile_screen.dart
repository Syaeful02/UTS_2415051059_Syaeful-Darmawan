import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/draft_provider.dart';
import '../widgets/draft_card.dart';
import 'create_edit_draft_screen.dart';
import 'read_novel_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
        title: const Text('Profil & Karya Saya'),
        backgroundColor: const Color(0xFF5D4037),
        foregroundColor: Colors.white,
      ),
      body: Consumer<DraftProvider>(
        builder: (context, provider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // --- BAGIAN 1: IDENTITAS MAHASISWA (KODE LAMA KAMU) ---
              const CircleAvatar(
                radius: 60,
                backgroundColor: Color(0xFF5D4037),
                child: Icon(Icons.person, size: 80, color: Colors.white),
              ),
              const SizedBox(height: 16),
              const Text(
                'Syaeful Darmawan', // 
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Text(
                'NIM: 2415051059\nKelas: PTI 5A', // 
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              
              const Divider(height: 40, thickness: 2),

              // --- BAGIAN 2: DAFTAR KARYA SENDIRI (TAMBAHAN BARU) ---
              const Text(
                'Novel Karyaku',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              
              if (provider.isLoading)
                const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()))
              else if (provider.originals.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                      'Belum ada novel yang ditulis.\nMulai menulis di halaman Home!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              else
                ...provider.originals.map((draft) {
                  return DraftCard(
                    draft: draft,
                    onRead: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReadNovelScreen(draft: draft)),
                      );
                    },
                    onEdit: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CreateEditDraftScreen(draft: draft)),
                      );
                    },
                    onDelete: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Hapus Karya?'),
                          content: Text('Yakin ingin menghapus "${draft.title}"?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                bool success = await provider.deleteDraft(draft.id!);
                                if (success && context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Karya berhasil dihapus')),
                                  );
                                }
                              },
                              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),

              const Divider(height: 40),

              // --- BAGIAN 3: INFO APLIKASI (KODE LAMA KAMU) ---
              const ListTile(
                leading: Icon(Icons.info),
                title: Text('Tentang Aplikasi'),
                subtitle: Text('InkSpire adalah aplikasi pencari inspirasi novel dan pencatatan draft.'),
              ),
              const ListTile(
                leading: Icon(Icons.code),
                title: Text('Versi'),
                subtitle: Text('1.0.0'),
              )
            ],
          );
        },
      ),
    );
  }
}