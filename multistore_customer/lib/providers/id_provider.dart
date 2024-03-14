import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IdProvider extends ChangeNotifier {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  static String _customerId = '';

  String get getData {
    return _customerId;
  }

  setCustomerId(User user) async {
    SharedPreferences prefs = await _prefs;
    prefs
        .setString("customerid", user.uid)
        .whenComplete(() => _customerId = user.uid);
    print("customer id saved");
    notifyListeners();
  }

  clearCustomerId() async {
    SharedPreferences prefs = await _prefs;
    prefs.setString("customerid", '').whenComplete(() => _customerId = '');
    print("cleared customer id");
    notifyListeners();
  }

  Future<String> getFutureId() {
    return _prefs.then((SharedPreferences prefs) {
      return prefs.getString("customerid") ?? "";
    });
  }

  getDocId() async {
    await getFutureId().then((value) => _customerId = value);
    print("got customer id");
    notifyListeners();
  }
}
