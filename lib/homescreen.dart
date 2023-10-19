// ignore_for_file: use_build_context_synchronously

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
  final _confettiController = ConfettiController(
    duration: const Duration(seconds: 2),
  );
  bool isPlaying = false;

  @override
  void dispose() {
    super.dispose();
    itemController.dispose();
    valueController.dispose();
    _confettiController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text("Notes"),
          ),
          body: ValueListenableBuilder(
            valueListenable: Boxes.getData().listenable(),
            builder: (context, box, _) {
              var data = box.values.toList().cast<NotesModel>();
              return ListView.builder(
                itemCount: box.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 12, right: 12, top: 12),
                    child: Slidable(
                      startActionPane: ActionPane(
                        motion: const StretchMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              _editValuetDialog(
                                context,
                                data[index],
                                data[index].title.toString(),
                                data[index].desc.toString(),
                              );
                            },
                            icon: Icons.edit,
                            backgroundColor: Colors.amber.shade300,
                            borderRadius: BorderRadius.circular(12),
                          )
                        ],
                      ),
                      endActionPane: ActionPane(
                        motion: const StretchMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              deleteValue(data[index]);
                            },
                            icon: Icons.delete,
                            backgroundColor: Colors.red.shade300,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ],
                      ),
                      child: Card(
                        margin: EdgeInsets.zero,
                        color: Colors.indigo.shade500,
                        child: ListTile(
                          leading: CircleAvatar(
                            maxRadius: 16,
                            backgroundColor: Colors.black45,
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                fontSize: 14,
                              ),
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
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            data[index].desc.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
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
        ),
        ConfettiWidget(
          confettiController: _confettiController,
          blastDirection: 90,
          emissionFrequency: 0.1,
          blastDirectionality: BlastDirectionality.explosive,
        ),
      ],
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
          title: const Text('Edit note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Title:'),
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
              const Text('Description:'),
              const SizedBox(height: 3),
              TextField(
                maxLines: 2,
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
                itemController.clear();
                valueController.clear();
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 40),
            OutlinedButton(
              onPressed: () async {
                notesModel.title = itemController.text.toString();
                notesModel.desc = valueController.text.toString();
                itemController.clear();
                valueController.clear();

                setState(() {});
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll(Colors.indigo.shade400),
              ),
              child: const Text(
                'Update',
                style: TextStyle(color: Colors.white),
              ),
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
          title: const Text('Add new note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Title:'),
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
              const Text('Description:'),
              const SizedBox(height: 3),
              TextField(
                maxLines: 2,
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
                  itemController.clear();
                  valueController.clear();
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                )),
            const SizedBox(width: 40),
            OutlinedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll(Colors.indigo.shade400),
              ),
              onPressed: () async {
                if (itemController.text.isEmpty &&
                    valueController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Empty note cannot be saved'),
                      duration: Duration(seconds: 3),
                      backgroundColor: Colors.amber,
                    ),
                  );
                } else {
                  final data = NotesModel(
                    title: itemController.text,
                    desc: valueController.text,
                  );
                  final box = Boxes.getData();
                  await box.add(data);
                  data.save();
                  _confettiController.play();
                }
                itemController.clear();
                valueController.clear();
                setState(() {});
                Navigator.of(context).pop();
              },
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
