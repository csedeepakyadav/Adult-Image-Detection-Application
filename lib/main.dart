import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Adult Image Detection'),
        ),
        body: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String fileName;
  String result;

  TextEditingController _nameController = TextEditingController();

  knowResult(String url) async {
    final response = await http.get(
      'https://moderatecontent-adult-image-detection-v1.p.rapidapi.com/api/v2?url=$url',
      headers: {
        "X-RapidAPI-Host":
            "moderatecontent-adult-image-detection-v1.p.rapidapi.com",
        "X-RapidAPI-Key": "a29ac21fabmsh82de3b391187b03p1a9d95jsn09596bfc5528"
      },
    );

    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);

      result = responseJson['rating_label'].toString();

      // print(result);

      if (result == 'everyone') {
        showColoredToast();
      }
      setState(() {});
    }
  }

  void showColoredToast() {
    Fluttertoast.showToast(
        msg: "Image uploaded successfully.",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.green,
        textColor: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8),
              child: Center(
                  child: _nameController.text == null
                      ? Text('No image selected.')
                      : result == 'adult'
                          ? Text(
                              'Image is 18+ hence can\'t be uploaded. \n Upload another image.',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            )
                          : Image.network(_nameController.text)),
            ),
            Container(
              padding: EdgeInsets.all(8),
              color: Colors.purpleAccent,
              child: Center(
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: "image url",
                    hintStyle: TextStyle(fontSize: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                    contentPadding: EdgeInsets.all(12),
                    fillColor: Colors.white,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: Center(
                child: RaisedButton(
                  child: Text('upload'),
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: () {
                    knowResult(_nameController.text);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
