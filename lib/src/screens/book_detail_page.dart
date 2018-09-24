import 'package:book_shelf_app/src/models/book_model.dart';
import 'package:flutter/material.dart';

class BookDetailPage extends StatefulWidget {

  Book book;

  BookDetailPage({this.book});

  @override
  _BookDetailPageState createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {

  Book book;

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
                )

        ],
      ),
    );
  }
}
