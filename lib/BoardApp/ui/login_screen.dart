import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstfirebase_work/BoardApp/ui/password_reset_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'Sign_up_Screen.dart';
import 'first_homeScreen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

bool isloading=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    "LOGIN",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      color: Colors.pinkAccent,
                    ),
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
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.pink,
                        ),
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
                        LoginUser();
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.pinkAccent),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0))),
                    ),
                    child: Text("LOGIN",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10))),
    Padding(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Dont have an account?",
                      style: TextStyle(
                          color: Colors.pinkAccent.shade100,
                          fontWeight: FontWeight.bold,
                          fontSize: 10),
                    ),
                    TextButton(
                      child: Text(
                        "Sign UP",
                        style: TextStyle(
                            color: Colors.pinkAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 8),
                      ),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Signup()));
                      },
                    ),
                  ],
                ),
                isloading?Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: SpinKitCircle(color:Colors.pink ,)),
                ):Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: SpinKitCircle(color:Colors.transparent ,)),
                )
              ],
            ),
    );
  }

  Future LoginUser() async {
    setState(() {
      isloading = true;
    });
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim()).then((value){
      setState(() {
        isloading = false;
      });
      return  Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => DiaryList()
            ));}).onError((error, stackTrace) {
          final snackbar = SnackBar(
            duration: Duration(seconds: 1),
            content: Center(child: Text(error.toString())),
            backgroundColor: Colors.red,
          );
          ScaffoldMessenger.of(context)
              .showSnackBar(snackbar);
          setState(() {
            isloading = false;
          });
        });
  }
}
