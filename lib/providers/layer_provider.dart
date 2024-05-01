import 'package:flutter/material.dart';

class LayerTypeProvider with ChangeNotifier {
  String _selectedLayerType = 'Precipitation';

  String get selectedLayerType => _selectedLayerType;

  void update(String newValue) {
    _selectedLayerType = newValue;
    notifyListeners();
  }
}