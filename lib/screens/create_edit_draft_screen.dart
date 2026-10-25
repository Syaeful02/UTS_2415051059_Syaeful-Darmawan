import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book_model.dart';
import '../models/draft_model.dart';
import '../providers/draft_provider.dart';

class CreateEditDraftScreen extends StatefulWidget {
  final BookModel? book; // Untuk Create dari API
  final DraftModel? draft; // Untuk Edit dari Database

  const CreateEditDraftScreen({super.key, this.book, this.draft});

  @override
  State<CreateEditDraftScreen> createState() => _CreateEditDraftScreenState();
}

class _CreateEditDraftScreenState extends State<CreateEditDraftScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _synopsisController;
  String _selectedGenre = 'Fantasy';
  String _selectedStatus = 'Draft';

  final List<String> genres = ['Fantasy', 'Romance', 'Sci-Fi', 'Horror', 'Mystery', 'Non-Fiction'];
  final List<String> statuses = ['Draft', 'Writing', 'Completed'];

  @override
  void initState() {
    super.initState();
    // Jika dari API (Create)
    if (widget.book != null) {
      _titleController = TextEditingController(text: widget.book!.title);
      _synopsisController = TextEditingController(text: widget.book!.description);
    } 
    // Jika dari Database (Edit)
    else if (widget.draft != null) {
      _titleController = TextEditingController(text: widget.draft!.title);
      _synopsisController = TextEditingController(text: widget.draft!.synopsis);
      _selectedGenre = widget.draft!.genre;
      _selectedStatus = widget.draft!.status;
    } 
    // Fallback
    else {
      _titleController = TextEditingController();
      _synopsisController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _synopsisController.dispose();
    super.dispose();
  }

  void _saveData() async {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<DraftProvider>();
      final newDraft = DraftModel(
        id: widget.draft?.id, // Null jika Create, ada isinya jika Edit
        title: _titleController.text,
        genre: _selectedGenre,
        synopsis: _synopsisController.text,
        status: _selectedStatus,
      );

      bool success;
      if (widget.draft == null) {
        success = await provider.addDraft(newDraft);
      } else {
        success = await provider.updateDraft(newDraft);
      }

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.draft == null ? 'Berhasil menambah draft!' : 'Berhasil mengubah draft!')),
        );
        Navigator.pop(context);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menyimpan data.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.draft == null ? 'Simpan Draft Novel' : 'Edit Draft Novel'),
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
            
            // PERBAIKAN: value menjadi initialValue
            DropdownButtonFormField<String>(
              initialValue: _selectedGenre, 
              decoration: const InputDecoration(labelText: 'Genre', border: OutlineInputBorder()),
              items: genres.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) => setState(() => _selectedGenre = val!),
            ),
            
            const SizedBox(height: 16),
            
            // PERBAIKAN: value menjadi initialValue
            DropdownButtonFormField<String>(
              initialValue: _selectedStatus, 
              decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
              items: statuses.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) => setState(() => _selectedStatus = val!),
            ),
            
            const SizedBox(height: 16),
            TextFormField(
              controller: _synopsisController,
              maxLines: 5,
              decoration: const InputDecoration(labelText: 'Sinopsis / Catatan', border: OutlineInputBorder()),
              validator: (value) => value!.length < 10 ? 'Sinopsis minimal 10 karakter' : null,
            ),
            const SizedBox(height: 24),
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