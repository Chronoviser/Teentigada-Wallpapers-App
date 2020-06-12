/*import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database extends StatefulWidget {
  @override
  _DatabaseState createState() => _DatabaseState();
}

class _DatabaseState extends State<Database> {
  final DocumentReference documentReference =
      Firestore.instance.document("myData/dummy");
  String fetchedData = 'No Data';
  StreamSubscription<DocumentSnapshot> subscription;

  void _add() {
    Map<String, String> data = {
      "name": "Abhishek Singh",
      "age": "21",
      "ambition": "Billionaire"
    };
    documentReference
        .setData(data)
        .whenComplete(() => print("Document added"))
        .catchError((e) => print(e));
  }

  void _read() {
    documentReference.get().then((value) {
      if (value.exists) {
        setState(() {
          fetchedData = value.data['name'];
        });
      } else {
        setState(() {
          fetchedData = "No Data";
        });
      }
    });
  }

  void _update() {
    Map<String, String> data = {
      "name": "King Abhishek Singh",
      "age": "21",
      "ambition": "Trillionaire"
    };
    documentReference
        .updateData(data)
        .whenComplete(() => print("Document updated"))
        .catchError((e) => print(e));
  }

  void _delete() {
    documentReference.delete().whenComplete(() {
      print("Documnet deleted");
      setState(() {});
    });
  }

  @override
  void initState() {

    super.initState();
    subscription = documentReference.snapshots().listen((value) {
      if (value.exists) {
        setState(() {
          fetchedData = value.data['name'];
        });
      } else {
        setState(() {
          fetchedData = "No Data";
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              onPressed: _add,
              color: Colors.red,
              child: Text("Add"),
            ),
            RaisedButton(
              onPressed: _read,
              color: Colors.blue,
              child: Text("Read"),
            ),
            RaisedButton(
              onPressed: _update,
              color: Colors.green,
              child: Text("Update"),
            ),
            RaisedButton(
              onPressed: _delete,
              color: Colors.yellowAccent,
              child: Text("Delete"),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              fetchedData,
              style: TextStyle(color: Colors.black, fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}
*/