import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../fab_botton/hawk_fab_menu.dart';
class CalculateEditScreenProvider extends ChangeNotifier {
  HawkFabMenuController hawkFabMenuController = HawkFabMenuController();
  // Define a map to hold TextEditingControllers for each field
  Map<String, TextEditingController> _textControllers = {};

  // Get or initialize the TextEditingController for a given label
  TextEditingController getController(String label, String initialValue) {
    if (!_textControllers.containsKey(label)) {
      _textControllers[label] = TextEditingController(text: initialValue); // Set the initial value
    }
    return _textControllers[label]!;
  }
// Public getter to access the _textControllers map
  Map<String, String> get textFields {
    return _textControllers.map((key, controller) {
      return MapEntry(key, controller.text);  // Return the label and the text value
    });
  }
  // Update the value in the controller
  void updateTextField(String label, String value) {
    if (_textControllers.containsKey(label)) {
      _textControllers[label]?.text = value;
      notifyListeners(); // Notify listeners to rebuild UI when value changes
    }
  }

  // Getter to retrieve the current value of the text field
  String getTextFieldValue(String label) {
    return _textControllers[label]?.text ?? '';
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

