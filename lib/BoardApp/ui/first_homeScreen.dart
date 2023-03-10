import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'login_screen.dart';
import 'second_homeScreen.dart';

class DiaryList extends StatefulWidget {
  DiaryListState createState() => DiaryListState();
}

class DiaryListState extends State<DiaryList> {
  final authservice = FirebaseAuth.instance.currentUser;
  var firestoreDB = FirebaseFirestore.instance
      .collection("User")
      .doc("${FirebaseAuth.instance.currentUser?.uid}")
      .collection("Diaries")
      .snapshots();
  TextEditingController DiarynameController = TextEditingController();

  var docId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DiarynameController;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: Drawer(elevation: 0,backgroundColor: Colors.pink),
        actions: [
          IconButton(
              onPressed: () async {
                await showDialog(
                    barrierDismissible: false,
                    useSafeArea: true,
                    context: context,
                    builder: (context) => Container(
                          height: MediaQuery.of(context).size.height / 4,
                          child: AlertDialog(
                            title: Center(
                                child: Text("Are you sure you want to logout",
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red))),
                            actions: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    Icons.cancel,
                                    color: Colors.red.shade800,
                                    size: 35,
                                  )),
                              IconButton(
                                  onPressed: () async {
                                    await FirebaseAuth.instance.signOut().then(
                                        (value) => Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginScreen())));
                                  },
                                  icon: Icon(
                                    Icons.done,
                                    color: Colors.green.shade800,
                                    size: 25,
                                  ))
                            ],
                          ),
                        ));
              },
              icon: Icon(Icons.logout))
        ],
        backgroundColor: Colors.pink,
        title: Text(
          "MY DIARY",
          style: TextStyle(
              color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: firestoreDB,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data?.docs.length == 0) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: SizedBox(
                        child: Text(
                          "Create your first diary using the Add button",
                          style: TextStyle(
                              color: Colors.pinkAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                } else {
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
                                                builder: (context) => BoardApp(
                                                    snapshot.data?.docs[index]
                                                        ["DiaryName"],
                                                    (snapshot.data?.docs[index])
                                                        ?.id)));
                                      },
                                      title: Text(
                                        snapshot.data?.docs[index]["DiaryName"],
                                        style: TextStyle(
                                            fontSize: 30,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                          "created at:" +
                                              DateFormat(
                                                      "EEEE,MMM d, y  hh:mm a")
                                                  .format(DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          (snapshot
                                                                  .data
                                                                  ?.docs[index][
                                                                      "created_at"]
                                                                  .seconds) *
                                                              1000)),
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.pink,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                            icon: Icon(
                                                FontAwesomeIcons.penToSquare,
                                                size: 20),
                                            onPressed: () {
                                              EditAlertBox(
                                                  context, snapshot, index);
                                            }),
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
                                                .doc(snapshot
                                                    .data?.docs[index].id)
                                                .delete();
                                            final snackbar = SnackBar(
                                              content: Text("Deleted"),
                                              duration: Duration(seconds: 2),
                                              backgroundColor: Colors.red,
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackbar);
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
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.pinkAccent,
                  ),
                );
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
        splashColor: Colors.pinkAccent.shade100,
        backgroundColor: Colors.pink,
        onPressed: () {
          AlertBox(context);
        },
        child: Icon(FontAwesomeIcons.plus),
      ),
    );
  }

  AlertBox(context) async {
    await showDialog(
        barrierDismissible: false,
        useSafeArea: true,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Input Diary title"),
            contentPadding: EdgeInsets.all(10),
            content: Container(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  keyboardType: TextInputType.name,
                  controller: DiarynameController,
                  decoration: InputDecoration(
                    hintText: "Diary name",
                    labelText: "Diary name",
                  ),
                  autocorrect: true,
                  autofocus: true,
                ),
              ],
            )),
            actions: [
              FloatingActionButton.extended(
                onPressed: () async {
                  if (DiarynameController.text.isNotEmpty) {
                    DocumentReference documentReference =
                        await FirebaseFirestore.instance
                            .collection("User")
                            .doc("${authservice?.uid}")
                            .collection("Diaries")
                            .add({
                      "DiaryName": DiarynameController.text.trim(),
                      "created_at": DateTime.now(),
                      "createdby": authservice?.email
                    });
                    setState(() {
                      docId = documentReference.id;
                    });
                    final snackbar = SnackBar(
                      content: Text("Created"),
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.green,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    Navigator.pop(context);
                    DiarynameController.clear();
                  } else {
                    final snackbar = SnackBar(
                      content: Text("FILL IN A TEXT"),
                      duration: Duration(seconds: 3),
                      backgroundColor: Colors.red,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  }
                },
                backgroundColor: Colors.pinkAccent,
                label: Text("Create"),
              ),
              FloatingActionButton.extended(
                onPressed: () {
                  DiarynameController.clear();
                  Navigator.pop(context);
                },
                backgroundColor: Colors.pinkAccent,
                label: Text("Cancel"),
              ),
            ],
          );
        });
  }

  EditAlertBox(context, snapshot, index) async {
    TextEditingController DiarynameeditingController =
        TextEditingController(text: snapshot.data?.docs[index]["DiaryName"]);
    await showDialog(
        barrierDismissible: false,
        useSafeArea: true,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Edit Diary title"),
            contentPadding: EdgeInsets.all(10),
            content: Container(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  keyboardType: TextInputType.name,
                  controller: DiarynameeditingController,
                  decoration: InputDecoration(
                    hintText: "Diary name",
                    labelText: "Diary name",
                  ),
                  autocorrect: true,
                  autofocus: true,
                ),
              ],
            )),
            actions: [
              FloatingActionButton.extended(
                onPressed: () async {
                  if (DiarynameeditingController.text.isNotEmpty) {
                    await FirebaseFirestore.instance
                        .collection("User")
                        .doc("${FirebaseAuth.instance.currentUser?.uid}")
                        .collection("Diaries")
                        .doc(snapshot.data?.docs[index].id)
                        .update({
                      "DiaryName": DiarynameeditingController.text.trim(),
                    }).then((value) {
                      Navigator.pop(context);
                      final snackbar = SnackBar(
                        content: Text("Edited sucessfully"),
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.green,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                      DiarynameController.clear();
                    });
                  } else {
                    final snackbar = SnackBar(
                      content: Text("FILL IN A TEXT"),
                      duration: Duration(seconds: 3),
                      backgroundColor: Colors.red,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  }
                },
                backgroundColor: Colors.pinkAccent,
                label: Text("Edit"),
              ),
              FloatingActionButton.extended(
                onPressed: () {
                  Navigator.pop(context);
                  DiarynameeditingController.clear();
                },
                backgroundColor: Colors.pinkAccent,
                label: Text("Cancel"),
              ),
            ],
          );
        });
  }
}
