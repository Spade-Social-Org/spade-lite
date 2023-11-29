import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final discoverService = ChangeNotifierProvider((ref) => DiscoverService());

class DiscoverService extends ChangeNotifier {
  String _selectedIndex = 'all';

  String _cardType = "default";

  get cardType => _cardType;

  get selectedIndex => _selectedIndex;

  void updateIndex(String newIndex) {
    _selectedIndex = newIndex;
    _cardType = "default";
    notifyListeners();
  }

  void gotoNext(String name) {
    _cardType = name;
    notifyListeners();
  }

  void goBack() {
    if (_cardType == 'holder') {
      _cardType = "default";

      notifyListeners();
    } else {
      if (_cardType == 'analysis') {
        _cardType = "default";

        notifyListeners();
      } else {
        _cardType = 'holder';
        notifyListeners();
      }
    }
  }

  bool _isModalVisible = false;

  bool get isModalVisible => _isModalVisible;

  void openModal() {
    _isModalVisible = true;
    notifyListeners();
  }

  void closeModal() {
    _isModalVisible = false;
    notifyListeners();
  }
}
