// // TODO Implement this library.
// // selected_parts.dart
// import 'dart:convert';

// class SelectedPartsManager {
//   static final Map<int, List<Map<String, dynamic>>> _selectedParts = {};

//   static void addPart(Map<String, dynamic> part, int processId) {
//     final partWithProcessId = {
//       ...part,
//       'Process_ID': processId,
//     };
//     if (_selectedParts.containsKey(processId)) {
//       _selectedParts[processId]!.add(partWithProcessId);
//     } else {
//       _selectedParts[processId] = [partWithProcessId];
//     }
//   }

//   // ฟังก์ชันในการลบอะไหล่จาก _selectedParts
//   static void removePart(int processId, int partIndex) {
//     if (_selectedParts.containsKey(processId)) {
//       _selectedParts[processId]!.removeAt(partIndex);
//       if (_selectedParts[processId]!.isEmpty) {
//         _selectedParts.remove(processId);
//       }
//     }
//   }

//   static List<Map<String, dynamic>> getSelectedPartsByProcessId(int processId) {
//     return _selectedParts[processId] ?? [];
//   }

//   static List<Map<String, dynamic>> getSelectedParts() {
//     return _selectedParts.values.expand((parts) => parts).toList();
//   }

//   static void clearPartsForProcessId(int processId) {
//     _selectedParts.remove(processId);
//   }

//   static void clear() {
//     _selectedParts.clear();
//   }

//   static bool hasData() {
//     return _selectedParts.isNotEmpty;
//   }

//   static String toJson() {
//     return jsonEncode(
//         _selectedParts.map((key, value) => MapEntry(key.toString(), value)));
//   }

//   static void printSelectedParts() {
//     print(_selectedParts);
//   }
// }
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SelectedPartsManager {
  static const _selectedPartsKey = 'selected_parts';

  static Future<void> addPart(Map<String, dynamic> part, int processId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final selectedParts = await _getSelectedPartsFromPrefs();

    final partWithProcessId = {
      ...part,
      'Process_ID': processId,
    };

    if (selectedParts.containsKey(processId)) {
      selectedParts[processId]!.add(partWithProcessId);
    } else {
      selectedParts[processId] = [partWithProcessId];
    }

    // บันทึกข้อมูลที่อัปเดตไปยัง SharedPreferences
    await _saveSelectedPartsToPrefs(selectedParts);
  }

  static Future<void> removePart(int processId, int partIndex) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final selectedParts = await _getSelectedPartsFromPrefs();

    if (selectedParts.containsKey(processId)) {
      selectedParts[processId]!.removeAt(partIndex);
      if (selectedParts[processId]!.isEmpty) {
        selectedParts.remove(processId);
      }
    }

    // บันทึกข้อมูลที่อัปเดตไปยัง SharedPreferences
    await _saveSelectedPartsToPrefs(selectedParts);
  }

  static Future<List<Map<String, dynamic>>> getSelectedPartsByProcessId(
      int processId) async {
    final selectedParts = await _getSelectedPartsFromPrefs();
    return selectedParts[processId] ?? [];
  }

  static Future<List<Map<String, dynamic>>> getSelectedParts() async {
    final selectedParts = await _getSelectedPartsFromPrefs();
    return selectedParts.values.expand((parts) => parts).toList();
  }

  static Future<void> clearPartsForProcessId(int processId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final selectedParts = await _getSelectedPartsFromPrefs();
    selectedParts.remove(processId);

    // บันทึกข้อมูลที่อัปเดตไปยัง SharedPreferences
    await _saveSelectedPartsToPrefs(selectedParts);
  }

  static Future<void> clear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_selectedPartsKey);
  }

  static Future<bool> hasData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_selectedPartsKey);
  }

  static Future<String> toJson() async {
    final selectedParts = await _getSelectedPartsFromPrefs();
    return jsonEncode(
        selectedParts.map((key, value) => MapEntry(key.toString(), value)));
  }

  static Future<void> printSelectedParts() async {
    final selectedParts = await _getSelectedPartsFromPrefs();
    print(selectedParts);
  }

  // ฟังก์ชันช่วยในการดึงข้อมูล selected parts จาก SharedPreferences
  static Future<Map<int, List<Map<String, dynamic>>>>
      _getSelectedPartsFromPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_selectedPartsKey);
    if (jsonString == null) {
      return {};
    }
    final Map<String, dynamic> decoded = jsonDecode(jsonString);
    return decoded.map((key, value) =>
        MapEntry(int.parse(key), List<Map<String, dynamic>>.from(value)));
  }

  // ฟังก์ชันช่วยในการบันทึก selected parts ไปยัง SharedPreferences
  static Future<void> _saveSelectedPartsToPrefs(
      Map<int, List<Map<String, dynamic>>> selectedParts) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(
        selectedParts.map((key, value) => MapEntry(key.toString(), value)));
    await prefs.setString(_selectedPartsKey, jsonString);
  }
}
