import 'package:flutter/foundation.dart';

class Staff {
  final String id;
  final String name;
  final String phone;
  final String role;
  final String salaryType;
  final double hourlyRate;
  final String? photoPath;

  Staff({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
    required this.salaryType,
    this.hourlyRate = 0.0,
    this.photoPath,
  });
}

class StaffStore extends ChangeNotifier {
  static final StaffStore _instance = StaffStore._();
  StaffStore._();
  factory StaffStore() => _instance;

  final List<Staff> _staffMembers = [
    Staff(
      id: 'staff-1',
      name: 'Sarah Jenkins',
      phone: '+1 555-0198',
      role: 'Sales Associate',
      salaryType: 'Hourly',
      hourlyRate: 15.0,
      photoPath: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBMNWtbBzpzE8_bTwKvHYVlNVGdbZgBZ_FyQhc1A0WmQWpMjHjwlL9CwtY__PUfRvSQ-h8obbh-_oBa0BAgdzZSXZ-CAfBF6ghyElkqzGrdnKbvpN3c6kZca9YP7MDsPfhQ1nEE8vH9EzrZXFUByHgXCQ638nZbxfXfefZSrPqK2IDpcc8VG9zwM_MFMktAqitYwE1namKRHr58iQW24oXAlFWxXZZOs9LACl3X0vf4L-ra1ixV5rIdqxbTjXnKCl09Cjw9cB9R7K15',
    ),
    Staff(
      id: 'staff-2',
      name: 'Mike Ross',
      phone: '+1 555-0123',
      role: 'Store Manager',
      salaryType: 'Hourly',
      hourlyRate: 20.0,
      photoPath: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCj1NpY7hQM5ozJzysnRkR6V_8S8hDrWlN0jICwlcwhQ-vxzSQXYoEBOZAsBYI1MV2vJLZCWN4VSY3huIxbZ2tK2rIA8-fS4SR-HCJtHxKxsc4NLZkdHyiQzQyevxcUxvp0x5ipPiS5DbcYLCCUCQ-eNCnmCqfX890qMuhASksVPatDMO2QpkGQgyVa0iPwAd5P8bMWY8mlybnG5MdlVAySzWBkIkjgKCQ7kKetzcShzPdukEEKSavdqcNgODRshhwuNqjFRww5T9x3',
    ),
    Staff(
      id: 'staff-3',
      name: 'Jessica Pearson',
      phone: '+1 555-0456',
      role: 'Inventory Lead',
      salaryType: 'Hourly',
      hourlyRate: 18.0,
      photoPath: 'https://lh3.googleusercontent.com/aida-public/AB6AXuA-j3K-3vZEk6tQ-NWj2q29yw5rJDL7u01f7TuVW1BWSiwLSo0a7NSsWa2PIpIOJZEjUg-T-QWe90SfVjK2DqpafwRx5y_l9dwkvAzA47lHZJ94xkpy6Si4n9LG2QyCeJ3CZqzIpKxw8-sTV-awODQjxxa1qq7PL7godnHmiaQ4LRYHA5SodGHi1loRDRZAC_7ALq6vp09lQtTIXiTbGzGWlmZRUdrooFwMQ53LQ8ocjP39oobiOlQfsuzKyWWkuPr-ICBt1fJsJg5f',
    ),
    Staff(
      id: 'staff-4',
      name: 'Alex Wong',
      phone: '+1 555-0789',
      role: 'Intern',
      salaryType: 'Hourly',
      hourlyRate: 12.5,
      photoPath: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCIIT1Xoo8r2dEAMA4JejCU3QBRdDPtqAa2fnF2UKUXHhsDz6qQWHkxDp_yW4e49xrjLWrlRA3-aY1xDC9Qey1pcBrHJMnErGC_3UJqMaGhqD3rGYQKkU3inuowk7cdzCrrn4dibtz8MehjxZ1bzm8P3xtd_eYoG9CLMWjF2AU0b-24u5UokOK60jRsz5XLexF9jSggQgJZPUP9myKwReY-mIg4GMOFMhFmZPz54KLL3Jej4576ndxO9sNCyJMihF3o6YcmwGm5rE21',
    ),
  ];

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
