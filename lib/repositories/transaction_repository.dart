import 'dart:math';
import 'package:flutter/foundation.dart';

import 'package:hive_flutter/hive_flutter.dart';

class TransactionRepository {
  static const String boxName = 'transactions_box';
  late Box _box;

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(boxName);
  }

  List<Map<String, dynamic>> getAll() {
    try {
      debugPrint('TransactionRepository.getAll: raw values=${_box.values.toList()}');
    } catch (_) {}
    
    return _box.values.map<Map<String, dynamic>>((v) {
      if (v is Map) {
        return Map<String, dynamic>.from(Map<String, dynamic>.from(v));
      }
      return {};
    }).toList();
  }

  Future<Map<String, dynamic>> add(Map<String, dynamic> item) async {
    final nextId = _nextId();
    final withId = {...item, 'id': nextId};
    await _box.put(nextId, withId);
    return Map<String, dynamic>.from(withId);
  }

  Future<void> update(Map<String, dynamic> item) async {
    final id = item['id'];
    if (id == null) return;
    await _box.put(id, item);
  }

  Future<void> delete(int id) async {
    await _box.delete(id);
  }

  int _nextId() {
    if (_box.isEmpty) return 1;
    try {
      final keys = _box.keys.where((k) => k is int).cast<int>();
      if (keys.isEmpty) return 1;
      return keys.reduce(max) + 1;
    } catch (_) {
      return _box.length + 1;
    }
  }
}
