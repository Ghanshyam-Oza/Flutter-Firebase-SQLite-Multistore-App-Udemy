import 'package:flutter/material.dart';
import 'package:notes_provider/note_provider.dart';
import 'package:notes_provider/sql_helper.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SQLHelper.getDatabase;
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => NoteProvider()),
  ], child: const MyApp()));
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
    TextEditingController idController = TextEditingController();
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
                    controller: idController,
                    decoration: const InputDecoration(
                      labelText: "Id",
                      hintText: 'Enter Id',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
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
                    var existingItem = context
                        .read<NoteProvider>()
                        .getItems
                        .firstWhereOrNull((element) =>
                            element.id == int.parse(idController.text));

                    existingItem == null
                        ? context.read<NoteProvider>().addItem(
                              Note(
                                  id: int.parse(idController.text),
                                  title: titleController.text,
                                  content: descController.text),
                            )
                        : ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                                content: Text(
                            "Item with item id is already exists.",
                            style: TextStyle(fontSize: 16),
                          )));
                    titleController.clear();
                    descController.clear();
                    Navigator.pop(context);
                  },
                  child: const Text("Add")),
            ],
          );
        });
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
                context.read<NoteProvider>().updateItem(Note(
                      id: id,
                      title: titleController.text,
                      content: descController.text,
                    ));
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
  void initState() {
    context.read<NoteProvider>().loadNoteProvider();
    super.initState();
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
              context.read<NoteProvider>().removeAllItems();
            },
            icon: const Icon(Icons.delete_forever),
          ),
        ],
      ),
      body: Consumer<NoteProvider>(
        builder: (context, noteProvider, child) {
          return ListView.builder(
              itemCount: noteProvider.getCount,
              itemBuilder: (context, index) {
                var item = noteProvider.getItems[index];
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) =>
                      context.read<NoteProvider>().removeItem(item.id),
                  child: Card(
                    color: Colors.purple[100],
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 12, left: 12, bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  item.id.toString() + (". ") + item.title,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    openEditDialog(
                                      item.id,
                                      item.title,
                                      item.content,
                                    );
                                  },
                                  icon: const Icon(Icons.edit)),
                            ],
                          ),
                          Text(
                            item.content,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
        child: FloatingActionButton(
          backgroundColor: Colors.purple[100],
          onPressed: openDialog,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
