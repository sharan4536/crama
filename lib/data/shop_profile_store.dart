import 'package:flutter/foundation.dart';

class ShopProfileStore extends ChangeNotifier {
  static final ShopProfileStore _instance = ShopProfileStore._();
  ShopProfileStore._();
  factory ShopProfileStore() => _instance;

  String? logoPath;
  String? shopName;
  String? gstin;
  String? street;
  String? city;
  String? state;
  String? pincode;
  String? contactPerson;
  String? mobile;
  String? email;

  void updateLogo(String? path) {
    logoPath = path;
    notifyListeners();
  }

  void updateShopDetails({
    String? name,
    String? gst,
    String? addr,
    String? cty,
    String? st,
    String? pin,
    String? contact,
    String? mob,
    String? mail,
  }) {
    if (name != null) shopName = name;
    if (gst != null) gstin = gst;
    if (addr != null) street = addr;
    if (cty != null) city = cty;
    if (st != null) state = st;
    if (pin != null) pincode = pin;
    if (contact != null) contactPerson = contact;
    if (mob != null) mobile = mob;
    if (mail != null) email = mail;
    notifyListeners();
  }
}
