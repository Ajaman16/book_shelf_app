import 'package:book_shelf_app/src/screens/saved_books_page.dart';
import 'package:book_shelf_app/src/utils/fade_route.dart';
import 'package:book_shelf_app/src/widgets/book_list_item.dart';
import 'package:flutter/material.dart';
import '../models/book_model.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../data/repository.dart';

class SearchBooksPage extends StatefulWidget {
  @override
  _SearchBooksPageState createState() => _SearchBooksPageState();
}

class _SearchBooksPageState extends State<SearchBooksPage> {

  List<Book> list = List();
  bool _isLoaded = true;

  final PublishSubject subject = PublishSubject<String>();

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    subject.stream.debounce(Duration(milliseconds: 600)).listen(_fetchBooks);
  }

  void _fetchBooks(query){

    clearList();

    if(query.isEmpty)
      {
        setState(() {
          _isLoaded = true;
        });
      }
    setState(() {
      _isLoaded = false;
    });
    
    /*http.get("$apiURL$query")
      .then((res) => res.body)
      .then(json.decode)
      .then((map) => map["items"])
      .then((list) => list.forEach(_addBook))
      .catchError(onError)
      .then((e){
        setState(() {
          _isLoaded = true;
        });
      });*/

    Repository.get().getBooks(query)
        .then((parsedRes){
          setState(() {
            _isLoaded = true;

            if(parsedRes.isOk())
              {
                list = parsedRes.body;
              }
            else
              {
                scaffoldKey.currentState.showSnackBar(SnackBar(content: new Text("Something went wrong, check your internet connection")));
              }

          });
        });
        //.catchError(onError);

  }

  void onError(e){
    setState(() {
      _isLoaded = true;
    });
    print(e.toString());
  }

  /*void _addBook(book){
    setState(() {
      list.add(Book.fromJSON(book));
    });
  }*/

  void clearList() {
    setState(() {
      list.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Book Search"),
      ),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          TextField(
            onChanged: (value){
              subject.add(value);
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter book title here",
            ),
          ),

          Padding(padding: EdgeInsets.only(top: 10.0),),
          _isLoaded ? Container() : CircularProgressIndicator(),

          Expanded(
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index){
                  return BookItem(book: list[index]);
                }
              )
          )

        ],
      ),
    );
  }

  @override
  void dispose() {
    subject.close();
    super.dispose();
  }


}
