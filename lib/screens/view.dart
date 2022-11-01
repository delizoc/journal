import 'package:flutter/material.dart';
import 'package:journal/widgets/journal_drawer.dart';
import 'package:journal/models/journal_entry.dart';

class EntryDetailView extends StatelessWidget {
  const EntryDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as JournalEntryFields;
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(),
          title: Text('${args.date}'),
        ),
        endDrawer: settingsDrawer(context),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('${args.title}', style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold )),
                Text('${args.body}', style: const TextStyle(fontSize: 20)),
                // displayInt(args),
              ]),
        ));
  }

  // Text displayInt(JournalEntryFields args) {
  //   final String rating = args.rating.toString();
  //   return Text('Rating: ${rating}');
  // }
}
