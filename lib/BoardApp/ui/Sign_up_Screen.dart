import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstfirebase_work/BoardApp/ui/password_reset_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'login_screen.dart';

class Signup extends StatefulWidget {
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController UsernameController = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return    Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text(
          textAlign: TextAlign.center,
          "Registration",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body:SingleChildScrollView(reverse:true,
        child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Register on My Diary",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.pinkAccent),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        autocorrect: true,
                        showCursor: true,
                        keyboardType: TextInputType.text,
                        controller: UsernameController,
                        decoration: InputDecoration(
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.red,
                                    style: BorderStyle.solid)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.pink.shade900,
                                    style: BorderStyle.solid)),
                            hintText: "username",
                            labelText: "username",
                            prefixIcon: Icon(Icons.person, color: Colors.pink),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.pinkAccent,
                                    style: BorderStyle.solid))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        showCursor: true,
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: InputDecoration(
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.red,
                                    style: BorderStyle.solid)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.pink.shade900,
                                    style: BorderStyle.solid)),
                            hintText: "Email",
                            labelText: "email",
                            prefixIcon: Icon(Icons.email, color: Colors.pink),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.pinkAccent,
                                    style: BorderStyle.solid))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        showCursor: true,
                        keyboardType: TextInputType.text,
                        controller: passwordController,
                        decoration: InputDecoration(
                            labelText: "password",
                            hintText: "Password",
                            prefixIcon: Icon(Icons.lock, color: Colors.pink),
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.red,
                                    style: BorderStyle.solid)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.pink.shade900,
                                    style: BorderStyle.solid)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.pink,
                                    style: BorderStyle.solid))),
                      ),
                    ),  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Align(alignment: Alignment.topLeft,
                        child: TextButton(
                          child: Text(
                            "Forgotten password",
                            style: TextStyle(
                                color: Colors.pinkAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 10),
                          ),
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => ResetScreen()));
                          },
                        ),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (passwordController.text.isEmpty &&
                              emailController.text.isEmpty) {
                            final snackbar = SnackBar(
                              duration: Duration(seconds: 2),
                              content: Text("Fill up required field"),
                              backgroundColor: Colors.red,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackbar);
                          } else if (passwordController.text.isNotEmpty &&
                                  emailController.text.isEmpty ||
                              passwordController.text.isEmpty &&
                                  emailController.text.isNotEmpty) {
                            bool isemt = passwordController.text.isNotEmpty;
                            final snackbar = SnackBar(
                              duration: Duration(seconds: 2),
                              content: Text(isemt
                                  ? "Fill Email Field"
                                  : "Fill Password Field"),
                              backgroundColor: Colors.red,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackbar);
                          } else {
                            setState(() {
                              loading = true;
                            });
                            createUser().then((value) {
                              setState(() {
                                loading=false;
                              });
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
                              final snackbar = SnackBar(
                                duration: Duration(seconds: 1),
                                content:
                                    Center(child: Text("Registration SucessFul")),
                                backgroundColor: Colors.green,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackbar);
                              emailController.clear();
                              passwordController.clear();
                              UsernameController.clear();
                            }).onError((error, stackTrace) {
                              final snackbar = SnackBar(
                                  duration: Duration(seconds: 1),
                                  content: Center(child: Text(error.toString())),
                                  backgroundColor: Colors.red);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackbar);
                              setState(() {
                                loading=false;
                              });
                            });
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.pinkAccent),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0))),
                        ),
                        child: Text("Register",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10))),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(
                              color: Colors.pinkAccent.shade100,
                              fontWeight: FontWeight.bold,
                              fontSize: 10),
                        ),
                        TextButton(
                          child: Text(
                            "LOGIN",
                            style: TextStyle(
                                color: Colors.pinkAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 8),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                        ),
                      ],
                    ),
                    loading?Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: SpinKitCircle(color:Colors.pink ,)),
                    ):Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: SpinKitCircle(color:Colors.transparent ,)),
                    ) ],
                ),
              ),
      ),
    );
  }

  Future createUser() async {
    User? user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim()))
        .user;
    await FirebaseFirestore.instance
        .collection("User")
        .doc("${user?.uid}")
        .set({
      "username": UsernameController.text.trim(),
      "Datetime": DateTime.now(),
      "Dateyear": DateTime.now().year
    });

  }
}
