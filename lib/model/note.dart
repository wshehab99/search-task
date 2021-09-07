class Note {
  int? noteId;
  String? noteText;
  String? noteDate;

  Note({this.noteId, required this.noteText, required this.noteDate});

  Map<String, dynamic> toMap() {
    return {'noteId': noteId, 'noteText': noteText, 'noteDate': noteDate};
  }
  Note.fromMap(Map<String,dynamic> map){
    noteId = map['noteId'];
    noteText = map['noteText'];
    noteDate = map['noteDate'];

  }

  @override
  String toString() {
    // TODO: implement toString
    return '$noteId, $noteText, $noteDate';
  }
}
