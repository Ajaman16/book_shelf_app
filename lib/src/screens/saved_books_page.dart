import 'package:book_shelf_app/src/data/BookDb.dart';
import 'package:book_shelf_app/src/models/book_model.dart';
import 'package:book_shelf_app/src/screens/book_addnotes_page.dart';
import 'package:book_shelf_app/src/screens/book_detail_page.dart';
import 'package:book_shelf_app/src/utils/fade_route.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import '../data/repository.dart';

class SavedBooksPage extends StatefulWidget {
  @override
  _SavedBooksPageState createState() => _SavedBooksPageState();
}

class _SavedBooksPageState extends State<SavedBooksPage> {

  List<Book> filteresList = List();
  List<Book> cachedList = List();

  final PublishSubject subject = PublishSubject<String>();


  @override
  void initState() {
    super.initState();

    filteresList = [];

    subject.stream.listen(getData);

    setupList();
  }

  void setupList()async{
    filteresList = await Repository.get().db.fetchAllBooks();

    setState(() {
      cachedList = filteresList;
    });
  }

  void getData(query){
    if(query.isEmpty)
      {
        setState(() {
          filteresList = cachedList;
        });
      }

    setState(() {});
    filteresList = filteresList.where((book){
      return book.title.toLowerCase().trim().contains(RegExp(r'' + query.toLowerCase().trim() + ''));
    }).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Collection"),
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
              hintText: "Search for books",
              border: OutlineInputBorder()
            ),
          ),

          Padding(padding: EdgeInsets.only(top: 10.0),),

          Expanded(
            child: ListView.builder(
              itemCount: filteresList.length,
              itemBuilder: (context, index){
                  return SavedBookItem(context, index);
              }
            ),
          )
        ],
      ),
    );
  }

  Widget SavedBookItem(BuildContext context, int index) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(
            FadeRoute(builder: (context){
              return BookAddNotePage(book: filteresList[index],);
            })
        );
      },
      child: Card(
        child: Container(
          height: 200.0,
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              filteresList[index].imageURL != null
                  ? Hero(tag: filteresList[index].id, child: Image.network(filteresList[index].imageURL))
                  : Container(),

              Expanded(
                  child: Container(
                    child: Stack(
                      children: <Widget>[

                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => onDeletePressed(index)
                          ),
                        ),

                        Align(
                          child: Text(
                            filteresList[index].title,
                            maxLines: 10,
                          ),
                          alignment: Alignment.center,
                        ),

                      ],
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }

  void onDeletePressed(int index) {
    Repository.get().db.deleteBook(filteresList[index].id);

    setState(() {
      filteresList.remove(filteresList[index]);
    });
  }

  @override
  void dispose() {
    subject.close();
    super.dispose();
  }
}
