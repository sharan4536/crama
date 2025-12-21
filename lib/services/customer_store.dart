import 'package:flutter/foundation.dart';
import '../models/customer.dart';

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

  void update(Customer c) {
    final index = _customers.indexWhere((existing) => existing.id == c.id);
    if (index != -1) {
      _customers[index] = c;
      notifyListeners();
    }
  }

  void remove(String id) {
    _customers.removeWhere((c) => c.id == id);
    notifyListeners();
  }
}

