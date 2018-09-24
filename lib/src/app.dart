import 'package:book_shelf_app/src/screens/search_books_page.dart';
import 'package:book_shelf_app/src/screens/home_page.dart';
import 'package:book_shelf_app/src/screens/saved_books_page.dart';
import 'package:flutter/material.dart';

class BookShelf extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "BookShelf App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      routes: {
        "/": (BuildContext context) => HomePage(),
        "/search": (BuildContext context) => SearchBooksPage(),
        "/saved": (BuildContext context) => SavedBooksPage(),
      },
    );
  }
}
