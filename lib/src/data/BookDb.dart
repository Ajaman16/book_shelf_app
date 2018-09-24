import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:async';
import '../models/book_model.dart';
import 'dart:io';

class BookDb{

  static final BookDb _instance = BookDb._internal();

  factory BookDb() => _instance;

  static Database _db;

  final String _tableName = "Books";

  Future<Database> get db async{

    if(_db != null)
      return _db;

    _db = await initDb();

    return _db;

  }

  BookDb._internal();

  Future<Database> initDb() async{
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "main.db");

    var db = openDatabase(
        path,
        version: 1,
        onCreate: (Database mydb, int version){
          mydb.execute("""
            CREATE TABLE $_tableName
            (
              id TEXT PRIMARY KEY,
              title TEXT,
              imageURL TEXT,
              notes TEXT,
              starred INTEGER
            );
          """);
        }
    );

    return db;
  }

  Future<int> addBook(Book book)async{

    try{
      var dbCLient = await db;
      int res = await dbCLient.insert(
        _tableName,
        book.toMapforDb(),
        //conflictAlgorithm: ConflictAlgorithm.ignore
      );
      print("book added");
      return res;
    }
    catch(e){
      print(e.toString());
      return updateBook(book);
    }


  }

  Future<int> updateBook(Book book)async{

    var dbCLient = await db;

    return dbCLient.update(
        _tableName,
        book.toMapforDb(),
        where: 'id=?',
        whereArgs: [book.id]
    );

  }

  Future<int> deleteBook(String id)async{

    var dbCLient = await db;

    return dbCLient.delete(
        _tableName,
        where: 'id=?',
        whereArgs: [id]
    );

  }

  Future<List<Book>> fetchAllBooks()async{
    var dbClient = await db;
    List<Map> res = await dbClient.query(_tableName);
    return res.map((m) => Book.fromDb(m)).toList();
  }

  Future<List<Book>> fetchBooksbyId(List<String> ids)async{
    var dbClient = await db;
    var str = ids.map((s) => '"$s"').join(",");

    List<Map> res = await dbClient.rawQuery("""
      SELECT * FROM $_tableName
      WHERE id IN ($str);
    """);
    return res.map((m) => Book.fromDb(m)).toList();
  }

  Future<Book> fetchBook(String id)async{
    var dbClient = await db;
    var res = await dbClient.query(
        _tableName,
        where: "id=?",
        whereArgs: [id]
    );

    if(res.length == 0)
      return null;

    return Book.fromDb(res[0]);

  }

  Future<dynamic> closeDb()async{
    var dbCLient = await db;
    return dbCLient.close();
  }

}