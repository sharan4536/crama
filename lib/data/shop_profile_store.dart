import 'package:flutter/foundation.dart';

class ShopProfileStore extends ChangeNotifier {
  static final ShopProfileStore _instance = ShopProfileStore._();
  ShopProfileStore._();
  factory ShopProfileStore() => _instance;

  String? logoPath;

  void updateLogo(String? path) {
    logoPath = path;
    notifyListeners();
  }
}
