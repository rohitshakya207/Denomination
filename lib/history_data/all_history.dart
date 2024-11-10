import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:share_plus/share_plus.dart';
import '../data_helper_sqlite/data_helper.dart';
import '../edit_data_update/edit_data_update.dart';
import '../models/data_model.dart'; // Import Slidable package

class DataListScreen extends StatefulWidget {
  @override
  _DataListScreenState createState() => _DataListScreenState();
}

class _DataListScreenState extends State<DataListScreen> {
  late Future<List<CalCulateDataModel>> _historyData;

  @override
  void initState() {
    super.initState();
    _historyData = DatabaseHelper.instance.fetchAllData(); // Initial data load
  }

  // Function to refresh the list after deletion
  Future<void> _deleteData(int id) async {
    print(id); // Print the ID
    await DatabaseHelper.instance.deleteData(id); // Delete data
    setState(() {
      _historyData = DatabaseHelper.instance.fetchAllData(); // Reload the data
    });
  }


  // Method to format the data for sharing
  String _formatDataForSharing(CalCulateDataModel data) {
    return '''
Denomination
${data.categery}
Denomination
${data.date} ${data.recordtime}
${data.remark}

--------------------------------
Rupee x Counts = Total
₹ 2,000 x ${data.multi2000} = ₹ ${data.amount2000}
₹ 500 x ${data.multi500}= ₹ ${data.amount500}
₹ 200 x ${data.multi2000} = ₹ ${data.amount200}
₹ 100 x ${data.multi100} = ₹ ${data.amount100}
₹ 50 x ${data.multi50} = ₹ ${data.amount50}
₹ 20 x ${data.multi20} = ₹ ${data.amount20}
₹ 10 x ${data.multi10} = ₹ ${data.amount10}
₹ 5 x ${data.multi5}= ₹ ${data.amount5}
₹ 2 x ${data.multi2} = ₹ ${data.amount2}
₹ 1 x ${data.multi1}= ₹ ${data.amount1}
--------------------------------

Total Counts:
48
Grand Total Amount:
₹ ${data.finalalltotal.toString()}
${data.wordtotal.toString()} only/-
    ''';
  }

  // Method to share the formatted data
  void _shareData(CalCulateDataModel data) {
    final formattedData = _formatDataForSharing(data);
    print(formattedData);
    Share.share(formattedData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'History',
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        backgroundColor: Colors.black, // Keep the app bar background color as black
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white, // Set the arrow icon color to white
          ),
          onPressed: () {
            Navigator.of(context).pop(); // Close the screen when the back arrow is pressed
          },
        ),
      ),
      body: FutureBuilder<List<CalCulateDataModel>>(
        future: _historyData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No history data found'));
          }

          final historydata = snapshot.data!;

          return ListView.builder(
            itemCount: historydata.length,
            itemBuilder: (context, index) {
              final histor_index = historydata[index];
              return Slidable(
                key: ValueKey(histor_index.id), // Use unique ID for the key

                // Start Action Pane
                startActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  dismissible: DismissiblePane(onDismissed: () {}),
                  children: [
                    SlidableAction(
                      onPressed: (context) async {
                        await _deleteData(histor_index.id!); // Delete and refresh
                      },
                      backgroundColor: Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                    SlidableAction(
                      onPressed: (context) {
                        // Handle Edit
                        print(histor_index.id);
                        print(histor_index.multi2000);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>TextFieldEditScreen(dataModel: histor_index,)));
                      },
                      backgroundColor: Color(0xFF21B7CA),
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                      label: 'Edit',
                    ),
                    SlidableAction(
                      onPressed: (context) {
                        // Handle Share
                        _shareData(histor_index);
                      },
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      icon: Icons.share,
                      label: 'Share',
                    ),
                  ],
                ),

                child: Card(
                  color: Colors.grey[900], // Dark background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left Column (Category, Amount, Remark)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              histor_index.categery,
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '₹ ${histor_index.finalalltotal.toString()}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Colors.blue[400],
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              histor_index.remark,
                              style: TextStyle(
                                color: Colors.blue[400],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),

                        // Right Column (Date, Time)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              histor_index.date,
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              histor_index.recordtime,
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
