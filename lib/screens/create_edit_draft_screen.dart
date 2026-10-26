import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book_model.dart';
import '../models/draft_model.dart';
import '../providers/draft_provider.dart';

class CreateEditDraftScreen extends StatefulWidget {
  final BookModel? book;
  final DraftModel? draft;
  final String defaultType; // Menentukan apakah ini 'reference' atau 'original'

  const CreateEditDraftScreen({
    super.key, 
    this.book, 
    this.draft, 
    this.defaultType = 'original' // Default ke original jika tidak dispesifikasi
  });

  @override
  State<CreateEditDraftScreen> createState() => _CreateEditDraftScreenState();
}

class _CreateEditDraftScreenState extends State<CreateEditDraftScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _synopsisController;
  late TextEditingController _contentController;
  
  String _selectedGenre = 'Fantasy';
  String _selectedStatus = 'Draft';

  final List<String> genres = ['Fantasy', 'Romance', 'Sci-Fi', 'Horror', 'Mystery', 'Non-Fiction'];
  final List<String> statuses = ['Draft', 'Writing', 'Completed'];

  @override
  void initState() {
    super.initState();
    // Jika datang dari API (Inspirasi)
    if (widget.book != null) {
      _titleController = TextEditingController(text: widget.book!.title);
      _synopsisController = TextEditingController(text: widget.book!.description);
      _contentController = TextEditingController();
    } 
    // Jika datang dari Database (Edit)
    else if (widget.draft != null) {
      _titleController = TextEditingController(text: widget.draft!.title);
      _synopsisController = TextEditingController(text: widget.draft!.synopsis);
      _contentController = TextEditingController(text: widget.draft!.content);
      _selectedGenre = widget.draft!.genre;
      _selectedStatus = widget.draft!.status;
    } 
    // Jika dari Home (Buat Novel Baru)
    else {
      _titleController = TextEditingController();
      _synopsisController = TextEditingController();
      _contentController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _synopsisController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveData() async {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<DraftProvider>();
      
      // Tentukan tipe: Jika sedang edit, pakai tipe lama. Jika baru, pakai defaultType.
      final draftType = widget.draft?.type ?? widget.defaultType;

      final newDraft = DraftModel(
        id: widget.draft?.id, 
        title: _titleController.text,
        genre: _selectedGenre,
        synopsis: _synopsisController.text,
        status: _selectedStatus,
        content: _contentController.text,
        type: draftType, 
      );

      bool success;
      if (widget.draft == null) {
        success = await provider.addDraft(newDraft);
      } else {
        success = await provider.updateDraft(newDraft);
      }

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.draft == null ? 'Berhasil menyimpan data!' : 'Berhasil mengubah data!')),
        );
        Navigator.pop(context);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal: ${provider.errorMessage ?? "Terjadi kesalahan"}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Cek apakah ini mode Edit, Create Referensi, atau Create Original
    String appBarTitle = 'Tulis Novel Baru';
    if (widget.draft != null) {
      appBarTitle = 'Edit Karya';
    } else if (widget.defaultType == 'reference') {
      appBarTitle = 'Simpan Referensi';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        backgroundColor: const Color(0xFF5D4037),
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Judul Novel', border: OutlineInputBorder()),
              validator: (value) => value!.isEmpty ? 'Judul tidak boleh kosong' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedGenre, 
                    decoration: const InputDecoration(labelText: 'Genre', border: OutlineInputBorder()),
                    items: genres.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (val) => setState(() => _selectedGenre = val!),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedStatus, 
                    decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
                    items: statuses.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (val) => setState(() => _selectedStatus = val!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _synopsisController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Sinopsis Singkat', border: OutlineInputBorder()),
              validator: (value) => value!.length < 10 ? 'Sinopsis minimal 10 karakter' : null,
            ),
            const SizedBox(height: 16),
            
            // Field ini disembunyikan jika hanya menyimpan referensi dari API
            // Tapi ditampilkan jika ini adalah novel karya user sendiri
            if (widget.defaultType == 'original' || widget.draft?.type == 'original') ...[
              TextFormField(
                controller: _contentController,
                maxLines: 10,
                decoration: const InputDecoration(
                  labelText: 'Isi Novel (Mulai Menulis di Sini...)', 
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 16),
            ],

            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _saveData,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5D4037),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('SIMPAN DATA'),
            )
          ],
        ),
      ),
    );
  }
}