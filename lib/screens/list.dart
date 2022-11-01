import 'package:flutter/material.dart';
import 'package:journal/screens/new.dart';
import 'package:journal/widgets/journal_drawer.dart';
import 'package:journal/screens/welcome.dart';
import 'package:journal/screens/new.dart';
import 'package:journal/models/journal_entry.dart';
import 'package:journal/screens/view.dart';
import 'package:sqflite/sqflite.dart';
import 'package:journal/models/journal.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:journal/models/journal.dart';
import 'dart:developer';

class JournalEntryListScreen extends StatefulWidget {
  const JournalEntryListScreen({Key? key}) : super(key: key);

  @override
  State<JournalEntryListScreen> createState() => _JournalEntryListScreenState();
}

class _JournalEntryListScreenState extends State<JournalEntryListScreen> {
  List<JournalEntryFields> JournalRecordsList = [];
  @override
  void initState() {
    super.initState();
    loadJournal();
  }

  void loadJournal() async {
    String sqlScript = await rootBundle.loadString('assets/schema_1.sql.txt');
    final Database database = await openDatabase('journal.db', version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(sqlScript);
    });
    List<Map> journalRecords =
        await database.rawQuery('SELECT * FROM journal_entries;');
    List<JournalEntryFields> tempJournalRecordsList =
        journalRecords.map((record) {
      return JournalEntryFields(
        title: record['title'],
        body: record['body'],
        rating: record['rating'],
        date: record['date'],
      );
    }).toList();
    JournalRecordsList = tempJournalRecordsList;
    setState(() {
      JournalRecordsList = JournalRecordsList;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (JournalRecordsList.isEmpty) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Welcome'),
          ),
          endDrawer: settingsDrawer(context),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/newEntry');
            },
            child: const Icon(Icons.add),
          ),
          body: const Center(
              child: Icon(
            Icons.book,
            size: 100.0,
          )));
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text('Journal Entries'),
          ),
          endDrawer: settingsDrawer(context),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/newEntry');
            },
            child: const Icon(Icons.add),
          ),
          body: Container(
              constraints:
                  BoxConstraints(maxWidth: 400, maxHeight: 300, minWidth: 400),
              child: LayoutBuilder(builder: (context, constraints) {
                return MediaQuery.of(context).orientation ==
                        Orientation.landscape
                    ? HorizontalLayout(JournalRecordsList: JournalRecordsList)
                    : VerticalLayout(JournalRecordsList: JournalRecordsList);
              })));
    }
  }
}

class VerticalLayout extends StatelessWidget {
  const VerticalLayout({
    Key? key,
    required this.JournalRecordsList,
  }) : super(key: key);

  final List<JournalEntryFields> JournalRecordsList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: JournalRecordsList.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () => Navigator.pushNamed(context, '/viewEntry',
                arguments: JournalRecordsList[index]),
            trailing: Icon(Icons.more_horiz),
            title: Text(
              '${JournalRecordsList[index].title}',
            ),
            subtitle: Text('${JournalRecordsList[index].date}'),
          );
        });
  }
}

class HorizontalLayout extends StatelessWidget {
  const HorizontalLayout({
    Key? key,
    required this.JournalRecordsList,
  }) : super(key: key);

  final List<JournalEntryFields> JournalRecordsList;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: ListView.builder(
                  itemCount: JournalRecordsList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        '${JournalRecordsList[index].title}',
                      ),
                      subtitle: Text('${JournalRecordsList[index].date}'),
                    );
                  }),
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.only(top: 0.0, left: 10.0),
              child: ListView.builder(
                itemCount: JournalRecordsList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${JournalRecordsList[index].title}'
                    ),
                    subtitle: Text('${JournalRecordsList[index].body}'),
                  );
                }),
            ),
          ),
        ),
      ],
    );
  }
}
