import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/draft_model.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;
  final String _tableName = 'novel_drafts';

  // READ
  Future<List<DraftModel>> getDrafts() async {
    final response = await _client
        .from(_tableName)
        .select()
        .order('created_at', ascending: false);
    
    return (response as List).map((item) => DraftModel.fromMap(item)).toList();
  }

  // CREATE
  Future<void> createDraft(DraftModel draft) async {
    await _client.from(_tableName).insert(draft.toMap());
  }

  // UPDATE
  Future<void> updateDraft(DraftModel draft) async {
    await _client.from(_tableName).update(draft.toMap()).eq('id', draft.id!);
  }

  // DELETE
  Future<void> deleteDraft(int id) async {
    await _client.from(_tableName).delete().eq('id', id);
  }
}