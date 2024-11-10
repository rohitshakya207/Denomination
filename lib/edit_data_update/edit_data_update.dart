import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../data_helper_sqlite/data_helper.dart';
import '../fab_botton/hawk_fab_menu.dart';
import '../history_data/all_history.dart';
import '../models/data_model.dart';
import '../number_to_word/number_to_words.dart';

import '../provider_view_model/update_screen_controller.dart';
import '../success_dialog/succes_dialog.dart';
class TextFieldEditScreen extends StatefulWidget {
   CalCulateDataModel dataModel;
  TextFieldEditScreen({super.key, required this.dataModel});

  @override
  _TextFieldEditScreenState createState() => _TextFieldEditScreenState();
}

class _TextFieldEditScreenState extends State<TextFieldEditScreen> {

  @override
  Widget build(BuildContext context) {
    var calculateProvider = Provider.of<CalculateEditScreenProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/currency_banner.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [

                Positioned(
                  bottom: 20,
                  left: 10,
                  child: Consumer<CalculateEditScreenProvider>(
                    builder: (context, provider, child) {
                      int totalAmount = _calculateTotal(provider.textFields);
                      String formattedTotal = NumberFormat('#,###').format(totalAmount);
                      NumberToWord numberToWord = NumberToWord();
                      String totalInWords = numberToWord.convert(Locale.en_ind, totalAmount.toInt());

                      return totalAmount > 0
                          ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total Amount",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          Text(
                            ' ₹ ${formattedTotal}',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'In Words: $totalInWords Only /-',
                            style: TextStyle(fontSize: 13, color: Colors.white),
                          ),
                        ],
                      )
                          : Text("Denomination", style: TextStyle(fontSize: 18, color: Colors.white));
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          // For each denomination, use the TextEditingController to bind to the TextField
          buildTextField(context, '2000', widget.dataModel.multi2000.toString(), calculateProvider),
          SizedBox(height: 8),
          buildTextField(context, '500', widget.dataModel.multi500.toString(), calculateProvider),
          SizedBox(height: 8),
          buildTextField(context, '200', widget.dataModel.multi200.toString(), calculateProvider),
          SizedBox(height: 8),
          buildTextField(context, '100', widget.dataModel.multi100.toString(), calculateProvider),
          SizedBox(height: 8),
          buildTextField(context, '50', widget.dataModel.multi50.toString(), calculateProvider),
          SizedBox(height: 8),
          buildTextField(context, '20', widget.dataModel.multi20.toString(), calculateProvider),
          SizedBox(height: 8),
          buildTextField(context, '10', widget.dataModel.multi10.toString(), calculateProvider),
          SizedBox(height: 8),
          buildTextField(context, '5', widget.dataModel.multi5.toString(), calculateProvider),
          SizedBox(height: 8),
          buildTextField(context, '2', widget.dataModel.multi2.toString(), calculateProvider),
          SizedBox(height: 8),
          buildTextField(context, '1', widget.dataModel.multi1.toString(), calculateProvider),
          SizedBox(height: 20),
        ],
      ),
        floatingActionButton:HawkFabMenu(
          icon: AnimatedIcons.menu_close,
          fabColor: Colors.blue,
          iconColor: Colors.white,
          openIcon:Icons.bolt,
          closeIcon: Icons.bolt,
          hawkFabMenuController: calculateProvider.hawkFabMenuController,
          items: [
            HawkFabMenuItem(
              label: 'Save',
              ontap: () {
                _openDialogSaveData(context, calculateProvider);
                // _confirmationDialog(context, calculateprovider);
              },
              icon: const Icon(Icons.download_rounded,color: Colors.white,),
              color: Color(0xFF797777),
              labelColor:Colors.white,
              labelBackgroundColor: Color(0xFF797777),
            ),
            HawkFabMenuItem(
              label: 'Clear',
              ontap: () {
                _showClearAllDialog(context,calculateProvider);
              },
              icon: const Icon(Icons.change_circle_outlined,color: Colors.white,),
              color: Color(0xFF797777),
              labelColor:Colors.white,
              labelBackgroundColor: Color(0xFF797777),
            ),
          ],
        )
    );
  }

  // Function to open the dialog
  void _openDialogSaveData(BuildContext context1, CalculateEditScreenProvider calculateScreenProvider) {
    showDialog(
      context: context1,
      useSafeArea: true,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xFF262222),
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5), // Apply a border radius of 5 to the dialog
          ),
          content: Consumer<CalculateEditScreenProvider>(
            builder: (context, provider, child) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(left: 6,right: 6), // Add 6 margin on left and right
                  child: Container(
                    height: 270,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Close button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context1).pop();
                              },
                              child: Icon(Icons.close, color: Colors.red),
                            ),
                          ],
                        ),
                        // Dropdown
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0xFF797777), // Background color of the dropdown container
                            borderRadius: BorderRadius.circular(5), // Round the corners
                            border: Border.all(
                              color: Colors.blue, // Border color
                              width: 1, // Border width
                            ),
                          ),
                          child: DropdownButton<String>(
                            value: provider.selectedValue,
                            elevation: 0,
                            isExpanded: true,
                            underline: SizedBox(), // Remove the default underline
                            style: TextStyle(color: Colors.white), // Text color inside dropdown
                            dropdownColor: Colors.black, // Set the dropdown menu's background color
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                provider.setSelectedValue(newValue);
                              }
                            },
                            items: ['General', 'Normal']
                                .map((value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(color: Colors.white),
                              ),
                            ))
                                .toList(),
                          ),
                        ),

                        SizedBox(height: 6),
                        // Remark TextField
                        TextField(
                          onChanged: (value) {
                            provider.setRemark(value);
                          },
                          style: TextStyle(color: Colors.white,fontSize: 15),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xFF797777),
                            hintText: "Fill your remark(if any)",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12), borderSide: BorderSide(
                              color: Colors.blue,
                              width: 1,
                            ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.blueAccent,
                                width: 1,
                              ),
                            ),
                            hintStyle: TextStyle(color: Colors.white,fontSize: 11),
                            labelStyle: TextStyle(color: Colors.white),),
                          maxLines: 2,
                        ),
                        SizedBox(height: 6),
                        TextButton(
                          onPressed: () {
                            print("click");
                            _confirmationDialog(context1, calculateScreenProvider,context);

                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24), // Add padding to the button
                            decoration: BoxDecoration(
                              color:Color(0xF94F4E4E), // Background color of the button
                              borderRadius: BorderRadius.circular(10), // Rounded corners with a 30px radius
                            ),
                            child: Text(
                              'Submit',
                              style: TextStyle(color: Colors.white), // Set button text color to white
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
  void _confirmationDialog(BuildContext context,CalculateEditScreenProvider calculateScreenProvider,BuildContext context1) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
          ),
          title: const Text(
            "Confirmation",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: const Text("Are you sure?"),
          actions: <Widget>[
            // No Button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: const Text(
                "No",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            ),
            // Yes Button
            TextButton(
              onPressed: () {
                saveData(calculateScreenProvider,context);
                Navigator.of(context).pop();
                Navigator.of(context1).pop();
                Navigator.of(context).pop();// Dismiss the dialog
              },
              child: const Text(
                "Yes",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  Future<void> saveData(CalculateEditScreenProvider calculateScreenProvider,BuildContext context) async {
    CalCulateDataModel savedData = _gatherSavedData(calculateScreenProvider);
    print(savedData.date);
    print(savedData.recordtime);
    // Insert the data into the database
    int result = await DatabaseHelper.instance.updateData(savedData);
    if (result > 0) {
      print("Data saved successfully with ID: $result");
      SuccessDialog.show(context, "Data saved successfully!");
      calculateScreenProvider.clearAllFields();
    } else {
      print("Failed to save data");
    }
  }
  CalCulateDataModel _gatherSavedData(CalculateEditScreenProvider provider) {
    int amount2000 = int.tryParse(provider.getTextFieldValue('2000')) ?? 0;
    int multi2000 = int.tryParse(provider.getController('2000','0').text) ?? 1;
    int amounttotal2000 = amount2000 * 2000;
    print("--------${amounttotal2000}");

    int amount500 = int.tryParse(provider.getTextFieldValue('500')) ?? 0;
    int multi500 = int.tryParse(provider.getController('500','0').text) ?? 1;
    int amounttotal500 = amount500 * 500;

    int amount200 = int.tryParse(provider.getTextFieldValue('200')) ?? 0;
    int multi200 = int.tryParse(provider.getController('200','0').text) ?? 1;
    int amounttotal200 = amount200 * 200;

    int amount100 = int.tryParse(provider.getTextFieldValue('100')) ?? 0;
    int multi100 = int.tryParse(provider.getController('100','0').text) ?? 1;
    int amounttotal100 = amount100 * 100;

    int amount50 = int.tryParse(provider.getTextFieldValue('50')) ?? 0;
    int multi50 = int.tryParse(provider.getController('50','0').text) ?? 1;
    int amounttotal50 = amount50 * 50;

    int amount20 = int.tryParse(provider.getTextFieldValue('20')) ?? 0;
    int multi20 = int.tryParse(provider.getController('20','0').text) ?? 1;
    int amounttotal20 = amount20 * 20;

    int amount10 = int.tryParse(provider.getTextFieldValue('10')) ?? 0;
    int multi10 = int.tryParse(provider.getController('10','0').text) ?? 1;
    int amounttotal10 = amount10 * 10;

    int amount5 = int.tryParse(provider.getTextFieldValue('5')) ?? 0;
    int multi5 = int.tryParse(provider.getController('5','0').text) ?? 1;
    int amounttotal5 = amount5 * 5;

    int amount2 = int.tryParse(provider.getTextFieldValue('2')) ?? 0;
    int multi2 = int.tryParse(provider.getController('2','0').text) ?? 1;
    int amounttotal2 = amount2 * 2;

    int amount1 = int.tryParse(provider.getTextFieldValue('1')) ?? 0;
    int multi1 = int.tryParse(provider.getController('1','0').text) ?? 1;
    int amounttotal1 = amount1 * 1;
    DateTime now = DateTime.now();

    // Format for "Apr 03, 2024"
    String formattedDate1 = DateFormat('MMM dd, yyyy').format(now);

    // Format for "03:40 PM"
    String formattedTime = DateFormat('hh:mm a').format(now);
    // Calculate the total
    int totalAmount = _calculateTotal(provider.textFields);
    String formattedTotal = NumberFormat('#,###').format(totalAmount);
    NumberToWord numberToWord = NumberToWord();
    String totalInWords = numberToWord.convert(Locale.en_ind, totalAmount.toInt());


    // Create and return a SavedData object
    return CalCulateDataModel(
      recordtime: formattedTime,
      id: widget.dataModel.id,
      date: formattedDate1,
      remark: provider.remark,
      categery: provider.selectedValue,
      wordtotal:totalInWords,
      amount2000: amounttotal2000,
      multi2000: multi2000,
      amount500: amounttotal500,
      multi500: multi500,
      amount200: amounttotal200,
      multi200: multi200,
      amount100: amounttotal100,
      multi100: multi100,
      amount50: amounttotal50,
      multi50: multi50,
      amount20: amounttotal20,
      multi20: multi20,
      amount10: amounttotal10,
      multi10: multi10,
      amount5: amounttotal5,
      multi5: multi5,
      amount2: amounttotal2,
      multi2: multi2,
      amount1: amounttotal1,
      multi1: multi1,
      finalalltotal: totalAmount,
    );
  }
// Function to show the clear all dialog
  void _showClearAllDialog(BuildContext context, CalculateEditScreenProvider provider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Clear All Fields?"),
          content: Text("Are you sure you want to clear all the text fields?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                provider.clearAllFields(); // Add this method to the provider to reset fields
                Navigator.of(context).pop();
              },
              child: Text("Clear All"),
            ),
          ],
        );
      },
    );
  }

