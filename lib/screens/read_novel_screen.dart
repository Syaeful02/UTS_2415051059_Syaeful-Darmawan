import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/draft_model.dart';

class ReadNovelScreen extends StatelessWidget {
  final DraftModel draft;

  const ReadNovelScreen({super.key, required this.draft});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(draft.title),
        backgroundColor: const Color(0xFF5D4037),
        foregroundColor: Colors.white,
      ),
      // Gunakan latar belakang agak kekuningan seperti buku bacaan
      backgroundColor: const Color(0xFFFAF6E8), 
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              draft.title,
              style: GoogleFonts.playfairDisplay(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF3E2723),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Genre: ${draft.genre}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const Divider(height: 32, thickness: 2),
            // Isi Novel
            Text(
              draft.content.isEmpty 
                  ? 'Belum ada isi cerita. Silakan edit draft ini untuk mulai menulis.' 
                  : draft.content,
              style: GoogleFonts.lora(
                fontSize: 18,
                height: 1.8, // Spasi baris agar enak dibaca
                color: const Color(0xFF3E2723),
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}