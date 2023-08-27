import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AddGoalScreen extends StatefulWidget {
  const AddGoalScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddGoalScreen createState() => _AddGoalScreen();
}

class Entry {
  final String goalName;
  final int dateTime;
  final String goalType;

  const Entry({
    required this.goalName,
    required this.dateTime,
    required this.goalType,
  });

  Map<String, Object?> toMap() {
    return {
      'goalName': goalName,
      'dateTime': dateTime,
      'goalType': goalType,
    };
  }
}

class _AddGoalScreen extends State<AddGoalScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DateTime selectedDate = DateTime.now();
  String _setDate = '';
  String finalValue = '';
  bool _validationErrorBool = false;

  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(2013),
      lastDate: DateTime(2137),
    );

    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      _dateController.text = picked.toString(); // Update the text field
    }
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: '', child: Text('Select addiction')),
      const DropdownMenuItem(
          value: 'My addiction (other)', child: Text('My addiction (other)')),
      const DropdownMenuItem(value: 'Self-harm', child: Text('Self-harm')),
      const DropdownMenuItem(value: 'Coffee', child: Text('Coffee')),
      const DropdownMenuItem(
          value: 'Energy Drinks', child: Text('Energy Drinks')),
      const DropdownMenuItem(value: 'Smoking', child: Text('Smoking')),
      const DropdownMenuItem(value: 'Meds', child: Text('Meds')),
      const DropdownMenuItem(value: 'Pills', child: Text('Pills')),
      const DropdownMenuItem(value: 'Weed', child: Text('Weed')),
      const DropdownMenuItem(
          value: 'Other drugs...', child: Text('Other drugs...')),
      const DropdownMenuItem(value: 'Television', child: Text('Television')),
      const DropdownMenuItem(value: 'Video Games', child: Text('Video Games')),
      const DropdownMenuItem(value: 'Porn', child: Text('Porn')),
      const DropdownMenuItem(value: 'Facebook', child: Text('Facebook')),
      const DropdownMenuItem(value: 'Instagram', child: Text('Instagram')),
      const DropdownMenuItem(value: 'YouTube', child: Text('YouTube')),
      const DropdownMenuItem(value: 'TikTok', child: Text('TikTok')),
      const DropdownMenuItem(value: 'Meat', child: Text('Meat')),
      const DropdownMenuItem(value: 'Sugar', child: Text('Sugar')),
    ];
    return menuItems;
  }

  @override
  void dispose() {
    _goalController.dispose();
    super.dispose();
  }

  Future<void> _createTable(Database db, int version) async {
    await db.execute(
      'CREATE TABLE IF NOT EXISTS goals(id INTEGER PRIMARY KEY AUTOINCREMENT, goalName TEXT, dateTime INT, goalType TEXT)',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const SizedBox(height: 50),
          const Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: Text('Add a Goal', style: TextStyle(fontSize: 36)),
            ),
          ),
          const Text('Goal name:'),
          const SizedBox(height: 5),
          TextField(
              controller: _goalController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'e.g. nicotine addiction',
              )),
          const SizedBox(height: 50),
          const Text('Date (actual date if not selected):'),
          const SizedBox(height: 5),
          InkWell(
            onTap: () => _selectDate(context),
            child: Container(
              margin: const EdgeInsets.only(top: 30),
              alignment: Alignment.center,
              child: TextFormField(
                style: const TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
                enabled: false,
                keyboardType: TextInputType.text,
                controller: _dateController,
                onSaved: (String? value) {
                  _setDate = value ?? '';
                },
                decoration: const InputDecoration(
                  hintText: 'Date of start (e.g. today)',
                  disabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.only(top: 0.0),
                ),
              ),
            ),
          ),
          const SizedBox(height: 50),
          const Text('Goal type (addiction):'),
          const SizedBox(height: 5),
          DropdownButton(
              value: finalValue,
              items: dropdownItems,
              onChanged: (String? string) => {
                    setState(() {
                      finalValue = string!;
                    })
                  }),
          const SizedBox(height: 100),
          ElevatedButton(
            autofocus: _validationErrorBool = false,
            onPressed: () async {
              // Goal name
              if (_goalController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Goal name cannot be empty'),
                  ),
                );
                _validationErrorBool = true;
              }

              // Date
              debugPrint(selectedDate.toIso8601String());

              // Goal type
              if (finalValue.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Addiction cannot be empty'),
                  ),
                );
                _validationErrorBool = true;
              }

              if (!_validationErrorBool) {
                WidgetsFlutterBinding.ensureInitialized();
                final database = openDatabase(
                  join(await getDatabasesPath(), '_soberity_database.db'),
                  onCreate: _createTable,
                  version: 1,
                );

                final db = await database;

                Entry goal = Entry(
                  goalName: _goalController.text,
                  dateTime: selectedDate.millisecondsSinceEpoch.toInt(),
                  goalType: finalValue,
                );

                await db.insert(
                  'goals',
                  goal.toMap(),
                  conflictAlgorithm: ConflictAlgorithm.replace,
                );

                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              }
            },
            child: const Text('Done'),
          ),
          const SizedBox(height: 100),
        ]),
      ),
    );
  }
}
