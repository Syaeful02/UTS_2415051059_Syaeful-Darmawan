import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/draft_model.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;
  final String _tableName = 'novel_drafts';

  // Ambil data berdasarkan tipe (reference / original)
  Future<List<DraftModel>> getDraftsByType(String type) async {
    final response = await _client
        .from(_tableName)
        .select()
        .eq('type', type) // Filter berdasarkan kolom type
        .order('created_at', ascending: false);
    
    return (response as List).map((item) => DraftModel.fromMap(item)).toList();
  }

  Future<void> createDraft(DraftModel draft) async {
    await _client.from(_tableName).insert(draft.toMap());
  }

  Future<void> updateDraft(DraftModel draft) async {
    await _client.from(_tableName).update(draft.toMap()).eq('id', draft.id!);
  }

  Future<void> deleteDraft(int id) async {
    await _client.from(_tableName).delete().eq('id', id);
  }
}