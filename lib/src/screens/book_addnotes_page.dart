import 'package:book_shelf_app/src/models/book_model.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class BookAddNotePage extends StatefulWidget {

  Book book;

  BookAddNotePage({this.book});

  @override
  _BookAddNotePageState createState() => _BookAddNotePageState();
}

class _BookAddNotePageState extends State<BookAddNotePage> {

  Book book;
  
  final PublishSubject subject = PublishSubject<String>();

  @override
  void initState() {
    super.initState();
    book = widget.book;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Notes"),
      ),

      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          book.imageURL == null
              ? Container()
              : Hero(tag: book.id,
                  child: Image.network(
                    book.imageURL,
                  ),
                ),

        ],
      ),
    );
  }
}
