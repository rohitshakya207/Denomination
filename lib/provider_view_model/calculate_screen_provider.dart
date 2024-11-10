import 'package:flutter/material.dart';

import '../fab_botton/hawk_fab_menu.dart';
class CalculateScreenProvider extends ChangeNotifier {
  HawkFabMenuController hawkFabMenuController = HawkFabMenuController();
  Map<String, TextEditingController> _textControllers = {};


  // Get or initialize the TextEditingController for a given label
  TextEditingController getController(String label, {String initialValue = ''}) {
    if (!_textControllers.containsKey(label)) {
      // Initialize the controller with an initial value if provided
      _textControllers[label] = TextEditingController(text: initialValue);
    }
    return _textControllers[label]!;
  }
  // Public getter to access the _textControllers map
  Map<String, String> get textFields {
    return _textControllers.map((key, controller) {
      return MapEntry(key, controller.text);  // Return the label and the text value
    });
  }
  // Get the value from the controller
  String getTextFieldValue(String value) {
    return _textControllers[value]?.text ?? '';
  }

  // Update the value in the controller
  void updateTextField(String label, String value) {
    if (_textControllers.containsKey(label)) {
      _textControllers[label]?.text = value;
      notifyListeners();
    }
  }
  // Method to clear all fields
  void clearAllFields() {
    for (var controller in _textControllers.values) {
      controller.clear();
    }
    notifyListeners();
  }
  String _selectedValue = 'General'; // default value for dropdown
  String _remark = '';

  String get selectedValue => _selectedValue;
  String get remark => _remark;

  // Setter for dropdown value
  void setSelectedValue(String value) {
    _selectedValue = value;
    notifyListeners();
  }

  // Setter for remark text field
  void setRemark(String value) {
    _remark = value;
    notifyListeners();
  }
  @override
  void dispose() {
    for (var controller in _textControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
