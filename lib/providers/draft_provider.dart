import 'package:flutter/material.dart';
import '../models/draft_model.dart';
import '../repositories/draft_repository.dart';

class DraftProvider extends ChangeNotifier {
  final DraftRepository _repository = DraftRepository();

  List<DraftModel> _drafts = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<DraftModel> get drafts => _drafts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // READ
  Future<void> fetchDrafts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _drafts = await _repository.getDrafts();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // CREATE
  Future<bool> addDraft(DraftModel draft) async {
    try {
      await _repository.addDraft(draft);
      await fetchDrafts(); // Refresh data
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // UPDATE
  Future<bool> updateDraft(DraftModel draft) async {
    try {
      await _repository.editDraft(draft);
      await fetchDrafts(); // Refresh data
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // DELETE
  Future<bool> deleteDraft(int id) async {
    try {
      await _repository.removeDraft(id);
      await fetchDrafts(); // Refresh data
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}