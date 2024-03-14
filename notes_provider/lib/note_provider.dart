import 'package:flutter/foundation.dart';
import 'package:notes_provider/sql_helper.dart';

class NoteProvider with ChangeNotifier {
  List<Note> _items = [];

  List<Note> get getItems {
    return [..._items];
  }

  int? get getCount {
    return _items.length;
  }

  loadNoteProvider() async {
    List<Map> items = await SQLHelper.loadNotes();
    _items = items.map((e) {
      return Note(id: e["id"], title: e["title"], content: e["content"]);
    }).toList();
    notifyListeners();
  }

  addItem(Note note) async {
    await SQLHelper.insertNote(note).whenComplete(() => _items.add(note));
    notifyListeners();
  }

  updateItem(Note note) async {
    await SQLHelper.updateNote(note).whenComplete(() => loadNoteProvider());
  }

  removeItem(int id) async {
    await SQLHelper.deleteNote(id)
        .whenComplete(() => _items.removeWhere((element) => element.id == id));

    notifyListeners();
  }

  removeAllItems() async {
    await SQLHelper.deleteAllNotes().whenComplete(
      () => _items = [],
    );
    notifyListeners();
  }
}
