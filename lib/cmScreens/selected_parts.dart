// TODO Implement this library.
// selected_parts.dart
import 'dart:convert';

class SelectedPartsManager {
  static final Map<int, List<Map<String, dynamic>>> _selectedParts = {};

  static void addPart(Map<String, dynamic> part, int processId) {
    final partWithProcessId = {
      ...part,
      'Process_ID': processId,
    };
    if (_selectedParts.containsKey(processId)) {
      _selectedParts[processId]!.add(partWithProcessId);
    } else {
      _selectedParts[processId] = [partWithProcessId];
    }
  }

  // ฟังก์ชันในการลบอะไหล่จาก _selectedParts
  static void removePart(int processId, int partIndex) {
    if (_selectedParts.containsKey(processId)) {
      _selectedParts[processId]!.removeAt(partIndex);
      if (_selectedParts[processId]!.isEmpty) {
        _selectedParts.remove(processId);
      }
    }
  }

  static List<Map<String, dynamic>> getSelectedPartsByProcessId(int processId) {
    return _selectedParts[processId] ?? [];
  }

  static List<Map<String, dynamic>> getSelectedParts() {
    return _selectedParts.values.expand((parts) => parts).toList();
  }

  static void clearPartsForProcessId(int processId) {
    _selectedParts.remove(processId);
  }

  static void clear() {
    _selectedParts.clear();
  }

  static bool hasData() {
    return _selectedParts.isNotEmpty;
  }

  static String toJson() {
    return jsonEncode(
        _selectedParts.map((key, value) => MapEntry(key.toString(), value)));
  }

  static void printSelectedParts() {
    print(_selectedParts);
  }
}
