// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hive_db/boxes/boxes.dart';
import 'package:hive_db/models/notes_model.dart';
import 'package:hive_flutter/adapters.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  TextEditingController itemController = TextEditingController();
  TextEditingController valueController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    itemController.dispose();
    valueController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes | Hive DB"),
      ),
      body: ValueListenableBuilder(
        valueListenable: Boxes.getData().listenable(),
        builder: (context, box, _) {
          var data = box.values.toList().cast<NotesModel>();
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          data[index].title.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _editValuetDialog(
                            context,
                            data[index],
                            data[index].title.toString(),
                            data[index].desc.toString(),
                          );
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.green,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          deleteValue(data[index]);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      Expanded(
                        child: Text(data[index].desc.toString()),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAlertDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void deleteValue(NotesModel notesModel) async {
    await notesModel.delete();
  }

  Future<void> _editValuetDialog(
    BuildContext context,
    NotesModel notesModel,
    String title,
    String desc,
  ) {
    itemController.text = title;
    valueController.text = desc;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Name:'),
              const SizedBox(height: 3),
              TextField(
                controller: itemController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.deepPurple,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 3),
              const Text('Value:'),
              const SizedBox(height: 3),
              TextField(
                controller: valueController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.deepPurple,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel')),
            const SizedBox(width: 40),
            OutlinedButton(
              child: const Text('Update'),
              onPressed: () async {
                notesModel.title = itemController.text.toString();
                notesModel.desc = valueController.text.toString();
                itemController.clear();
                valueController.clear();

                setState(() {});
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> _showAlertDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Save new data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Name:'),
              const SizedBox(height: 3),
              TextField(
                controller: itemController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.deepPurple,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 3),
              const Text('Value:'),
              const SizedBox(height: 3),
              TextField(
                controller: valueController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.deepPurple,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel')),
            const SizedBox(width: 40),
            OutlinedButton(
              child: const Text('Save'),
              onPressed: () async {
                final data = NotesModel(
                    title: itemController.text, desc: valueController.text);
                final box = Boxes.getData();
                await box.add(data);
                data.save();
                itemController.clear();
                valueController.clear();

                setState(() {});
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
