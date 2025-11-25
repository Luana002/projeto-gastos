import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../repositories/transaction_repository.dart';

class TransactionProvider extends ChangeNotifier {
  final TransactionRepository repo;

  bool isLoading = false;
  List<Map<String, dynamic>> items = [];
  String? error;

  TransactionProvider({required this.repo});

  Future<void> init() async {
    isLoading = true;
    notifyListeners();
    await repo.init();
    await load();
  }

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    try {
      items = repo.getAll();
      if (kDebugMode) {
        debugPrint('TransactionProvider.load: ${items.length} items loaded');
        if (items.isNotEmpty) debugPrint('First item: ${items.first}');
      }
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> add(Map<String, dynamic> t) async {
    isLoading = true;
    notifyListeners();
    try {
      final created = await repo.add(t);
      items.add(created);
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> update(Map<String, dynamic> t) async {
    isLoading = true;
    notifyListeners();
    try {
      await repo.update(t);
      final idx = items.indexWhere((x) => x['id'] == t['id']);
      if (idx != -1) items[idx] = t;
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> delete(int id) async {
    isLoading = true;
    notifyListeners();
    try {
      await repo.delete(id);
      items.removeWhere((x) => x['id'] == id);
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}