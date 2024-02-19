import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:yazar/model/book.dart';

class LocalDataBase {
  LocalDataBase._privateConstructor();
  static final LocalDataBase _object = LocalDataBase._privateConstructor();

  factory LocalDataBase() {
    return _object;
  }
  Database? _database;
  final String _booksTableName = "Books";
  final String _idBooks = "id";
  final String _nameBooks = "name";
  final String _createdTime = "createdTime";

  Future<Database?> _getDataBase() async {
    if (_database == null) {
      String path = await getDatabasesPath();
      String databasePath = join(path, 'yazar.db');
      _database = await openDatabase(
        databasePath,
        version: 1,
        onCreate: _createTable,
      );
    }
    return _database;
  }

  Future<void> _createTable(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $_booksTableName ($_idBooks INTEGER  UNIQUE PRIMARY KEY AUTOINCREMENT, $_nameBooks TEXT NOT NULL, $_createdTime INTEGER)');
  }

  // CRUD İşlemleri

  // Yeni bir veri eklemek için kullanılır.
  Future<int> createdBook(Book book) async {
    try {
      Database? db = await _getDataBase();
      if (db != null) {
        return await db.insert(_booksTableName, book.toMap());
      } else {
        return -1;
      }
    } catch (e) {
      print(e.toString());
      return -1;
    }
  }

  // Tüm verileri okumak için kullanılır.
  Future<List<Book>> readAllBooks() async {
    Database? db = await _getDataBase();
    List<Book> _books = [];

    if (db != null) {
      List<Map<String, dynamic>> booksMap = await db.query(_booksTableName);
      for (Map<String, dynamic> book in booksMap) {
        Book _k = Book.fromMap(book);
        _books.add(_k);
      }
    }
    return _books;
  }

// Veri güncellemek için kullanılır.
  Future<int> updateBook(Book book) async {
    Database? db = await _getDataBase();
    if (db != null) {
      return await db.update(
        _booksTableName,
        book.toMap(),
        where: '$_idBooks = ?',
        whereArgs: [book.id],
      );
    } else {
      return -1;
    }
  }

// Veri silmek için kullanılır.
  Future<int> deleteBook(Book book) async {
    Database? db = await _getDataBase();
    if (db != null) {
      return await db.delete(
        _booksTableName,
        where: '$_idBooks = ?',
        whereArgs: [book.id],
      );
    } else {
      return -1;
    }
  }
}
