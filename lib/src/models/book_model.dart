import 'package:meta/meta.dart';

class Book{
  String title, imageURL, id, notes;
  bool starred;

  Book({@required this.id,
      @required this.title,
      @required this.imageURL,
      this.notes,
      this.starred
  });

  Book.fromJSON(Map book):
      id = book["id"],
      title = book["volumeInfo"]["title"] ?? "title not found!",
      imageURL = book["volumeInfo"]["imageLinks"]["thumbnail"],
      notes = "",
      starred = false;

  Book.fromDb(Map book):
        id = book["id"],
        title = book["title"],
        imageURL = book["imageURL"],
        notes = book["notes"],
        starred = book["starred"] == 1;


  Map<String, dynamic> toMapforDb(){
    return <String, dynamic>{
      "id": id,
      "title": title ?? "",
      "imageURL": imageURL ?? "",
      "notes": notes ?? "",
      "starred": starred ? 1 : 0
    };
  }
  
}