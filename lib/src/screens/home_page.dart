import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BookShelf"),
        actions: <Widget>[

          IconButton(
              icon: Icon(Icons.search),
              onPressed: (){
                Navigator.of(context).pushNamed("/search");
              }
          ),

          IconButton(
              icon: Icon(Icons.collections_bookmark),
              onPressed: (){
                Navigator.of(context).pushNamed("/saved");
              }
          )
        ],
      ),
      
      body: Center(
        child: Text("Hello World")
      ),
    );
  }
}
