import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SelectedPartsManager {
  static const _selectedPartsKey = 'selected_parts';

  static Future<void> togglePart(
      Map<String, dynamic> part, int processId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final selectedParts = await _getSelectedPartsFromPrefs();

    final partWithProcessId = {
      ...part,
      'Process_ID': processId,
      'quantity': part['quantity'] ?? 1,
    };

    if (selectedParts.containsKey(processId)) {
      bool partExists = selectedParts[processId]!
          .any((existingPart) => existingPart['Part_ID'] == part['Part_ID']);

      if (partExists) {
        selectedParts[processId]!.removeWhere(
            (existingPart) => existingPart['Part_ID'] == part['Part_ID']);
        if (selectedParts[processId]!.isEmpty) {
          selectedParts.remove(processId);
        }
      } else {
        selectedParts[processId]!.add(partWithProcessId);
      }
    } else {
      selectedParts[processId] = [partWithProcessId];
    }

    // บันทึกข้อมูลที่อัปเดตไปยัง SharedPreferences
    await _saveSelectedPartsToPrefs(selectedParts);
  }

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

  static Future<void> updateQuantity(int processId, int partId, int newQuantity) async {
    final selectedParts = await _getSelectedPartsFromPrefs();

    if (selectedParts.containsKey(processId)) {
      for (var part in selectedParts[processId]!) {
        if (part['Part_ID'] == partId) {
          part['quantity'] = newQuantity;
          break;
        }
      }
    }

    // Save updated data to SharedPreferences
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
