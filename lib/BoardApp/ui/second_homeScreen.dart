import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'Third_Screen.dart';

class BoardApp extends StatefulWidget {
  String Diaryname;
  var id;

  BoardAppState createState() => BoardAppState();

  BoardApp(this.Diaryname, this.id);
}

class BoardAppState extends State<BoardApp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController;
    titleController;
    descriptionController;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text(
          "${widget.Diaryname}",
          style: TextStyle(
              color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("User")
            .doc("${FirebaseAuth.instance.currentUser?.uid}")
            .collection("Diaries")
            .doc(widget.id)
            .collection("${widget.Diaryname}_messages")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(color: Colors.pinkAccent,));
          } else if(snapshot.data?.docs.length==0) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: SizedBox(
                  child: Text(
                    "Create your first diary record using the pen button",
                    style: TextStyle(
                        color: Colors.pinkAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          }
          else {
            //print(snapshot.data);
            return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  return Container(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        Card(
                          elevation: 8,
                          child: Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DiaryWirteup(
                                              snapshot.data?.docs[index]
                                                  ["description"])));
                                },
                                title: Center(
                                  child: Text(
                                    snapshot.data?.docs[index]["title"],
                                    style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                subtitle: Text(
                                      snapshot.data?.docs[index]["description"],
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                              ),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                        "Written By: ${snapshot.data?.docs[index]["Name"]}",
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.pink,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        DateFormat("EEEE,MMM d, y  hh:mm a")
                                            .format(DateTime
                                                .fromMillisecondsSinceEpoch(
                                                    (snapshot
                                                            .data
                                                            ?.docs[index]
                                                                ["TimeStamp"]
                                                            .seconds) *
                                                        1000)),
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.pink,
                                            fontWeight: FontWeight.bold)),
                                  ]),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(FontAwesomeIcons.penToSquare,
                                        size: 20),
                                    onPressed: () async {
                                      await EditAlertBox(
                                          snapshot, context, index);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      FontAwesomeIcons.trashCan,
                                      size: 20,
                                    ),
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection("User")
                                          .doc(
                                              "${FirebaseAuth.instance.currentUser?.uid}")
                                          .collection("Diaries")
                                          .doc("${widget.id}")
                                          .collection("messages")
                                          .doc(snapshot.data?.docs[index].id)
                                          .delete();
                                    },
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ]));
                });
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        splashColor: Colors.pinkAccent,
        backgroundColor: Colors.pink,
        onPressed: () {
          AlertBox(context);
        },
        child: Icon(FontAwesomeIcons.pen),
      ),
    );
  }

  AlertBox(BuildContext) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("please fill form"),
            contentPadding: EdgeInsets.all(10),
            content: Container(
              child: ListView(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        keyboardType: TextInputType.name,
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: "Name",
                        ),
                        autocorrect: true,
                        autofocus: true,
                      ),
                      TextField(
                        keyboardType: TextInputType.name,
                        controller: titleController,
                        decoration: InputDecoration(
                          labelText: "Title",
                        ),
                        autocorrect: true,
                        autofocus: true,
                      ),
                      TextField(minLines: 3,maxLines: 10,
                        keyboardType: TextInputType.multiline,
                        controller: descriptionController,
                        decoration: InputDecoration(
                          helperText: "Description of event",
                          labelText: "Description of event",
                        ),
                        autocorrect: true,
                        autofocus: true,
                      )
                    ],
                  )
                ],
              ),
            ),
            actions: [
              FloatingActionButton.extended(
                onPressed: () async {
                  if (nameController.text.isNotEmpty &&
                      titleController.text.isNotEmpty &&
                      descriptionController.text.isNotEmpty) {
                    await FirebaseFirestore.instance
                        .collection("User")
                        .doc("${FirebaseAuth.instance.currentUser?.uid}")
                        .collection("Diaries")
                        .doc(widget.id)
                        .collection("${widget.Diaryname}_messages").add({
                      "Name": nameController.text,
                      "title": titleController.text,
                      "description": descriptionController.text,
                      "TimeStamp": DateTime.now()
                    });

                    final snackbar = SnackBar(
                      content: Text("Saved"),
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.blue,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    Navigator.pop(context);
                    nameController.clear();
                    titleController.clear();
                    descriptionController.clear();
                  } else {
                    final snackbar = SnackBar(
                      content: Text("FIll in required details"),
                      duration: Duration(seconds: 5),
                      backgroundColor: Colors.red,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  }
                },
                backgroundColor: Colors.pinkAccent,
                label: Text("Save"),
              ),
              FloatingActionButton.extended(
                onPressed: () {
                  nameController.clear();
                  titleController.clear();
                  descriptionController.clear();
                  Navigator.pop(context);
                },
                backgroundColor: Colors.pinkAccent,
                label: Text("Cancel"),
              ),
            ],
          );
        });
  }

  EditAlertBox(snapshot, BuildContext, index) async {
    TextEditingController nameController =
        TextEditingController(text: snapshot.data?.docs[index]["Name"]);
    TextEditingController titleController =
        TextEditingController(text: snapshot.data?.docs[index]["title"]);
    TextEditingController descriptionController =
        TextEditingController(text: snapshot.data?.docs[index]["description"]);
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Update document"),
            contentPadding: EdgeInsets.all(10),
            content: Container(
              child: ListView(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        keyboardType: TextInputType.name,
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: "Name",
                        ),
                        autocorrect: true,
                        autofocus: true,
                      ),
                      TextField(
                        keyboardType: TextInputType.name,
                        controller: titleController,
                        decoration: InputDecoration(
                          labelText: "Title",
                        ),
                        autocorrect: true,
                        autofocus: true,
                      ),
                      TextField(
                        textInputAction: TextInputAction.done,
                        minLines: 5,
                        maxLines: 10,
                        keyboardType: TextInputType.multiline,
                        controller: descriptionController,
                        decoration: InputDecoration(
                          helperText: "Description of event",
                          labelText: "Description of event",
                        ),
                        autocorrect: true,
                        autofocus: true,
                      )
                    ],
                  )
                ],
              ),
            ),
            actions: [
              FloatingActionButton.extended(
                onPressed: () async {
                  if (nameController.text.isNotEmpty &&
                      titleController.text.isNotEmpty &&
                      descriptionController.text.isNotEmpty) {
                    await FirebaseFirestore.instance
                        .collection("User")
                        .doc("${FirebaseAuth.instance.currentUser?.uid}")
                        .collection("Diaries")
                        .doc("${widget.id}")
                        .collection("${widget.Diaryname}_messages")
                        .doc(snapshot.data?.docs[index].id)
                        .update({
                      "Name": nameController.text,
                      "title": titleController.text,
                      "description": descriptionController.text,
                      "TimeStamp": DateTime.now()
                    });
                    Navigator.pop(context);
                    final snackbar = SnackBar(
                      content: Text("Updated"),
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.green,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);

                    nameController.clear();
                    titleController.clear();
                    descriptionController.clear();
                  } else {
                    final snackbar = SnackBar(
                      content: Text("FIll in required details"),
                      duration: Duration(seconds: 5),
                      backgroundColor: Colors.red,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  }
                },
                backgroundColor: Colors.pinkAccent,
                label: Text("Update"),
              ),
              FloatingActionButton.extended(
                onPressed: () {
                  Navigator.pop(context);
                  nameController.clear();
                  titleController.clear();
                  descriptionController.clear();
                },
                backgroundColor: Colors.pinkAccent,
                label: Text("Cancel"),
              ),
            ],
          );
        });
  }
}