// Function to calculate the total from all text fields
  int _calculateTotal(Map<String, String> textFields) {
    int total = 0;

    // Iterate over all fields and calculate the total
    textFields.forEach((key, value) {
      // Extract the multiplier from the key (e.g., "2000x" -> 2000)
      int multiplier = int.tryParse(key.replaceAll(RegExp(r'\D'), '')) ?? 1;

      // Get the entered value, default to 0 if invalid
      int amount = int.tryParse(value) ?? 0;

      // Multiply and add to total
      total += amount * multiplier;
    });

    return total;
  }
  // Helper method to build the text field
  Widget buildTextField(BuildContext context, String label, String initialValue, CalculateEditScreenProvider provider) {
    // Get or create the controller and initialize it with the initial value
    provider.getController(label, initialValue);

    return Row(
      children: [
        Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    child: Text(
                      '₹ $label', // Adding the rupee symbol before the value
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 16,color: Colors.white), // You can customize the text style as needed
                    ),
                  ),
                ),
                Text("x",style: TextStyle(fontSize: 16,color: Colors.white))
              ],
            )),
        Expanded(
          flex: 5,
          child: TextField(
            controller: provider.getController(label, initialValue), // Link to controller from provider
            keyboardType: TextInputType.number,
            style: TextStyle(color: Colors.white),// Ensures only numeric input is allowed
            decoration: InputDecoration(
              filled: true, // Ensures background color is applied
              fillColor: Color(0xFF797777), // Background color of the TextField
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12), // Rounded corners for the border
                borderSide: BorderSide(
                  color: Colors.blue, // Border color
                  width: 1, // Border width
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12), // Rounded corners for focused border
                borderSide: BorderSide(
                  color: Colors.blueAccent, // Focused border color
                  width: 1, // Focused border width
                ),
              ),
              suffixIcon: provider.getTextFieldValue(label).isNotEmpty
                  ? GestureDetector(
                onTap: () {
                  // This is the action when the clear button is tapped
                  provider.updateTextField(label, ''); // Clears the text field
                },
                child: Container(
                  width: 16, // Size of the circular clear button
                  height: 16,
                  margin: EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                    color: Colors.grey[300], // Background color of the circle
                    shape: BoxShape.circle, // Makes it circular
                  ),
                  child: Icon(
                    Icons.close,
                    size: 18, // Icon size inside the circle
                    color: Colors.black, // Icon color
                  ),
                ),
              )
                  : null, // Clear button only appears if text is not empty
            ),
            onChanged: (value) {
              // This is called when the user types something
              provider.updateTextField(label, value); // Updates the value in the provider
            },
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: Text(
            "= ${_calculateAmount(provider.getTextFieldValue(label), int.tryParse(label.replaceAll(RegExp(r'\D'), '')) ?? 1)}",
            style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
          ),
        ),
      ],
    );

  }

  // Helper function to calculate the amount based on the multiplier
  String _calculateAmount(String value, int multiplier) {
    try {
      // Parse the value as a double
      double amount = double.tryParse(value) ?? 0;

      // Multiply the value by the multiplier
      double result = amount * multiplier;

      // Format the result with commas (thousands separators)
      final formattedAmount = NumberFormat('#,##0', 'en_US').format(result);

      return "₹ $formattedAmount";  // Return formatted result with currency symbol
    } catch (e) {
      return "₹ 0";  // Default if parsing fails
    }
  }
}
