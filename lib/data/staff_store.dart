import 'package:flutter/foundation.dart';

class Staff {
  final String id;
  final String name;
  final String phone;
  final String role;
  final String salaryType;
  final String? photoPath;

  Staff({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
    required this.salaryType,
    this.photoPath,
  });
}

class StaffStore extends ChangeNotifier {
  static final StaffStore _instance = StaffStore._();
  StaffStore._();
  factory StaffStore() => _instance;

  final List<Staff> _staffMembers = [];

  List<Staff> get staffMembers => List.unmodifiable(_staffMembers);

  void add(Staff s) {
    _staffMembers.insert(0, s);
    notifyListeners();
  }

  void update(Staff updated) {
    final index = _staffMembers.indexWhere((s) => s.id == updated.id);
    if (index != -1) {
      _staffMembers[index] = updated;
      notifyListeners();
    }
  }

  void remove(String id) {
    _staffMembers.removeWhere((s) => s.id == id);
    notifyListeners();
  }
}
