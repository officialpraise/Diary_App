import 'package:flutter/material.dart';

class DiaryWirteup extends StatelessWidget {

  DiaryWirteup(this.data);

  var data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(extendBody: true,extendBodyBehindAppBar: true,
      appBar: AppBar(elevation: 0,
        backgroundColor: Colors.pinkAccent,
        title: Text(
          "Diary write_up",
          style: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(color: Colors.pinkAccent,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "/.......Detail of Event ......./",
                  style: TextStyle(
                      color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Text("$data", style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),),
                  ),

              ),
            ],
          ),
        ),
      ),
    );
  }

}