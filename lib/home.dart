import 'package:dummer_iti_5/db/db_helper.dart';
import 'package:dummer_iti_5/util/DateTimeManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'model/note.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<FormState>? _formKey;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  DbHelper? _helper;
  List<Note> noteList = [];

  @override
  void initState() {
    _helper = DbHelper();
    _helper?.getDbInstance();
    viewNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _formKey = GlobalKey();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 120,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                          controller: _nameController,
                          validator: (value) =>
                              value!.isEmpty ? 'This field is required' : null,
                          decoration: InputDecoration(
                              labelText: 'Write Note',
                              prefixIcon: Icon(Icons.note))),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey!.currentState!.validate()) {
                              var text = _nameController.value.text;
                              print(text);
                              Note note = Note(
                                  noteText: text,
                                  noteDate: DateTimeManager.currentDateTime());
                              print(note.noteText);
                              _saveNote(note);
                            }
                          },
                          child: Text('Save'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                  child: Column(children: [
                CupertinoSearchTextField(
                  controller: _searchController,
                  borderRadius: BorderRadius.circular(15),
                  onChanged: (value) {
                    setState(() {
                      searchNote(value);
                    });
                  },
                ),
                viewList(),
              ]))
            ],
          ),
        ),
      ),
    );
  }

  void _saveNote(Note note) {
    _helper?.insertNote(note).then((value) => value > 0
        ? Fluttertoast.showToast(msg: 'Done')
        : Fluttertoast.showToast(msg: 'Error'));

    viewNotes();
  }

  Widget viewList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: noteList.length,
      itemBuilder: (context, index) => ListTile(
        title: Text('${noteList[index].noteText}'),
        subtitle: Text('${noteList[index].noteDate}'),
        leading: Icon(Icons.note),
        trailing: Container(
          width: 100,
          child: Row(
            children: [
              IconButton(
                  onPressed: () => deleteNote(noteList[index]),
                  icon: Icon(Icons.delete)),
              IconButton(
                onPressed: () => openEditDialog(context, noteList[index]),
                icon: Icon(Icons.edit),
              )
            ],
          ),
        ),
      ),
    );
  }

  void viewNotes() {
    _helper?.getAllNotes().then((value) {
      setState(() {
        noteList = value;
        print(noteList.toString());
      });
    });
  }

  deleteNote(Note note) {
    _helper
        ?.deleteNote(note)
        .then((value) => value > 0 ? print('note deleted') : print('Error'));
    viewNotes();
  }

  openEditDialog(context, Note note) {
    var _editFormKey = GlobalKey<FormState>();
    TextEditingController _editTextController =
        TextEditingController(text: note.noteText);
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Update Note'),
              content: Container(
                height: 120,
                child: Form(
                  key: _editFormKey,
                  child: TextFormField(
                    controller: _editTextController,
                    validator: (value) =>
                        value!.isEmpty ? 'This field is required' : null,
                    onTap: () => _editTextController.text = '',
                  ),
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      if (_editFormKey.currentState!.validate()) {
                        var newNoteText = _editTextController.value.text;
                        note.noteText = newNoteText;
                        editNote(note);
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Update')),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel')),
              ],
            ));
  }

  void editNote(Note note) {
    _helper
        ?.updateNote(note)
        .then((value) => value > 0 ? print('note updated') : print('Error'));
    viewNotes();
  }

  Future searchNote(String text) async {
    await _helper?.getNote(text).then((value) {
      setState(() {
        noteList = value;
      });
    });
  }
}
