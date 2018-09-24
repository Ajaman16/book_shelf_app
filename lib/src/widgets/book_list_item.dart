import 'package:book_shelf_app/src/data/BookDb.dart';
import 'package:book_shelf_app/src/data/repository.dart';
import 'package:book_shelf_app/src/models/book_model.dart';
import 'package:book_shelf_app/src/screens/book_detail_page.dart';
import 'package:flutter/material.dart';
import '../utils/fade_route.dart';

class BookItem extends StatefulWidget {

  Book book;

  BookItem({this.book});

  @override
  _BookItemState createState() => _BookItemState();
}

class _BookItemState extends State<BookItem> {

  Book book;

  @override
  void initState() {
    super.initState();
    book = widget.book;

  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(
            FadeRoute(builder: (context){
              return BookDetailPage(book: book,);
            })
        );
      },
      child: Card(
        child: Container(
          height: 200.0,
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              book.imageURL != null
                  ? Hero(tag: book.id, child: Image.network(book.imageURL))
                  : Container(),

              Expanded(
                  child: Container(
                    child: Stack(
                      children: <Widget>[

                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                              icon: Icon(book.starred ? Icons.star : Icons.star_border),
                              onPressed: () => onStarPressed()
                          ),
                        ),

                        Align(
                          child: Text(
                            book.title,
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

  void onStarPressed() {
    setState(() {
      book.starred = !book.starred;
    });

    book.starred ? Repository.get().db.addBook(book) : Repository.get().db.deleteBook(book.id);
  }
}
