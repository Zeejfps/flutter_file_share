import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:file_share/file_share.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('File Share Example App'),
        ),
        body: _HomePage(),
      ),
    );
  }
}

class _HomePage extends StatefulWidget {
  @override
  __HomePageState createState() => __HomePageState();
}

class __HomePageState extends State<_HomePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            onPressed: _shareTextFile,
            child: Text("Share Text File"),
          ),
          RaisedButton(
            onPressed: _shareImageFile,
            child: Text("Share Image File"),
          ),
        ],
      ),
    );
  }

  _shareTextFile() async {
    var pathToFile = await _copyAssetToTempDir("assets/test.txt");

    try {
      await FileShare.share(pathToFile, "*", title: "Sharing a text file");
      _showSnackBar("Text File shared!");
    } on Exception catch (e) {
      print(e);
    }
  }

  _shareImageFile() async {
    var pathToFile = await _copyAssetToTempDir("assets/img.png");

    try {
      await FileShare.share(pathToFile, "image/png", title: "Sharing an image");
      _showSnackBar("Image File shared!");
    } on Exception catch (e) {
      print(e);
      _showSnackBar("Failed to share an image!");
    }
  }

  Future<String> _copyAssetToTempDir(String asset) async {
    var tempDir = await getTemporaryDirectory();
    var assetBytes = await rootBundle.load(asset);
    var fileName = asset.substring(asset.lastIndexOf('/'));
    var filePath = "${tempDir.path}/$fileName";
    var file = new File(filePath);
    if (! await file.exists()) {
      await file.writeAsBytes(assetBytes.buffer.asUint8List());
    }
    return filePath;
  }

  _showSnackBar(text) {
    final snackBar = SnackBar(
      content: Text(text),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
