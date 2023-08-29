import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../utils/list.dart';

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
  bool isProperlyValidated = false;

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
            autofocus: isProperlyValidated = false,
            onPressed: () async {
              // Goal name
              if (_goalController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Goal name cannot be empty'),
                  ),
                );
                isProperlyValidated = true;
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
                isProperlyValidated = true;
              }

              if (!isProperlyValidated) {
                WidgetsFlutterBinding.ensureInitialized();
                final database = openDatabase(
                  join(await getDatabasesPath(), 'soberity_database.db'),
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
