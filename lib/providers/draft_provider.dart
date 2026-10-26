import 'package:flutter/material.dart';
import '../models/draft_model.dart';
import '../repositories/draft_repository.dart';

class DraftProvider extends ChangeNotifier {
  final DraftRepository _repository = DraftRepository();

  List<DraftModel> _references = [];
  List<DraftModel> _originals = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<DraftModel> get references => _references;
  List<DraftModel> get originals => _originals;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchAllDrafts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Memanggil fungsi baru dari repository
      _references = await _repository.getDraftsByType('reference');
      _originals = await _repository.getDraftsByType('original');
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<bool> addDraft(DraftModel draft) async {
    try {
      await _repository.addDraft(draft);
      await fetchAllDrafts();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateDraft(DraftModel draft) async {
    try {
      await _repository.editDraft(draft);
      await fetchAllDrafts();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteDraft(int id) async {
    try {
      await _repository.removeDraft(id);
      await fetchAllDrafts();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}