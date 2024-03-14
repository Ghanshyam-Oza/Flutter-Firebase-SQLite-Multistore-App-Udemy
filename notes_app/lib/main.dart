import 'package:flutter/material.dart';
import 'package:notes_app/sql_helper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SQLHelper.getDatabase;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Notes App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  openDialog() {
    TextEditingController titleController = TextEditingController();
    TextEditingController descController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(10),
            title: const Text("Add Note"),
            content: SizedBox(
              width: 270,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: "Title",
                      hintText: 'Enter Title',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: descController,
                    decoration: const InputDecoration(
                      labelText: "Description",
                      hintText: 'Enter Description',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    titleController.clear();
                    descController.clear();
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () {
                    // SQLHelper.insertNote(Note(
                    //     title: titleController.text,
                    //     content: descController.text));
                    SQLHelper.insertNoteRaw(
                            titleController.text, descController.text)
                        .whenComplete(() {
                      setState(() {});
                    });
                    titleController.clear();
                    descController.clear();
                    Navigator.pop(context);
                  },
                  child: const Text("Add")),
            ],
          );
        });
  }

  openDialogTodo() {
    TextEditingController titleController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(10),
          title: const Text("Add To do"),
          content: SizedBox(
            width: 270,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: "Title",
                    hintText: 'Enter Title',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 4),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  titleController.clear();
                  Navigator.pop(context);
                },
                child: const Text("Cancel")),
            TextButton(
                onPressed: () {
                  // SQLHelper.insertNote(Note(
                  //     title: titleController.text,
                  //     content: descController.text));
                  SQLHelper.insertTodo(Todo(title: titleController.text))
                      .whenComplete(() {
                    setState(() {});
                  });
                  titleController.clear();
                  Navigator.pop(context);
                },
                child: const Text("Add")),
          ],
        );
      },
    );
  }

  openEditDialog(int id, String title, String content) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descController = TextEditingController();
    titleController.text = title;
    descController.text = content;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(10),
          title: const Text("Edit Note"),
          content: SizedBox(
            width: 270,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: "Title",
                    hintText: 'Enter Title',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 4),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    hintText: 'Enter Description',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 4),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel")),
            TextButton(
              onPressed: () {
                SQLHelper.updateNoteRaw(Note(
                        id: id,
                        title: titleController.text,
                        content: descController.text))
                    .whenComplete(() => setState(() {}));
                // SQLHelper.updateNote(Note(
                //         id: id,
                //         title: titleController.text,
                //         content: descController.text))
                // .whenComplete(() => setState(() {}));
                titleController.clear();
                descController.clear();
                Navigator.pop(context);
              },
              child: const Text("Edit"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              SQLHelper.deleteAllTodos();
              SQLHelper.deleteAllNotes().whenComplete(() => setState(() {}));
            },
            icon: const Icon(Icons.delete_forever),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: SQLHelper.loadNotes(),
              builder: (context, AsyncSnapshot<List<Map>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: UniqueKey(),
                            onDismissed: (direction) => SQLHelper.deleteNoteRaw(
                                snapshot.data![index]['id']),
                            child: Card(
                              color: Colors.purple[100],
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 12, left: 12, bottom: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            snapshot.data![index]['id']
                                                    .toString() +
                                                (". ") +
                                                snapshot.data![index]['title'],
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              openEditDialog(
                                                  snapshot.data![index]['id'],
                                                  snapshot.data![index]
                                                      ['title'],
                                                  snapshot.data![index]
                                                      ['content']);
                                            },
                                            icon: const Icon(Icons.edit)),
                                      ],
                                    ),
                                    Text(
                                      snapshot.data![index]['content'],
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  } else {
                    return const Center(
                      child: Text("No notes preset, Add some.."),
                    );
                  }
                }
                return const CircularProgressIndicator();
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: SQLHelper.loadTodos(),
              builder: (context, AsyncSnapshot<List<Map>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          bool isDone = snapshot.data![index]['value'] == 0
                              ? false
                              : true;
                          return Dismissible(
                            key: UniqueKey(),
                            onDismissed: (direction) => SQLHelper.deleteTodoRaw(
                                snapshot.data![index]['id']),
                            child: Card(
                              color: isDone == true
                                  ? Colors.green
                                  : Colors.amber[300],
                              child: Row(
                                children: [
                                  Checkbox(
                                    activeColor: isDone == true
                                        ? Colors.black
                                        : Colors.amber[300],
                                    value: isDone,
                                    onChanged: (value) {
                                      SQLHelper.updateTodoChecked(
                                              snapshot.data![index]['id'],
                                              snapshot.data![index]['value'])
                                          .whenComplete(() => setState(() {}));
                                    },
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 12.0),
                                      child: Text(
                                        snapshot.data![index]['title'],
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: isDone == true
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  } else {
                    return const Center(
                      child: Text("No Todos preset, Add some.."),
                    );
                  }
                }
                return const CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: FloatingActionButton(
              backgroundColor: Colors.purple[100],
              onPressed: openDialog,
              child: const Icon(Icons.add),
            ),
          ),
          FloatingActionButton(
            backgroundColor: Colors.amberAccent,
            onPressed: openDialogTodo,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
