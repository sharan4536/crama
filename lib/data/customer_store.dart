import 'package:flutter/foundation.dart';

class Customer {
  final String id;
  String name;
  String phone;
  String? photoPath;
  double? chest;
  double? waist;
  double? hip;
  double? shoulder;
  double? sleeveLength;
  double? neck;
  double? blouseLength;
  String? notes;
  List<String> styles;

  Customer({
    required this.id,
    required this.name,
    required this.phone,
    this.photoPath,
    this.chest,
    this.waist,
    this.hip,
    this.shoulder,
    this.sleeveLength,
    this.neck,
    this.blouseLength,
    this.notes,
    this.styles = const [],
  });
}

class CustomerStore extends ChangeNotifier {
  static final CustomerStore _instance = CustomerStore._();
  CustomerStore._();
  factory CustomerStore() => _instance;

  final List<Customer> _customers = [];

  List<Customer> get customers => List.unmodifiable(_customers);

  Customer? findByPhone(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'\s|-'), '');
    for (final c in _customers) {
      if (c.phone.replaceAll(RegExp(r'\s|-'), '') == cleaned) {
        return c;
      }
    }
    return null;
  }

  void add(Customer c) {
    _customers.insert(0, c);
    notifyListeners();
  }

  void remove(String id) {
    _customers.removeWhere((c) => c.id == id);
    notifyListeners();
  }
}
