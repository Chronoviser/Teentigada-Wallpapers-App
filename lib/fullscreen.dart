import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:typed_data';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Fullscreen extends StatefulWidget {
  final String imageURL;

  Fullscreen({this.imageURL});

  @override
  _FullscreenState createState() => _FullscreenState();
}

class _FullscreenState extends State<Fullscreen> {
  var filepath;
  bool downloading = false;
  String status = 'hello';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return downloading
        ? Scaffold(
            backgroundColor: Colors.black,
            body: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.black54, Colors.white30],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitFoldingCube(
                    color: Colors.white,
                    size: 125,
                  ),
                  SizedBox(height: 50),
                  Text(status,
                      style: TextStyle(color: Colors.white, fontSize: 24))
                ],
              ),
            ),
          )
        : Scaffold(
            body: Stack(
              children: [
                Hero(
                  tag: widget.imageURL,
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Image.network(widget.imageURL, fit: BoxFit.cover)),
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.transparent,
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: _downloadUsingGallerySaver,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Colors.black.withOpacity(0.5),
                                  Colors.black38.withOpacity(0.5)
                                ]),
                                borderRadius: BorderRadius.circular(30)),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Column(
                                children: [
                                  Text(
                                    "Download",
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 16),
                                  ),
                                  Text("save to gallery",
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.7),
                                          fontSize: 14))
                                ],
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("cancel",
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.7))),
                          ),
                        ),
                        SizedBox(height: 10)
                      ],
                    ))
              ],
            ),
          );
  }

  _downloadUsingGallerySaver() async {
    await _askPermission();
    setState(() {
      downloading = true;
      status = 'downloading...';
    });
    var response = await Dio().get(widget.imageURL,
        options: Options(responseType: ResponseType.bytes));
    final result =
        await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));

    setState(() {
      downloading = false;
      status = 'complete ✔';
    });
    Fluttertoast.showToast(
        msg: status,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.black.withOpacity(0.8),
        textColor: Colors.white,
        fontSize: 14.0);
  }

  _askPermission() async {
    PermissionStatus status = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (status != PermissionStatus.granted) {
      await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    }
  }
}
