import '../models/draft_model.dart';
import '../services/supabase_service.dart';

class DraftRepository {
  final SupabaseService _service = SupabaseService();

  Future<List<DraftModel>> getDrafts() => _service.getDrafts();
  Future<void> addDraft(DraftModel draft) => _service.createDraft(draft);
  Future<void> editDraft(DraftModel draft) => _service.updateDraft(draft);
  Future<void> removeDraft(int id) => _service.deleteDraft(id);
}