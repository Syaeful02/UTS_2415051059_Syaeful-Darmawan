import '../models/draft_model.dart';
import '../services/supabase_service.dart';

class DraftRepository {
  final SupabaseService _service = SupabaseService();

  // Menggunakan getDraftsByType agar sesuai dengan SupabaseService yang baru
  Future<List<DraftModel>> getDraftsByType(String type) => _service.getDraftsByType(type);
  
  Future<void> addDraft(DraftModel draft) => _service.createDraft(draft);
  Future<void> editDraft(DraftModel draft) => _service.updateDraft(draft);
  Future<void> removeDraft(int id) => _service.deleteDraft(id);
}