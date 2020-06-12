import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:teentigada/fullscreen.dart';

void main() {
  runApp(myApp());
}

class myApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: Colors.blue, accentColor: Colors.blueAccent),
        home: Home());
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<DocumentSnapshot> wallpapersList;
  final CollectionReference collectionReference =
      Firestore.instance.collection("wallpapers");
  StreamSubscription<QuerySnapshot> subscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subscription = collectionReference.snapshots().listen((value) {
      setState(() {
        wallpapersList = value.documents;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.black45, Colors.black54],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.black.withOpacity(0.1),
            title: Text("Teentigada",
                style: TextStyle(
                    fontSize: 36,
                    fontFamily: 'cursive',
                    fontWeight: FontWeight.bold)),
            centerTitle: true,
          ),
          body: wallpapersList == null
              ? Container()

              ///TODO : Add a loading widget here
              : StaggeredGridView.countBuilder(
                  padding: EdgeInsets.all(4.0),
                  crossAxisCount: 4,
                  itemCount: wallpapersList.length,
                  itemBuilder: (context, i) {
                    String imageURL = wallpapersList[i].data['url'];
                    return Material(
                      elevation: 10.0,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Fullscreen(imageURL: imageURL)));
                        },
                        child: Hero(
                          tag: imageURL,
                          child: FadeInImage(
                            image: NetworkImage(imageURL),
                            fit: BoxFit.cover,
                            placeholder: AssetImage('assets/ripple.gif'),
                          ),
                        ),
                      ),
                    );
                  },
                  staggeredTileBuilder: (i) =>
                      StaggeredTile.count(2, i.isEven ? 2 : 3),
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                )),
    );
  }
}
