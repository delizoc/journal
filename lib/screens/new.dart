import 'package:flutter/material.dart';
import 'package:journal/models/journal_entry.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:journal/widgets/journal_drawer.dart';

class NewEntry extends StatefulWidget {
  const NewEntry({Key? key}) : super(key: key);

  @override
  State<NewEntry> createState() => _NewEntryState();
}

class _NewEntryState extends State<NewEntry>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text('New Journal Entry'),
      ),
      endDrawer: settingsDrawer(context),
      body: Center(child: NewEntryForm()),
    );
  }
}

class NewEntryForm extends StatefulWidget {
  const NewEntryForm({Key? key}) : super(key: key);

  @override
  State<NewEntryForm> createState() => _NewEntryFormState();
}

class _NewEntryFormState extends State<NewEntryForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final journalEntryFields = JournalEntryFields();

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Form(
        key: formKey,
        child: Column(
          children: [textFormFields(), buttonBar(context)],
        ),
      ),
    );
  }

  Column textFormFields() {
    return Column(
      children: [
        TextFormField(
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'Title', border: OutlineInputBorder()),
            validator: (value) {
              if (value!.isEmpty){
                return 'Please enter a title';
              }else{
                return null;
              }
            },
            onSaved: (value) {
              journalEntryFields.title = value!;
            }),
        TextFormField(
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'Body', border: OutlineInputBorder()),
            validator: (value) {
              if (value!.isEmpty){
                return 'Please enter a body';
              }else{
                return null;
              }
            },
            onSaved: (value) {
              journalEntryFields.body = value!;
            }),
        TextFormField(
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'Rating', border: OutlineInputBorder()),
            validator: (value) {
              if (value!.isEmpty){
                return 'Please enter a Rating';
              } else if (int.parse(value) < 1 || int.parse(value) > 4) {
                return 'Please enter a rating between 1 and 4';
              } else {
                return null;
              }
            },
            onSaved: (value) {
              journalEntryFields.rating = int.parse(value!);
              journalEntryFields.id = 0;
            })    
      ],
    );
  }

  Center buttonBar(BuildContext context){
    return Center(
      child: ButtonBar(mainAxisSize: MainAxisSize.min, children: [
        saveButton(context),
        cancelButton(context),
        clearButton(context)
      ]),
    );
  }

  Widget saveButton(BuildContext context){
    return ElevatedButton(
      onPressed: () async {
        DateTime now = DateTime.now();
        final DateFormat formatter = DateFormat('EEEE, MMMM d, y');
        String date = formatter.format(now);
        String sqlScript =
          await rootBundle.loadString('assets/schema_1.sql.txt');

        if (formKey.currentState!.validate()) {
          formKey.currentState?.save();

          final Database database = await openDatabase('journal.db', version: 1, onCreate: (Database db, int version) async {
              await db.execute(sqlScript);
          });
          await database.transaction((txn) async {
            await txn.rawInsert(
              'INSERT INTO journal_entries(title, body, rating, date) VALUES(?, ?, ?, ?);',
              [
                journalEntryFields.title,
                journalEntryFields.body,
                journalEntryFields.rating,
                date
              ]);
          });
          await database.close();
          Navigator.pushNamed(context, '/');
        }
    }, 
    child: Text('Save Entry'));
  }

  Widget cancelButton(BuildContext context) {
    return ElevatedButton(onPressed: () {
      Navigator.of(context).pop();
    }, 
    child: Text('Cancel'));
  }

  Widget clearButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await deleteDatabase('journal.db');
        Navigator.pushNamed(context, '/');
      },
      child: Text('Clear'));
  }
}
