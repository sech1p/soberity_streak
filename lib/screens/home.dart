import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:soberity_streak/screens/add_goal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Entry>> fetchGoals() async {
    final database = openDatabase(
      join(await getDatabasesPath(), '_soberity_database.db'),
    );

    final db = await database;

    try {
      final List<Map<String, dynamic>> maps = await db.query('goals');

      return List.generate(maps.length, (i) {
        return Entry(
          goalName: maps[i]['goalName'],
          dateTime: maps[i]['dateTime'],
          goalType: maps[i]['goalType'],
        );
      });
    } catch (e) {
      print('Error fetching "goals". Is database empty?\n$e');
      return [];
    }
  }

  Future<void> deleteEntry(String goalName) async {
    final database = openDatabase(
      join(await getDatabasesPath(), '_soberity_database.db'),
    );

    final db = await database;

    await db.delete(
      'goals',
      where: 'goalName = ?',
      whereArgs: [goalName],
    );
  }

  String calculateTimeDifference(int timestamp) {
    final entryDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final currentDate = DateTime.now();
    final difference = currentDate.difference(entryDate);

    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;
    final seconds = difference.inSeconds % 60;

    return '${difference.inDays} days, $hours h. $minutes m. $seconds s.';
  }

  Future<void> _refreshScreen() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshScreen,
        child: Column(
          children: <Widget>[
            Expanded(
              child: FutureBuilder<List<Entry>>(
                future: fetchGoals(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No goals available');
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final entry = snapshot.data![index];
                        return GestureDetector(
                          onDoubleTap: () {
                            deleteEntry(entry.goalName);
                          },
                          child: ListTile(
                            title: Text(entry.goalName),
                            subtitle: Text(
                                '${entry.goalType} | Free for ${calculateTimeDifference(entry.dateTime)}'),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddGoalScreen()),
                  );
                },
                child: const Text('+'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
