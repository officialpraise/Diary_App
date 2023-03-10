import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'login_screen.dart';

class ResetScreen extends StatefulWidget {
  @override
  State<ResetScreen> createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  @override
  String helperText = "";
  String helper = "";
bool isloading=false;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text(
          textAlign: TextAlign.center,
          "Reset Password",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Enter Email used to open Account",
                style: TextStyle(
                    color: Colors.pinkAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    helperText = "";
                  });
                  setState(() {
                    helper = value;
                  });
                },
                showCursor: true,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    helperText: helperText.isEmpty ? "" : helperText,
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
            ElevatedButton(
              onPressed: () async {
                if (helper.isEmpty) {
                  setState(() {
                    helperText =
                        "Input an email to receive the reset password link ";
                  });
                } else {
                  setState(() {
                    isloading=true;
                  });
                  await FirebaseAuth.instance.sendPasswordResetEmail(email:helper).then((value){
                    Resetfunction();
                  }).onError((error, stackTrace) {
                    setState(() {
                      isloading=false;
                    });
                    final snackbar = SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text(error.toString()),
                      backgroundColor: Colors.red,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  });

                }
              },
              child: Text("Reset",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10)),
              style: ElevatedButton.styleFrom(
                  backgroundColor:
                      helper.isNotEmpty ? Colors.pink : Colors.grey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
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
      ),
    );
  }

  Resetfunction() async {
    setState(() {
      isloading=false;
    });
    await showDialog(
      context: context,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 4,
          child: AlertDialog(
            title: Center(
                child: Text("Check $helper for passwordreset link",
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87))),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Text("Ok",
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black))),
            ],
          ),
        );
      },
    );
  }
}
