import 'dart:convert';
import 'dart:async';
import '../models/book_model.dart';
import 'BookDb.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class ParsedResponse<T> {
  ParsedResponse(this.statusCode, this.body);
  final int statusCode;
  final T body;

  bool isOk() {
    return statusCode >= 200 && statusCode < 300;
  }
}

final int NO_INTERNET = 404;

class Repository{
  static final Repository _repo = Repository._internal();

  BookDb db;

  Repository._internal(){
    db = BookDb();
  }

  static Repository get(){
    return _repo;
  }

  Future<ParsedResponse<List<Book>>> getBooks(String query)async{
    
    http.Response response = await http.get("$apiURL$query");
    
    if(response == null)
      {
        return ParsedResponse(NO_INTERNET, []);
      }

    if(response.statusCode < 200 || response.statusCode >= 300)
      {
        return new ParsedResponse(response.statusCode, []);
      }

    List<dynamic> list = json.decode(response.body)["items"];

    Map<String, Book> networkBookMap = {};

    list.forEach((bk){
      Book book = Book.fromJSON(bk);
      networkBookMap[book.id] = book;
    });

    List<Book> listDb = await db.fetchBooksbyId(networkBookMap.keys.toList());

    listDb.forEach((book){
      networkBookMap[book.id] = book;
    });

    return ParsedResponse(response.statusCode, networkBookMap.values.toList());

  }

}
