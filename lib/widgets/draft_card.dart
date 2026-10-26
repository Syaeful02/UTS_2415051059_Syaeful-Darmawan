import 'package:flutter/material.dart';
import '../models/draft_model.dart';

class DraftCard extends StatelessWidget {
  final DraftModel draft;
  final VoidCallback onRead; // Tambahan untuk baca
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const DraftCard({
    super.key, 
    required this.draft, 
    required this.onRead,
    required this.onEdit, 
    required this.onDelete
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(draft.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${draft.genre} • ${draft.status}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tombol Baca
            IconButton(
              icon: const Icon(Icons.menu_book, color: Colors.green),
              onPressed: onRead,
            ),
            // Tombol Edit
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
            ),
            // Tombol Delete
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}