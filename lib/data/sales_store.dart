import 'package:flutter/foundation.dart';

class SalesStore extends ChangeNotifier {
  static final SalesStore _instance = SalesStore._();
  SalesStore._();
  factory SalesStore() => _instance;

  double _totalRevenueToday = 0.0;
  int _ordersToday = 0;

  double get totalRevenueToday => _totalRevenueToday;
  int get ordersToday => _ordersToday;

  void addSale(double amount) {
    _totalRevenueToday += amount;
    _ordersToday += 1;
    notifyListeners();
  }

  void reset() {
    _totalRevenueToday = 0.0;
    _ordersToday = 0;
    notifyListeners();
  }
}
