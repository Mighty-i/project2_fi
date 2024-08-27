// TODO Implement this library.
// selected_parts.dart
import 'dart:convert';

// class SelectedPartsManager {
//   static final Map<int, List<Map<String, dynamic>>> _selectedParts = {};

//   static void addPart(Map<String, dynamic> part, int index, int processId) {
//     final partWithProcessId = {...part, 'Process_ID': processId};
//     if (_selectedParts.containsKey(index)) {
//       _selectedParts[index]!.add(partWithProcessId);
//     } else {
//       _selectedParts[index] = [partWithProcessId];
//     }
//   }

//   static void clear() {
//     _selectedParts.clear();
//   }

//   static bool hasData() {
//     return _selectedParts.isNotEmpty;
//   }

//   static String toJson() {
//     // ตรวจสอบเนื้อหาของ _selectedParts ก่อนแปลง
//     print(_selectedParts);

//     // แปลงข้อมูลเป็น JSON
//     return jsonEncode(
//         _selectedParts.map((key, value) => MapEntry(key.toString(), value)));
//   }

//   static void printSelectedParts() {
//     print(_selectedParts);
//   }
// }
class SelectedPartsManager {
  static final Map<int, List<Map<String, dynamic>>> _selectedParts = {};

  static void addPart(Map<String, dynamic> part, int index, int processId) {
    final partWithProcessId = {
      ...part,
      'Process_ID': processId,
      'index': index, // กำหนดค่า index เมื่อเพิ่มอะไหล่
    };
    if (_selectedParts.containsKey(index)) {
      _selectedParts[index]!.add(partWithProcessId);
    } else {
      _selectedParts[index] = [partWithProcessId];
    }
  }

  // ฟังก์ชันในการลบอะไหล่จาก _selectedParts
  static void removePart(int index, int partIndex) {
    if (_selectedParts.containsKey(index)) {
      _selectedParts[index]!.removeAt(partIndex);
      // ถ้ารายการใน index นั้น ๆ ไม่มีเหลือแล้ว ให้ลบ key ทิ้ง
      if (_selectedParts[index]!.isEmpty) {
        _selectedParts.remove(index);
      }
    }
  }

  static List<Map<String, dynamic>> getSelectedParts() {
    return _selectedParts.values.expand((parts) => parts).toList();
  }

  static void clearPartsForIndex(int index) {
    _selectedParts.remove(index);
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
